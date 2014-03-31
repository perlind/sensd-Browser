//
//  LogList.h
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogRecord.h"

@interface LogList : NSObject

@property (nonatomic, readonly) NSUInteger          numberOfRecords;
@property (nonatomic, readonly) NSUInteger          maxNumberOfRecords;

- (id) initWithMaximumSize:(NSUInteger)maxLogSize;

- (void) setMaximumSize:(NSUInteger)newMaxSize;

- (LogRecord *) recordAtIndex:(NSUInteger) index;

- (void) addRecord:(LogRecord *)recordObject;

- (void) clearLog;


@end
