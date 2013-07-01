//
//  PPNowPlayingViewController.h
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUDPClient.h"

@interface PPNowPlayingViewController : UIViewController <PPUDPClientDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *trackImage;
@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *trackArtistAlbum;
@property (strong, nonatomic) IBOutlet UIToolbar *volumeToolbar;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *volumeUpButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *volumeDownButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIButton *playlistButton;

@property (strong, nonatomic) NSDictionary *jukebox;

- (IBAction)pauseButtonAction:(id)sender;
- (IBAction)skipButtonAction:(id)sender;
- (IBAction)dislikeButtonAction:(id)sender;
- (IBAction)volumeUpAction:(id)sender;
- (IBAction)volumeDownAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;

@end
