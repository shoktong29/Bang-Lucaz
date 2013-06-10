//
//  Protocols.h
//  Bang
//
//  Created by Martin on 6/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InGameMenuDelegate <NSObject>
@required
- (void)didPressRestart;
- (void)didPressHome;
- (void)didPressContinue;
@end


@protocol EndRoundDelegate <NSObject>
@required
- (void)didPressRestart;
- (void)didPressHome;
- (void)didPressContinue;
@end

