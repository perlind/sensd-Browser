//
//  ServerMapViewController.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-01-19.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "MapViewController.h"
#import "Server+MKAnnotation.h"

@interface ServerMapViewController : MapViewController

@property (nonatomic, strong, readonly) Server *server;

@end
