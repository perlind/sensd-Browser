//
//  ServerInfoTVC.h
//  Showoff
//
//  Created by Per Lindgren on 2013-12-15.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface ServerInfoTVC : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) Server *server;
@property (nonatomic, readonly) BOOL creatingNewServerRecord;

- (void) updateServerRecordWithViewData:(Server *)server;
- (Server *) getViewDataAsServerRecord;

@end
