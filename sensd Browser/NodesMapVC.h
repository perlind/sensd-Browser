//
//  NodesMapVC.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-03.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "MapViewController.h"
#import "Node+MKAnnotation.h"
#import "NodeList.h"

@interface NodesMapVC : MapViewController

@property (nonatomic, strong, readonly) NodeList *nodeListCopy;

@end
