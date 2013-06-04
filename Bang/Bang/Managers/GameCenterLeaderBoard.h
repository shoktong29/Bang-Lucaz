//
//  GameCenterLeaderBoard.h
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterLeaderBoard : NSObject <GKLeaderboardViewControllerDelegate>{
    UIViewController *_presentingViewController;
}

- (void) showBoard:(UIViewController *)viewcontroller;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
@end
