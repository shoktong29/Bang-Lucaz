//
//  GameCenterAchievement.m
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "GameCenterAchievement.h"

@implementation GameCenterAchievement

#pragma mark - Achievements
- (void) showBoard:(UIViewController *)viewcontroller{
    _presentingViewController = viewcontroller;
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL)
	{
		achievements.achievementDelegate = self;
		[_presentingViewController presentModalViewController: achievements animated: YES];
        //		achievements.view.transform = CGAffineTransformMakeRotation(1.570796327f);
        //		[achievements.view setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2,
        //                                                 [[UIScreen mainScreen] bounds].size.height/2)];
	}
}

- (void) resetAchievements{
	[GKAchievement resetAchievementsWithCompletionHandler:nil];
}

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete
{
	//GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report
	// new achievements to the user, then you need to check if it's been earned
	// before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
	// and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
	// then cache it and keep it updated with any new achievements.
	if(_earnedAchievementCache == NULL){
		[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error){
             if(error == NULL){
                 NSMutableDictionary* tempCache= [NSMutableDictionary dictionaryWithCapacity: [scores count]];
                 for (GKAchievement* score in scores){
                     [tempCache setObject: score forKey: score.identifier];
                 }
                 _earnedAchievementCache= tempCache;
                 [self submitAchievement: identifier percentComplete: percentComplete];
             }
             else{
                 //Something broke the loading the achievement list.  Error out, and we'll try again the next time achievements submit.
//                 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: NULL error: error];
             }
             
         }];
	}
	else
	{
        //Search the list for the ID we're using...
		GKAchievement* achievement= [_earnedAchievementCache objectForKey: identifier];
		if(achievement != NULL){
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)){
				//Achievement has already been earned so we're done.
				achievement= NULL;
			}
            else{
                achievement.showsCompletionBanner = YES;
            }
			achievement.percentComplete= percentComplete;
		}
		else{
			achievement= [[GKAchievement alloc] initWithIdentifier: identifier];
			achievement.percentComplete= percentComplete;
            achievement.showsCompletionBanner = YES;
            
			//Add achievement to achievement cache...
			[_earnedAchievementCache setObject: achievement forKey: achievement.identifier];
		}
		if(achievement!= NULL){
			//Submit the Achievement...
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error){
//				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
             }];
		}
	}
}

#pragma mark - Delegates
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;{
	[_presentingViewController dismissModalViewControllerAnimated: YES];
}
@end
