//
//  Node.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-01.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "Node.h"
#import "LogList.h"

@interface Node ()

- (NSString *)description;

@property (nonatomic, strong, readwrite) NSString        *nodeId;
@property (nonatomic, strong, readwrite) NSString        *nodeTXT;


@end



@implementation Node

- (id) initWithId:(NSString *)nodeId fromServer:(NSString *)serverInfo
{
    self = [super init];
    _nodeId = nodeId;
    // maximumSize must be taken from default value, but that is not created yet! Until then we use "42"
    _logList = [[LogList alloc] initWithMaximumSize:42];
    _fromServerInfo = serverInfo;
    return self;
}

- (NSString *)description
{
    return self.nodeId;
}

- (void) addLogRecord:(LogRecord *)logRecord
{
    if ([self.logList numberOfRecords] == 0)
        self.nodeTXT = [logRecord getValueForKey:@"TXT"];
    [self.logList addRecord:logRecord];
}


@end
