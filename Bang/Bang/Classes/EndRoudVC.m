//
//  EndRoudVC.m
//  Bang
//
//  Created by Martin on 6/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "EndRoudVC.h"

@interface EndRoudVC ()

@end

@implementation EndRoudVC{
    CGRect tempFrame;
}

- (id)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setMyFrame:(CGRect )frame{
    tempFrame = frame;
    self.frame = (CGRect){.origin={tempFrame.origin.x,600}, .size=tempFrame.size};
}

- (void)showEndRound:(UIView *)view{
    float buttonHeight = 50.0f;
    CGSize containerSize = CGSizeMake(170, buttonHeight);
    UIView *container = [[UIView alloc]init];
    container.frame = (CGRect){.origin={self.frame.origin.x,self.frame.size.height-buttonHeight},.size=containerSize};
    container.center = CGPointMake(CGRectGetMidX(self.bounds), container.frame.origin.y);
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor clearColor];
    
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnHome.frame = CGRectMake(0, 0, 50, buttonHeight);
    [btnHome setImage:[UIImage imageNamed:@"iconHome"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnHome];
    
    UIButton *btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnContinue.frame = CGRectMake(60, 0, 50, buttonHeight);
    [btnContinue setImage:[UIImage imageNamed:@"iconPlay"] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnContinue];
    
    UIButton *btnRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRestart.frame = CGRectMake(120, 0, 50, buttonHeight);
    [btnRestart setImage:[UIImage imageNamed:@"iconRestart"] forState:UIControlStateNormal];
    [btnRestart addTarget:self action:@selector(goRestart) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnRestart];
    
    [container sizeToFit];
    [self addSubview:container];
    
    CGSize containerResultSize = CGSizeMake(170, tempFrame.size.height-containerSize.height-5);
    UIView *containerResult = [[UIView alloc]init];
    containerResult.frame = (CGRect){.origin=tempFrame.origin,.size=containerResultSize};
    containerResult.center = CGPointMake(CGRectGetMidX(self.bounds), containerResult.frame.origin.y);
    containerResult.clipsToBounds = NO;
    containerResult.backgroundColor = [UIColor clearColor];
    
    UILabel *lTitle = [[UILabel alloc]init];
    lTitle.frame = CGRectMake(container.frame.size.width/2-containerSize.width/2, 0, containerSize.width, 35);
    lTitle.backgroundColor = [UIColor clearColor];
    lTitle.textColor = UICOLOR_FROM_HEX(0xffffff);
    lTitle.text = @"Results";
    lTitle.textAlignment = UITextAlignmentCenter;
    [containerResult addSubview:lTitle];
    
    UILabel *lScore = [[UILabel alloc]init];
    lScore.frame = CGRectMake(container.frame.size.width/2-containerSize.width/2, 40, containerSize.width, 15);
    lScore.backgroundColor = [UIColor clearColor];
    lScore.textColor = UICOLOR_FROM_HEX(0xffffff);
    lScore.text = [NSString stringWithFormat:@"Score : %0.0f",_results.roundScore];
    lScore.textAlignment = UITextAlignmentLeft;
    [containerResult addSubview:lScore];
    
    UILabel *lComboBonus = [[UILabel alloc]init];
    lComboBonus.frame = CGRectMake(container.frame.size.width/2-containerSize.width/2, 60, containerSize.width, 15);
    lComboBonus.backgroundColor = [UIColor clearColor];
    lComboBonus.textColor = UICOLOR_FROM_HEX(0xffffff);
    lComboBonus.text = [NSString stringWithFormat:@"Bonus: %0.0f",_results.comboBonus];
    lComboBonus.textAlignment = UITextAlignmentLeft;
    [containerResult addSubview:lComboBonus];
    
    UILabel *lCoins = [[UILabel alloc]init];
    lCoins.frame = CGRectMake(container.frame.size.width/2-containerSize.width/2, 80, containerSize.width, 15);
    lCoins.backgroundColor = [UIColor clearColor];
    lCoins.textColor = UICOLOR_FROM_HEX(0xffffff);
    lCoins.text = [NSString stringWithFormat:@"Coins : %d",_results.coins];
    lCoins.textAlignment = UITextAlignmentLeft;
    [containerResult addSubview:lCoins];
    
    [containerResult sizeToFit];
    [self addSubview:containerResult];
    [view addSubview:self];
    
    /*ANIMATION*/
//    CGAffineTransform trans = CGAffineTransformScale(self.transform, 0.01, 0.01);
//    self.transform = trans;
    [UIView animateWithDuration:0.5f animations:^{
//        self.transform = CGAffineTransformScale(trans, 110, 110);
        self.frame = tempFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
//            self.transform = CGAffineTransformScale(trans, 100, 100);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)hideEndRound{
    [self removeFromSuperview];
}

- (void)goHome{
    if (self.onPressHome) {
        self.onPressHome();
    }
}

- (void)goContinue{
    if (self.onPressContinue) {
        [UIView animateWithDuration:0.3f animations:^{
            self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [self hideEndRound];
//            self.onPressContinue();
                self.onPressRestart();
        }];
    }
}

- (void)goRestart{
    if (self.onPressRestart) {
        self.onPressRestart();
    }
}
@end
