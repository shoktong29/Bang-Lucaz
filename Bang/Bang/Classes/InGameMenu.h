//
//  InGameMenu.h
//  Bang
//
//  Created by Martin on 5/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"


@interface InGameMenu : UIView
@property(nonatomic, strong) void(^onPressRestart)(void);
@property(nonatomic, strong) void(^onPressHome)(void);
@property(nonatomic, strong) void(^onPressContinue)(void);
- (void)showMenu:(UIView *)view;
- (void)hideMenu:(void(^)(void))process;

@end
