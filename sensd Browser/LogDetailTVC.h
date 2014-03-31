//
//  LogDetailTVC.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-02.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogRecord.h"

@interface LogDetailTVC : UITableViewController

- (void) setLogRecord:(LogRecord *)record;

@end
