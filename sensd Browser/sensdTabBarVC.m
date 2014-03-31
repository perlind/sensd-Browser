//
//  sensdTabBarVC.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-03.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "sensdTabBarVC.h"

@interface sensdTabBarVC ()

@property (nonatomic, strong, readwrite) NodeList *nodeListCopy;

@end

@implementation sensdTabBarVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) setCurrentNodeList:(NodeList*)nodeList;
{
    self.nodeListCopy = nodeList;
}



@end
