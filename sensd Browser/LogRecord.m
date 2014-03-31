//
//  LogRecord.m
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import "LogRecord.h"

@interface LogRecord ()

@property (nonatomic, readwrite) NSInteger seqNum;

@property (nonatomic, strong, readwrite ) NSString              *originalLogString;

@property (nonatomic, strong, readwrite ) NSMutableArray        *logValuesKeyArray;
@property (nonatomic, strong, readwrite ) NSMutableArray        *logValuesDataArray;

@property (nonatomic, strong, readwrite ) NSMutableArray        *timeStampKeyArray;
@property (nonatomic, strong, readwrite ) NSMutableArray        *timeStampDataArray;

@property (nonatomic, strong, readwrite ) NSMutableArray        *nodeInfoKeyArray;
@property (nonatomic, strong, readwrite ) NSMutableArray        *nodeInfoDataArray;

@end



@implementation LogRecord


@synthesize timeStampKeyArray = _timeStampKeyArray;
@synthesize timeStampDataArray = _timeStampDataArray;
@synthesize logValuesKeyArray = _logValuesKeyArray;
@synthesize logValuesDataArray = _logValuesDataArray;
@synthesize nodeInfoKeyArray = _nodeInfoKeyArray;
@synthesize nodeInfoDataArray = _nodeInfoDataArray;
@synthesize seqNum = _seqNum;


- (id) initWithString:(NSString *)logString
{
    self = [super init];
    
    _originalLogString = [logString copy];

    _logValuesKeyArray = [[NSMutableArray alloc] init];
    _logValuesDataArray = [[NSMutableArray alloc] init];
    _timeStampKeyArray = [[NSMutableArray alloc] init];
    _timeStampDataArray = [[NSMutableArray alloc] init];
    _nodeInfoKeyArray = [[NSMutableArray alloc] init];
    _nodeInfoDataArray = [[NSMutableArray alloc] init];
    
    _seqNum = -1;
    
    [self parseLogString];
    
    return self;
}


- (void) divideStringIntoValuePairs:(NSString *)string intoKeyArray:(NSMutableArray *)keyArray intoDataArray:(NSMutableArray *)dataArray
{
    NSArray *values = [string componentsSeparatedByString:@" "];
    if ([values count] > 0) {
        for (NSString *s in values) {
            NSArray *pair = [s componentsSeparatedByString:@"="];
            if ([pair count] == 2) {
                if (keyArray && dataArray) {
                    [keyArray addObject:pair[0]];
                    [dataArray addObject:pair[1]];
                    // Check for some special values. These are encoded as meta data for the record
                    // SEQ sequence number, so duplicates can be discarded easily
                    if ([pair[0] isEqualToString:@"SEQ"]) {
                        self.seqNum = [pair[1] integerValue];
                    }
                }
            } //else
              //  NSLog(@"LogRecord:divideStringIntoValuePairs: Error parsing value-pair '%@'", s);
        }
    } else
        NSLog(@"LogRecord:divideStringIntoValuePairs: Error dividing into value-pairs '%@'", string);
}


- (void) makeTimeStampFromString:(NSString *)s
{
    // The "incoming" string "s" probably has trailing spaces which we'll remove first
    NSInteger stringlength = [s length];
    while (stringlength > 2 && [s characterAtIndex:stringlength - 1] == ' ') {
        s = [s substringToIndex:stringlength-1];
        stringlength--;
    }

    NSArray *values = [s componentsSeparatedByString:@" "];
    if ([values count] >= 2) {
        // Date YYYY-MM-DD
        [self.timeStampKeyArray addObject:LOGRECORDDATE];
        [self.timeStampDataArray addObject:values[0]];
        // Time of day HH:MM:SS
        [self.timeStampKeyArray addObject:LOGRECORDTIME];
        [self.timeStampDataArray addObject:values[1]];

        for (int i = 2; i < [values count]; i++) {
            [self divideStringIntoValuePairs:values[i]
                                intoKeyArray:self.timeStampKeyArray
                               intoDataArray:self.timeStampDataArray];
        }
    }
}

