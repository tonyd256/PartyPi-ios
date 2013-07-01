//
//  PPSongViewController.h
//  PartyPi
//
//  Created by Tony DiPasquale on 6/30/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUDPClient.h"

@interface PPSongViewController : UIViewController <PPUDPClientDelegate>

@property (strong, nonatomic) NSString *trackURL;

@property (strong, nonatomic) IBOutlet UIImageView *trackImage;
@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *trackArtistAlbum;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonAction:(id)sender;

@end
