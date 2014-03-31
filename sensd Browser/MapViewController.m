//
//  MapViewController.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-01-19.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.delegate = self;
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseIdentifier = @"MapViewController";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        view.canShowCallout = YES;
    }
    
    
    return view;
}


@end
