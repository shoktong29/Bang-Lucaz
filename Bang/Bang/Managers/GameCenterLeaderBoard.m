//
//  GameCenterLeaderBoard.m
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "GameCenterLeaderBoard.h"
#define kGC_LEADERBOARD_CATEGORY @"RW_Leaderboard_001_hayaku"

@implementation GameCenterLeaderBoard

#pragma mark - Leaderboard
- (void) showBoard:(UIViewController *)viewcontroller{
    _presentingViewController = viewcontroller;
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL){
		leaderboardController.category = kGC_LEADERBOARD_CATEGORY;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[_presentingViewController presentModalViewController:leaderboardController animated: YES];
        //		leaderboardController.view.transform = CGAffineTransformMakeRotation(1.570796327f);
        //		[leaderboardController.view setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2,
        //														  [[UIScreen mainScreen] bounds].size.height/2)];
	}
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
	GKScore *scoreReporter = [[GKScore alloc] initWithCategory:kGC_LEADERBOARD_CATEGORY];
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler:nil];
}

#pragma mark Delegate
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    [_presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
