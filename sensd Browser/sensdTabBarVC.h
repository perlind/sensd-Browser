//
//  sensdTabBarVC.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-03.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeListTVC.h"

@interface sensdTabBarVC : UITabBarController

@property (nonatomic, strong, readonly) NodeList *nodeListCopy;

- (void) setCurrentNodeList:(NodeList*)nodeList;

@end
