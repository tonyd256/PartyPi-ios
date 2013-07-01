//
//  PPNowPlayingViewController.m
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import "PPNowPlayingViewController.h"
#import "NSString+FontAwesome.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PPNowPlayingViewController ()

@end

@implementation PPNowPlayingViewController {
    NSDictionary *status;
    UISlider *volSlider;
    BOOL paused;
    BOOL disliked;
    NSString *nowTrack;
    NSInteger volume;
}

@synthesize jukebox = _jukebox;

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
    
    [self.volumeUpButton setTitle:[NSString fontAwesomeIconStringForEnum:FAIconVolumeUp]];
    [self.volumeUpButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:kFontAwesomeFamilyName size:22]} forState:UIControlStateNormal];
    
    [self.volumeDownButton setTitle:[NSString fontAwesomeIconStringForEnum:FAIconVolumeDown]];
    [self.volumeDownButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:kFontAwesomeFamilyName size:22]} forState:UIControlStateNormal];
    
    [self switchPlayPauseButton];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [self.userView setHidden:YES];
    } else {
        [self.dislikeButton setHidden:YES];
        [self.playlistButton setHidden:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [PPUDPClient sharedClient].delegate = self;
    [[PPUDPClient sharedClient] sendCommand:@"getStatus"];
}

-(void)dataReceived:(NSDictionary *)data {
    if ([[data valueForKey:@"response"] isEqualToString:@"getStatus"]) {
        status = [data objectForKey:@"data"];
        [self updateStatus];
    }
}

- (void)switchPlayPauseButton {
    NSMutableArray *btns = [NSMutableArray arrayWithArray:self.toolbar.items];
    
    // if all the buttons are present remove the play button at position 1
    if ([btns count] > 5) {
        [btns removeObjectAtIndex:1];
    }
    
    if (paused) {
        [btns replaceObjectAtIndex:0 withObject:self.playButton];
    } else {
        [btns replaceObjectAtIndex:0 withObject:self.pauseButton];
    }
    
    [self.toolbar setItems:btns];
}

-(void)updateStatus {
    if ([status valueForKey:@"volume"]) {
        [volSlider setValue:[(NSNumber *)[status valueForKey:@"volume"] floatValue]];
        volume = [[status valueForKey:@"volume"] integerValue];
    }
    
    if ([[status valueForKey:@"paused"] boolValue] != paused) {
        paused = [[status valueForKey:@"paused"] boolValue];        
        [self switchPlayPauseButton];
    }
    
    id track = [status objectForKey:@"track"];
    
    if (track == [NSNull null]) {
        self.trackTitle.text = @"No Song Playing";
        self.trackArtistAlbum.text = @"";
        [self.trackImage setImage:[UIImage imageNamed:@"exclamation-sign.png"]];
        disliked = NO;
        [self.dislikeButton setEnabled:YES];
        nowTrack = nil;
    } else {
        if ([track valueForKey:@"url"] != nowTrack) {
            self.trackTitle.text = [track valueForKey:@"title"];
            self.trackArtistAlbum.text = [NSString stringWithFormat:@"%@ - %@", [track valueForKey:@"artist"], [track valueForKey:@"album"]];
            [self.trackImage setImageWithURL:[[track objectForKey:@"images"] valueForKey:@"extralarge"] placeholderImage:[UIImage imageNamed:@"exclamation-sign.png"]];
            nowTrack = [track valueForKey:@"url"];
            disliked = NO;
            [self.dislikeButton setEnabled:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pauseButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"pause"];
    paused = YES;
    [self switchPlayPauseButton];
}

- (IBAction)playButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"play"];
    paused = NO;
    [self switchPlayPauseButton];
}

- (IBAction)skipButtonAction:(id)sender {
    [[PPUDPClient sharedClient] sendCommand:@"skip"];
}

- (IBAction)dislikeButtonAction:(id)sender {
    if (!disliked) {
        [[PPUDPClient sharedClient] sendCommand:@"dislike"];
        disliked = YES;
        [self.dislikeButton setEnabled:NO];
    }
}

- (IBAction)volumeUpAction:(id)sender {
    if (volume + 5 >= 100) {
        volume = 100;
    } else {
        volume += 5;
    }
    
    [[PPUDPClient sharedClient] sendCommand:@"setVolume" WithParam:[NSString stringWithFormat:@"%d", volume]];
}

- (IBAction)volumeDownAction:(id)sender {
    if (volume - 5 <= 0) {
        volume = 0;
    } else {
        volume -= 5;
    }
    
    [[PPUDPClient sharedClient] sendCommand:@"setVolume" WithParam:[NSString stringWithFormat:@"%d", volume]];
}
@end
