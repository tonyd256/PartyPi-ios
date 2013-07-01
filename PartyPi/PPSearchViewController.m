//
//  PPSearchViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/30/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPSearchViewController.h"
#import "PPSongViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

static NSString *kSpotifySearchURL = @"http://ws.spotify.com/search/1/track.json?q=";

@interface PPSearchViewController ()

@end

@implementation PPSearchViewController {
    NSArray *results;
    NSString *selectedURL;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 1) {
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kSpotifySearchURL stringByAppendingString:searchText]]];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
    }
}

- (void)fetchedData:(NSData *)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    results = [json objectForKey:@"tracks"];
    [self.tableView reloadData];
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
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubtitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[results objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [[[[results objectAtIndex:indexPath.row] objectForKey:@"artists"] objectAtIndex:0] valueForKey:@"name"], [[[results objectAtIndex:indexPath.row] valueForKey:@"album"] valueForKey:@"name"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedURL = [[results objectAtIndex:indexPath.row] valueForKey:@"href"];
    [self performSegueWithIdentifier:@"SongSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SongSegue"]) {
        PPSongViewController *view = segue.destinationViewController;
        view.trackURL = selectedURL;
    }
}

@end
