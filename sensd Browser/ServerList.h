//
//  ServerList.h
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface ServerList : NSObject

@property (nonatomic, strong, readonly ) NSMutableArray     *listOfServers;  // observable. Is made readwrite in implementation file

- (id) init;

- (NSArray *) getServerListAsDictionary;

- (NSUInteger) numberOfServers;

- (Server *) serverAtIndex:(NSUInteger) index;

- (void) moveServerFromIdex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex;

- (void) removeServerAtIndex:(NSUInteger) index;

- (void) addServer:(Server *)serverObject;

- (void) saveServerInfo;

@end
