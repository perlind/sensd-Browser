//
//  ServerMapViewController.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-01-19.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "ServerMapViewController.h"

@interface ServerMapViewController ()

@end

@implementation ServerMapViewController

@synthesize server = _server;

- (void) setServer:(Server *)server
{
    _server = server;
    //if (self.view.window)
    //    [self reload];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void) reload
{
    if (self.server) {
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView addAnnotation:self.server];
        self.mapView.centerCoordinate = self.server.coordinate;
    }
}

@end

