//
//  Server+MKAnnotation.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-01-19.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "Server+MKAnnotation.h"

@implementation Server (MKAnnotation)


- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D position;
    
    if ([self.logList numberOfRecords] > 0) {
        LogRecord *record = [self.logList recordAtIndex:0];
        if (record) {
            position.latitude = [[record getValueForKey:LOGRECORDLATITUDE] doubleValue];
            position.longitude = [[record getValueForKey:LOGRECORDLONGITUDE] doubleValue];
        }
    }
    return position;
}

- (NSString *)title
{
    return self.serverDescription;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@:%d", self.serverName, self.portNumber];
}

@end
