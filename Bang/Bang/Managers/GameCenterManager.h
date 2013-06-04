//
//  GameCenterHelper.h
//  hayakuninja
//
//  Created by Martin on 5/16/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "GameCenterLeaderBoard.h"
#import "GameCenterAchievement.h"

@interface GameCenterManager : NSObject{
    BOOL _userAuthenticated;
    UIViewController *_presentingViewController;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, setter = setIsMatchStarted:) BOOL isMatchStarted;
@property (nonatomic, retain) NSMutableDictionary *playersDict;
@property (nonatomic, retain) GKMatch *match;
@property (nonatomic, retain) GameCenterLeaderBoard *leaderboard;
@property (nonatomic, retain) GameCenterAchievement *achievement;

+ (GameCenterManager *)sharedInstance;
- (void)authenticateLocalUser;
- (void) mapPlayerIDtoPlayer: (NSString*) playerID;
@end