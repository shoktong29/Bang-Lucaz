//
//  GameCenterHelper.m
//  hayakuninja
//
//  Created by Martin on 5/16/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "GameCenterManager.h"

@implementation GameCenterManager

static GameCenterManager *_myClass = nil;

+ (GameCenterManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _myClass = [[self alloc] init];
    });
    return _myClass;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (_gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
            
            _leaderboard = [[GameCenterLeaderBoard alloc]init];
            _achievement = [[GameCenterAchievement alloc]init];
        }
    }
    return self;
}

#pragma mark - User Authentication
//Automatic trigger
- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated &&
        !_userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        _userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated &&
               _userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        _userAuthenticated = FALSE;
    }
}

//User trigger
- (void)authenticateLocalUser {
    if (!_gameCenterAvailable) return;
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void) mapPlayerIDtoPlayer: (NSString*) playerID{
	[GKPlayer loadPlayersForIdentifiers: [NSArray arrayWithObject: playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error){
         GKPlayer* player= NULL;
         for (GKPlayer* tempPlayer in playerArray){
             if([tempPlayer.playerID isEqualToString: playerID]){
                 player= tempPlayer;
                 break;
             }
//             return player; //use block
         }
     }];
}

@end
