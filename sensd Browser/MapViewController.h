//
//  MapViewController.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-01-19.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end
