//
//  LogList.m
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import "LogList.h"

@interface LogList ()

//@property (nonatomic, strong, readonly) NSUInteger          numberOfRecords;
@property (nonatomic, readwrite) NSUInteger                 maxNumberOfRecords;
@property (nonatomic, strong, readwrite) NSMutableArray     *listOfLogRecords;

@end

@implementation LogList


- (id) initWithMaximumSize:(NSUInteger)maxLogSize
{
    self = [super init];
    
    _listOfLogRecords = [[NSMutableArray alloc] init];
    _maxNumberOfRecords = maxLogSize;
    
    return self;
}

- (void) setMaximumSize:(NSUInteger)newMaxSize
{
    self.maxNumberOfRecords = newMaxSize;
    if (self.numberOfRecords > newMaxSize) {
        [self.listOfLogRecords removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(newMaxSize, [self numberOfRecords] - newMaxSize)]];
    
    }

}


- (NSUInteger) numberOfRecords
{
    return [self.listOfLogRecords count];
}


- (LogRecord *) recordAtIndex:(NSUInteger) index
{
    LogRecord *r = NULL;
    
    if (self.listOfLogRecords != NULL) {
        r = [self.listOfLogRecords objectAtIndex:index];
    }
    
    return r;
}



- (void) addRecord:(LogRecord *)recordObject
{
    if (self.listOfLogRecords != NULL && recordObject != NULL) {
        // If the array is "full", delete oldest record, i.e. the last one
        if ([self.listOfLogRecords count] >= self.maxNumberOfRecords)
            [self.listOfLogRecords removeLastObject];
        // Insert new records at the beginning of the array
        [self.listOfLogRecords insertObject:recordObject atIndex:0];
    }

}

- (void) clearLog
{
    [self.listOfLogRecords removeAllObjects];
}



@end
