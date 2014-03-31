//
//  Server.m
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import "Server.h"

@interface Server ()

@property (nonatomic, strong, readwrite) NSString       *serverName;
@property (nonatomic, strong, readwrite) NSInputStream   *streamToServer;
@property (nonatomic, readwrite) NSUInteger              streamStatus;
@property (nonatomic, strong, readwrite) NSString        *streamStatusString;
@property (nonatomic, assign, readwrite) BOOL            retryOpenConnection;

@end


@implementation Server


@synthesize streamToServer = _streamToServer;
@synthesize tableView = _tableView;


- (id) initWithServer:(NSString *)server description:(NSString *)desc atPortnumer:(NSUInteger)port maximumLogEntries:(NSUInteger)maxLogSize connectOnStartup:(BOOL)connectFlag
{
    self = [super init];
    
    if (self) {
        _serverName = server;
        _serverDescription = desc;
        _portNumber = port;
        _autoConnect = connectFlag;
        _logList = [[LogList alloc] initWithMaximumSize:maxLogSize];
        _streamToServer = nil;
        _streamStatus = ServerStreamStatusClosed;
        _streamStatusString = @"Connection closed";
        _tableView = nil;
        _retryOpenConnection = true;
    }
    
    return self;
}

// implement dealloc, to close streamToServer if it's open

- (BOOL)isConnectedToServer
{
    BOOL b;
    
    b = self.streamToServer != NULL;
    
    return b;
}

- (void) updateServerDescription:(NSString*)newServerDescription
{
    self.serverDescription = newServerDescription;
}

- (void) updateServerName:(NSString*)newServerName
{
    if (![self.serverName isEqualToString:newServerName]) {
        NSLog(@"Server:updateServerName: new address or name to server detected!");
        [self closeStreamToServer];
        self.serverName = newServerName;
        [self openStreamToServer];
        self.retryOpenConnection = true;
    }
}

- (void) updateServerPortNumber:(NSUInteger)newPortNumber
{
    if (self.portNumber != newPortNumber) {
        NSLog(@"Server:updateServerPortNumber: new port number to server detected!");
        [self closeStreamToServer];
        self.portNumber = newPortNumber;
        [self openStreamToServer];
        self.retryOpenConnection = true;
    }
    
}

- (void) updateLogMaxSize:(NSUInteger)newMaxLogSize
{
    [self.logList setMaximumSize:newMaxLogSize];
}

- (void) updateConnectFlag:(BOOL)newConnectFlag
{
    if (newConnectFlag && !self.isConnectedToServer)
        [self openStreamToServer];
    else if (!newConnectFlag && self.isConnectedToServer)
        [self closeStreamToServer];
    self.autoConnect = newConnectFlag;
}


- (NSDictionary *) getServerInfoAsDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.serverDescription forKey:SERVER_v1_DESCRIPTION];
    [dict setValue:self.serverName forKey:SERVER_v1_SERVERNAME];
    [dict setValue:[NSNumber numberWithInteger:self.portNumber] forKey:SERVER_v1_PORTNUMBER];
    [dict setValue:[NSNumber numberWithInteger:self.logList.maxNumberOfRecords] forKey:SERVER_v1_MAXRECORDS];
    [dict setValue:[NSNumber numberWithBool:self.autoConnect] forKey:SERVER_v1_AUTOCONNECT];
    
    return dict;
}


- (void) openStreamToServer
{
    if (self.retryOpenConnection) {
        NSInputStream *stream;

        CFReadStreamRef     readStream = NULL;
                    
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)self.serverName, self.portNumber, &readStream, NULL);
        assert(readStream);
        stream = (__bridge_transfer NSInputStream *) readStream;
                            
        self.streamToServer = stream;
        self.streamToServer.delegate = self;
        self.streamStatus = ServerStreamStatusOpening;
        self.streamStatusString = @"Opening connection";
        [self.streamToServer scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                    
        [self.streamToServer open];
                    
        // Tell the UI we're receiving.
                    
        // do something appropriate…
        NSLog(@"Server: openStreamToServer to '%@'", self.serverName);
    } else {
        //NSLog(@"Server: openStreamToServer: Won't try to open connection to server (%@:%d)", self.serverName, self.portNumber);
    }
}

- (void) closeStreamToServer
{
    self.streamToServer.delegate = nil;
    [self.streamToServer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.streamToServer close];
    self.streamToServer = nil;
    self.streamStatus = ServerStreamStatusClosed;
    self.streamStatusString = @"Connection closed";
    NSLog(@"Server: closeStreamToServer to '%@:%d'", self.serverName, self.portNumber);
}


- (NSInteger) readLineFromStream:(NSInputStream *)streamToServer into:(uint8_t *)buffer maxLength:(NSInteger)buffersize
{
    NSInteger bytesReallyRead = 0;
    NSInteger readResult;
    uint8_t         data;
    
    do {
        readResult = [streamToServer read:&data maxLength:1];
        if (readResult == 1) {
            if (data != 10) {
                buffer[bytesReallyRead] = data;
                bytesReallyRead++;
            } else
                break;
        } else
            break;
    } while (readResult == 1);
   
    return bytesReallyRead;
}




- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
    assert(aStream == self.streamToServer);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            self.streamStatus = ServerStreamStatusOpen;
            self.streamStatusString = @"";
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
            
            //[self updateStatus:@"Receiving"];
            
            // Pull some data off the network.
            
            //bytesRead = [self.streamToServer read:buffer maxLength:sizeof(buffer)];
            bytesRead = [self readLineFromStream:self.streamToServer into:buffer maxLength:sizeof(buffer)];
            
            if (bytesRead == -1 || bytesRead == 0) {
                // -1 equals some kind of read error, if so close and clean up
                // 0 equals nothing read, i.e. read indicated but nothing received in buffer. Close and clean.
                self.streamToServer.delegate = nil;
                [self.streamToServer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [self.streamToServer close];
                self.streamToServer = nil;
                self.streamStatus = ServerStreamStatusClosed;
                self.streamStatusString = @"Connection closed";
            } else {
                NSString    *receivedLogInfo;
                
                // Make a NSString.
                                
                if (bytesRead) {
                    receivedLogInfo = [[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSASCIIStringEncoding];
                    LogRecord *logRecord = [[LogRecord alloc] initWithString:receivedLogInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerNewRecordHasArrived" object:logRecord userInfo:[NSDictionary dictionaryWithObject:[[NSString alloc] initWithFormat:@"%@:%d", self.serverName, self.portNumber] forKey:@"serverInfo"]];
                    // Tell list view to redraw itself [self updateStatus:foo];
                    //if (self.tableView)
                    //    [self.tableView reloadData];
                    //NSLog(@"%@:%d %@", self.serverName, self.portNumber, receivedLogInfo);
                    //for (int x = 0; x < bytesRead; x++) {
                    //    NSLog(@"%d ", buffer[x]);
                    //}
                }
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
            self.streamToServer.delegate = nil;
            [self.streamToServer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            NSError *error = [self.streamToServer streamError];
            if (error != nil) {
                NSLog(@"Server:stream:handleEvent: Stream error dict %@", [error userInfo]);
            }
            [self.streamToServer close];
            self.streamToServer = nil;
            self.streamStatus = ServerStreamStatusClosed;
            self.streamStatusString = @"Connection error occurred";
            self.retryOpenConnection = false;
       } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}



@end
