//
//  Node.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-01.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#include "LogList.h"

@interface Node : NSObject

@property (nonatomic, strong, readonly) LogList         *logList;
@property (nonatomic, strong, readonly) NSString        *fromServerInfo;

@property (nonatomic, strong, readonly) NSString        *nodeTXT;

@property (readwrite) BOOL doneCoordinateCalculation; //defaults to NO (0)
@property (readwrite) CLLocationCoordinate2D cachedLocation;

- (id) initWithId:(NSString *)nodeId fromServer:(NSString *)serverInfo;

- (void) addLogRecord:(LogRecord *)logRecord ;

@end
