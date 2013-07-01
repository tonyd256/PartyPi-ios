//
//  PPPlaylistViewController.h
//  PartyPi
//
//  Created by Tony DiPasquale on 6/30/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUDPClient.h"

@interface PPPlaylistViewController : UITableViewController <PPUDPClientDelegate>

@property (strong, nonatomic) NSString *playlistURL;

- (IBAction)addButtonAction:(id)sender;

@end
