//
//  PPJukeboxesViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPJukeboxesViewController.h"
#import "PPNowPlayingViewController.h"

@interface PPJukeboxesViewController ()

@end

@implementation PPJukeboxesViewController {
    NSMutableArray *jukeboxes;
    NSInteger selectedIndex;
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

    jukeboxes = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [jukeboxes removeAllObjects];
    [PPUDPClient sharedClient].ip = nil;
    [PPUDPClient sharedClient].delegate = self;
    [[PPUDPClient sharedClient] sendCommand:@"reportSelf"];
}

- (void)dataReceived:(NSDictionary *)data {
    if ([[data valueForKey:@"response"] isEqualToString:@"reportSelf"]) {
        [jukeboxes addObject:[data objectForKey:@"data"]];
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
    if ([jukeboxes count] == 0) {
        return 1;
    }
    return [jukeboxes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([jukeboxes count] == 0) {
        cell.textLabel.text = @"No Jukebox Found";
    } else {
        cell.textLabel.text = [[jukeboxes objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([jukeboxes count] == 0) {
        return;
    }
    [PPUDPClient sharedClient].ip = [[jukeboxes objectAtIndex:indexPath.row] valueForKey:@"ip"];
    
    [self performSegueWithIdentifier:@"NowPlayingSegue" sender:self];
}

- (IBAction)refreshButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"reportSelf"];
    [jukeboxes removeAllObjects];
    [self.tableView reloadData];
}
@end
