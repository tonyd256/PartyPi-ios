//
//  PPJukeboxesViewController.h
//  PartyPi
//
//  Created by Tony DiPasquale on 6/28/13.
//  Copyright (c) 2013 Tony DiPasquale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPUDPClient.h"

@interface PPJukeboxesViewController : UITableViewController <PPUDPClientDelegate>

- (IBAction)refreshButtonAction:(id)sender;

@end
