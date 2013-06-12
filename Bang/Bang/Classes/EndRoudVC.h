//
//  EndRoudVC.h
//  Bang
//
//  Created by Martin on 6/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameElement.h"
#import "Protocols.h"

@interface EndRoudVC : UIView
@property(nonatomic, strong) void(^onPressRestart)(void);
@property(nonatomic, strong) void(^onPressHome)(void);
@property(nonatomic, strong) void(^onPressContinue)(void);
@property(nonatomic) GameResult results;
- (void)showEndRound:(UIView *)view;
- (void)hideEndRound;
- (void)setMyFrame:(CGRect )frame;
@end
