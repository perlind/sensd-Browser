//
//  NodeList.h
//  sensd Browser
//
//  Created by Per Lindgren on 2014-03-01.
//  Copyright (c) 2014 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Node.h"

@interface NodeList : NSObject

@property (nonatomic, strong, readonly ) NSMutableArray     *listOfNodes;  // observable. Is made readwrite in implementation file

- (id) init;

- (NSArray *) getNodeListAsDictionary;

- (NSUInteger) numberOfNodes;

- (Node *) nodeAtIndex:(NSUInteger) index;

- (Node *) nodeWithId:(NSString *) idString;

//- (void) addNode:(Node *)nodeObject;

//- (void) addLogRecord:(LogRecord *)logRecord fromServer:(NSString *)serverInfo;

@end
