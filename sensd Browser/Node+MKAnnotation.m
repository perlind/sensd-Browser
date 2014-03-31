//
//  Node+MKAnnotation.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-03.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "Node+MKAnnotation.h"


@implementation Node (MKAnnotation)


- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D position;
    
    if (!self.doneCoordinateCalculation) {
        if ([self.logList numberOfRecords] > 0) {
            LogRecord *record = [self.logList recordAtIndex:0];
            if (record) {
                position.latitude = [[record getValueForKey:LOGRECORDLATITUDE] doubleValue];
                position.longitude = [[record getValueForKey:LOGRECORDLONGITUDE] doubleValue];
                self.cachedLocation = position;
                self.doneCoordinateCalculation = YES;
            }
        }
    } else
        position = self.cachedLocation;
    
    return position;
}

- (NSString *)title
{
    return self.nodeTXT;
}

- (NSString *)subtitle
{
    return self.fromServerInfo;
}

@end
