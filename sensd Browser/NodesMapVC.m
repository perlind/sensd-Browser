////
//  NodesMapVC.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-03.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "NodesMapVC.h"
#import "sensdTabBarVC.h"

@interface NodesMapVC ()

@property (nonatomic, strong, readwrite) NodeList *nodeListCopy;

@end

@implementation NodesMapVC

@synthesize nodeListCopy = _nodeListCopy;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"NodesMapVC:viewDidLoad");

    sensdTabBarVC *stb = [self getSensdTabBarVC:self];
    if (stb) {
        self.nodeListCopy = stb.nodeListCopy;
        NSLog(@"NodesMapVC:viewWillAppear: nodeList = %@", self.nodeListCopy);
    }

    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NodesMapVC:viewWillAppear");
    [self reload];

}

- (id) getSensdTabBarVC:(UIViewController*)viewController
{
    if (viewController == nil)
        return nil;
    else {
        if ([viewController isKindOfClass:[sensdTabBarVC class]])
            return viewController;
        else
            return [self getSensdTabBarVC:viewController.parentViewController];
    }
}

- (void) reload
{
    NSLog(@"NodesMapVC:reload 1");
    if (self.nodeListCopy) {
        //Node* n = [self.nodeListCopy.listOfNodes objectAtIndex:0];
        NSLog(@"NodesMapVC:reload 2");
        [self.mapView removeAnnotations:[self.mapView annotations]];
        //[self.mapView addAnnotation:n];
        [self.mapView addAnnotations:self.nodeListCopy.listOfNodes];
        //self.mapView.centerCoordinate = n.coordinate;
        //[self.mapView showAnnotations:self.nodeListCopy.listOfNodes animated:YES];
    }
}

@end

