//
//  PPSongViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/30/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPSongViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PPSongViewController ()

@end

@implementation PPSongViewController

@synthesize trackURL = _trackURL;

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [PPUDPClient sharedClient].delegate = self;
    [[PPUDPClient sharedClient] sendCommand:@"getTrack" WithParam:self.trackURL];
}

-(void)dataReceived:(NSDictionary *)data {
    if ([[data valueForKey:@"response"] isEqualToString:@"getTrack"]) {
        id track = [data objectForKey:@"data"];
        
        self.trackTitle.text = [track valueForKey:@"title"];
        self.trackArtistAlbum.text = [NSString stringWithFormat:@"%@ - %@", [track valueForKey:@"artist"], [track valueForKey:@"album"]];
        [self.trackImage setImageWithURL:[[track objectForKey:@"images"] valueForKey:@"extralarge"] placeholderImage:[UIImage imageNamed:@"exclamation-sign.png"]];
        
        if ([[track valueForKey:@"inPlaylist"] boolValue]) {
            self.navigationItem.rightBarButtonItem = nil;
        }        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"addTrack" WithParam:self.trackURL];
    self.navigationItem.rightBarButtonItem = nil;
}
@end
