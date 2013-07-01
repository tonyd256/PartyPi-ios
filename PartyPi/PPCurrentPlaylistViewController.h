//
//  PPCurrentPlaylistViewController.h
//  PartyPi
//
//  Created by Tony DiPasquale on 7/1/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUDPClient.h"

@interface PPCurrentPlaylistViewController : UITableViewController <PPUDPClientDelegate>

- (IBAction)clearButtonAction:(id)sender;

@end
