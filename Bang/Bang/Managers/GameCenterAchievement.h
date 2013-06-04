//
//  GameCenterAchievement.h
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterAchievement : NSObject<GKAchievementViewControllerDelegate>{
    UIViewController *_presentingViewController;
    NSMutableDictionary *_earnedAchievementCache;
}
- (void) showBoard:(UIViewController *)viewcontroller;
- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) resetAchievements;
@end