- (void) parseLogString
{
    // A typical log entry looks like this:
    // 2013-12-18 21:19:36 TZ=CET UT=1387397976 GWGPS_LON=17.36876 GWGPS_LAT=59.51040 &:  \
    // E64=fcc23d0000015fd6 PS=0 T=22.56  V_MCU=3.00 UP=191194 V_IN=7.39  V_A3=1023  [ADDR=17.22 \
    // SEQ=203 RSSI=39 LQI=255 DRP=1.00]
    //
    // I.e. DATE TIME TZ UT LONG LAT "&:" { VALUE-PAIRS }* | { VALUE-PAIRS }* "[" { VALUE-PAIRS }* "]"
    //
    // First se if we have a "&:" to separate timestamp and location from the data
    //
    
    NSString *logstring = self.originalLogString;

    if (logstring) {
        NSArray * stringParts = [self.originalLogString componentsSeparatedByString:@"&:"];
        
        if ([stringParts count] == 2) {
            // OK. First part should be timestamp info "yyyy-mm-dd hh:mm:ss TZ=CEST UT=123456788" etc
            [self makeTimeStampFromString:stringParts[0]];
            // Store whats after the "&:" in logstring and continue to next test
            logstring = stringParts[1];
        } else if ([stringParts count] != 0){
            NSLog(@"LogRecord: parseLogString: &:-check failed");
        }
        
        // Next, check for log string ending with "...[ADDR=1.2 ...]"
        stringParts = [logstring componentsSeparatedByString:@"["];

        // stringParts[0] is always the log values, regardless if "[ADDR=1.2 ...]" follows
        [self divideStringIntoValuePairs:stringParts[0] intoKeyArray:self.logValuesKeyArray intoDataArray:self.logValuesDataArray];
        
        if ([stringParts count] == 2) {
            // Yes, we have a log entry ending with "[ADDR=1.2 ...]"
            // stringParts[1] is then the node info values
            // First remove ending "]" from stringParts[1], then ...
            NSString *trimmedString = [stringParts[1] substringToIndex:[stringParts[1] length] - 1];
            // ... store the values in the nodeInfo* variables
            [self divideStringIntoValuePairs:trimmedString intoKeyArray:self.nodeInfoKeyArray intoDataArray:self.nodeInfoDataArray];
        }
    }
}



- (NSString *) description
{
    return self.originalLogString;
}


- (NSString *) getValueForKey:(NSString *)key
{
    NSString *s;
    NSUInteger i = [self.logValuesKeyArray indexOfObject:key];
    
    if (i !=  NSNotFound)
        s = self.logValuesDataArray[i];
    else {
        i = [self.timeStampKeyArray indexOfObject:key];
        if (i != NSNotFound)
            s = self.timeStampDataArray[i];
        else {
            i = [self.nodeInfoKeyArray indexOfObject:key];
            if (i != NSNotFound)
                s = self.nodeInfoDataArray[i];
        }
    }
    return s;
}

- (NSString *) getTimeStampKeyAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.timeStampKeyArray count]) {
        s = self.timeStampKeyArray[index];
    }
    return s;
}

- (NSString *) getTimeStampDataAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.timeStampDataArray count]) {
        s = self.timeStampDataArray[index];
    }
    return s;
}

- (NSUInteger) getTimeStampCount
{
    return [self.timeStampKeyArray count];
}


- (NSString *) getLogValueKeyAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.logValuesKeyArray count]) {
        s = self.logValuesKeyArray[index];
    }
    return s;
}

- (NSString *) getLogValueDataAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.logValuesDataArray count]) {
        s = self.logValuesDataArray[index];
    }
    return s;
}

- (NSUInteger) getLogValueCount
{
    return [self.logValuesKeyArray count];
}


- (NSString *) getNodeInfoKeyAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.nodeInfoKeyArray count]) {
        s = self.nodeInfoKeyArray[index];
    }
    return s;
}

- (NSString *) getNodeInfoDataAtIndex:(NSUInteger)index
{
    NSString *s;
    
    // don't ask for key beyond end of array. arrays are 0-indexed
    if (index < [self.nodeInfoDataArray count]) {
        s = self.nodeInfoDataArray[index];
    }
    return s;
}

- (NSUInteger) getNodeInfoCount
{
    return [self.nodeInfoKeyArray count];
}


@end
