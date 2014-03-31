//
//  ServerList.m
//  Showoff
//
//  Created by Per Lindgren on 2013-09-26.
//  Copyright (c) 2013 Per Lindgren. All rights reserved.
//

#import "ServerList.h"

@interface ServerList ()

@property (nonatomic, strong, readwrite ) NSMutableArray     *listOfServers;  // observable. Is made readwrite in implementation file

@end

#define SERVERLISTUSERDEFAULTSKEY_v1 @"serverlist_1"

@implementation ServerList

@synthesize listOfServers = _listOfServers;

- (void)initializeDefaultData
{
    // add two servers
    Server *s = [[Server alloc] initWithServer:@"herjulf.se" description:@"RO's hemmaserver" atPortnumer:1234 maximumLogEntries:1000 connectOnStartup:FALSE];
    [self addServer:s];
    s = [[Server alloc] initWithServer:@"196.43.72.37" description:@"Kenya" atPortnumer:1234 maximumLogEntries:1000 connectOnStartup:TRUE];
    [self addServer:s];
    // end dummy code

    
}

- (id) init
{
    self = [super init];
    
    _listOfServers = [[NSMutableArray alloc] init];
    //[self initializeDefaultData];
    if (_listOfServers) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:SERVERLISTUSERDEFAULTSKEY_v1];
        for (NSDictionary *d in array) {
            NSLog(@"ServerListTVC:setupServersList: %@", d);
            Server *s = [[Server alloc] initWithServer:[d valueForKey:SERVER_v1_SERVERNAME]
                                           description:[d valueForKey:SERVER_v1_DESCRIPTION]
                                           atPortnumer:[[d valueForKey:SERVER_v1_PORTNUMBER] intValue]
                                     maximumLogEntries:[[d valueForKey:SERVER_v1_MAXRECORDS] intValue]
                                      connectOnStartup:[[d valueForKey:SERVER_v1_AUTOCONNECT] boolValue]];
            if (s) {
                [self addServer:s];
            }
        }
    }
    
    return self;
}


- (NSArray *) getServerListAsDictionary
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (Server *s in self.listOfServers) {
        NSDictionary *d = [s getServerInfoAsDictionary];
        [array addObject:d];
    }
    
    return array;
}




- (NSUInteger) numberOfServers
{
    if (self.listOfServers)
        return self.listOfServers.count;
    else
        return 0;
}



- (Server *) serverAtIndex:(NSUInteger) index
{
    Server *s = NULL;
    
    if (self.listOfServers != NULL) {
        s = [self.listOfServers objectAtIndex:index];
    }
    
    return s;
}


- (void) moveServerFromIdex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex
{
    // Range checks first
    if (oldIndex < self.numberOfServers && newIndex < self.numberOfServers) {
        Server *s = [self.listOfServers objectAtIndex:oldIndex];
        [self.listOfServers removeObjectAtIndex:oldIndex];
        if (newIndex == self.numberOfServers)
            [self.listOfServers addObject:s];
        else
            [self.listOfServers insertObject:s atIndex:newIndex];
        [self saveServerInfo];
    }
}


- (void) removeServerAtIndex:(NSUInteger) index
{
    Server *serverToRemove = [self.listOfServers objectAtIndex:index];
    if (self.listOfServers != NULL && self.listOfServers.count >= index) {
        serverToRemove = [self.listOfServers objectAtIndex:index];
        // Close connection to the server, if open
        [serverToRemove closeStreamToServer];
        
        // Remove server item from datastructure
        [self.listOfServers removeObjectAtIndex:index];
        // Remove server info from persistent storage is done in
        [self saveServerInfo];
    }
    
}


- (void) addServer:(Server *)serverObject
{
    if (self.listOfServers != NULL && serverObject != NULL) {
        [self.listOfServers addObject:serverObject];
        [self saveServerInfo];
        if (serverObject.autoConnect)
            [serverObject openStreamToServer];
    }
}

- (void) saveServerInfo
{
    // Save server list info in user defaults
    if (self.listOfServers) {
        NSArray *array = [self getServerListAsDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:array
                                                  forKey:SERVERLISTUSERDEFAULTSKEY_v1];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}





@end
