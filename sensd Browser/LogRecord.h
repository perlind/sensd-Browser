//
//  LogRecord.h
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGRECORDDATE @"Date"
#define LOGRECORDTIME @"Time"
#define LOGRECORDTIMEZONE @"TZ"
#define LOGRECORDUNIXTIME @"UT"
#define LOGRECORDLATITUDE @"GWGPS_LAT"
#define LOGRECORDLONGITUDE @"GWGPS_LON"
#define LOGRECORDE64 @"E64"
#define LOGRECORDID @"ID"

@interface LogRecord : NSObject

@property (nonatomic, readonly) NSInteger seqNum;

- (id) initWithString:(NSString *)logString;

- (NSString *) description;

- (NSString *) getValueForKey:(NSString *)key;

- (NSString *) getTimeStampKeyAtIndex:(NSUInteger)index;
- (NSString *) getTimeStampDataAtIndex:(NSUInteger)index;
- (NSUInteger) getTimeStampCount;

- (NSString *) getLogValueKeyAtIndex:(NSUInteger)index;
- (NSString *) getLogValueDataAtIndex:(NSUInteger)index;
- (NSUInteger) getLogValueCount;

- (NSString *) getNodeInfoKeyAtIndex:(NSUInteger)index;
- (NSString *) getNodeInfoDataAtIndex:(NSUInteger)index;
- (NSUInteger) getNodeInfoCount;

@end




