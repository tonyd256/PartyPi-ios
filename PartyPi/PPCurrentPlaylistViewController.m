//
//  PPCurrentPlaylistViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 7/1/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPCurrentPlaylistViewController.h"
#import "PPSongViewController.h"

@interface PPCurrentPlaylistViewController ()

@end

@implementation PPCurrentPlaylistViewController {
    NSArray *tracks;
    NSString *selectedURL;
}

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
    [[PPUDPClient sharedClient] sendCommand:@"getCurrentPlaylist"];
}

-(void)dataReceived:(NSDictionary *)data {
    if ([[data valueForKey:@"response"] isEqualToString:@"getCurrentPlaylist"]) {
        tracks = [data objectForKey:@"data"];
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

- (IBAction)clearButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"clearCurrentPlaylist"];
    tracks = nil;
    [self.tableView reloadData];
}
@end
