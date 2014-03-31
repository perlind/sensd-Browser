//
//  Server.h
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogList.h"

@interface Server : NSObject <NSStreamDelegate>


@property (nonatomic, strong, readwrite) NSString       *serverDescription;
@property (nonatomic, strong, readonly) NSString       *serverName;
@property (nonatomic, assign, readwrite) NSUInteger     portNumber;
@property (nonatomic, assign, readwrite) BOOL           autoConnect;
@property (nonatomic, strong, readonly) NSInputStream   *streamToServer;
@property (nonatomic, strong, readonly) LogList         *logList;
@property (nonatomic, readonly) NSUInteger              streamStatus;
@property (nonatomic, strong, readonly) NSString        *streamStatusString;
@property (nonatomic, strong, readwrite) UITableView    *tableView;
@property (nonatomic, assign, readonly) BOOL            isConnectedToServer;

#define ServerStreamStatusClosed 1
#define ServerStreamStatusOpening 2
#define ServerStreamStatusOpen 3
#define ServerStreamStatusOpenWithError 4

#define SERVER_v1_DESCRIPTION @"server_description"
#define SERVER_v1_SERVERNAME @"server_servername"
#define SERVER_v1_PORTNUMBER @"server_portnumber"
#define SERVER_v1_MAXRECORDS @"server_maxrecords"
#define SERVER_v1_AUTOCONNECT @"server_autoconnect"

- (id) initWithServer:(NSString *)server description:(NSString *)desc atPortnumer:(NSUInteger)port maximumLogEntries:(NSUInteger)maxLogSize connectOnStartup:(BOOL)connectFlag;

- (void) openStreamToServer;
- (void) closeStreamToServer;

- (NSDictionary *) getServerInfoAsDictionary;

- (void) updateServerDescription:(NSString*)newServerDescription;
- (void) updateServerName:(NSString*)newServerName;
- (void) updateServerPortNumber:(NSUInteger)newPortNumber;
- (void) updateLogMaxSize:(NSUInteger)newMaxLogSize;
- (void) updateConnectFlag:(BOOL)newConnectFlag;


@end
