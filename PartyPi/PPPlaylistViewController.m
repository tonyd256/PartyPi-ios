//
//  PPPlaylistViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/30/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPPlaylistViewController.h"
#import "PPSongViewController.h"

@interface PPPlaylistViewController ()

@end

@implementation PPPlaylistViewController {
    NSArray *tracks;
    NSString *selectedURL;
}

@synthesize playlistURL = _playlistURL;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [PPUDPClient sharedClient].delegate = self;
    [[PPUDPClient sharedClient] sendCommand:@"getPlaylist" WithParam:self.playlistURL];
}

-(void)dataReceived:(NSDictionary *)data {
    if ([[data valueForKey:@"response"] isEqualToString:@"getPlaylist"]) {
        tracks = [[data objectForKey:@"data"] objectForKey:@"tracks"];
        self.title = [[data objectForKey:@"data"] valueForKey:@"name"];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubtitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[tracks objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [[tracks objectAtIndex:indexPath.row] objectForKey:@"artist"], [[tracks objectAtIndex:indexPath.row] valueForKey:@"album"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    selectedURL = [[tracks objectAtIndex:indexPath.row] valueForKey:@"url"];
    [self performSegueWithIdentifier:@"SongSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SongSegue"]) {
        PPSongViewController *view = segue.destinationViewController;
        view.trackURL = selectedURL;
    }
}

- (IBAction)addButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"addPlaylist" WithParam:self.playlistURL];
    self.navigationItem.rightBarButtonItem = nil;
}
@end
