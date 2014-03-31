//
//  NodeList.m
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-01.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import "NodeList.h"
#import "LogList.h"
#import "Server.h"

@interface NodeList ()

@property (nonatomic, readwrite) NSInteger lastSeqNum;

@end

@implementation NodeList

@synthesize lastSeqNum = _lastSeqNum;

- (id) init
{
    self = [super init];
    _listOfNodes = [[NSMutableArray alloc] init];
    _lastSeqNum = -1;
    
    // Register with default notification center: listening to Server input events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLogRecord:) name:@"ServerNewRecordHasArrived" object:nil];
    return self;
}

- (NSArray *) getNodeListAsDictionary
{
    return nil;
}

- (NSUInteger) numberOfNodes
{
    return [self.listOfNodes count];
}

- (Node *) nodeAtIndex:(NSUInteger)index
{
    Node* node;
    
    if ([self.listOfNodes count]) {
        if (index < [self.listOfNodes count])
            node = [self.listOfNodes objectAtIndex:index];
    }
    
    return node;
}

- (Node *) nodeWithId:(NSString *) idString
{
    for (id node in self.listOfNodes) {
        if ([node isKindOfClass:[Node class]]) {
            if ([[node description] isEqualToString:idString])
                return node;
        }
    }
    
    return nil;
}


- (void) addLogRecord:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[LogRecord class]]) {
        NSDictionary *d = notification.userInfo;
        NSString *serverInfo = [d valueForKey:@"serverInfo"];
        LogRecord *logRecord = notification.object;
        NSLog(@"%@ %@", serverInfo,[logRecord description]);
        if (logRecord.seqNum == -1 || (logRecord.seqNum != self.lastSeqNum)) {
            [self addLogRecordAux:logRecord fromServer:serverInfo];
            self.lastSeqNum = logRecord.seqNum;
        } else {
            NSString *id;
            id = [logRecord getValueForKey:LOGRECORDE64];
            if (!id)
                id = [logRecord getValueForKey:LOGRECORDID];
            NSLog(@"NodeList: duplicate seqNum (%d) for node %@", logRecord.seqNum, id);
        }
    }
}

- (void) addLogRecordAux:(LogRecord *)logRecord fromServer:(NSString *)serverInfo
{
    if (logRecord) {
        NSString *id;
        id = [logRecord getValueForKey:LOGRECORDE64];
        if (!id)
            id = [logRecord getValueForKey:LOGRECORDID];
        if (id) {
            Node *node = [self nodeWithId:id];
            if (!node) {
                // node did not exist yet, so this is the first record for that node. Create node
                node = [[Node alloc] initWithId:id fromServer:serverInfo];
                [self.listOfNodes addObject:node];
            }
            [node addLogRecord:logRecord];
        }
    }
    
   
}





@end
