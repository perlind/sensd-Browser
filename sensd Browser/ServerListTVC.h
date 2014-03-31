//
//  Server ListTVC.h
//  Showoff
//
//  Created by Per Lindgren on 2013-09-29.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerList.h"
//#import "ShowoffServerViewController.h"

@interface ServerListTVC : UITableViewController 


@property (nonatomic, strong, readonly) ServerList *servers;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
