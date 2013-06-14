//
//  InGameMenu.m
//  Bang
//
//  Created by Martin on 5/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "InGameMenu.h"

@implementation InGameMenu

- (id)init{
    self = [super initWithFrame:CGRectMake(10,150, 300, 100)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showMenu:(UIView *)view{
    UIView *container = [[UIView alloc]init];
    container.frame = (CGRect){.origin=self.frame.origin,.size={170,150}};
    container.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    container.clipsToBounds = NO;
    container.backgroundColor = [UIColor clearColor];
    
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnHome.frame = CGRectMake(0, 100, 50, 50);
    [btnHome setImage:[UIImage imageNamed:@"iconHome"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnHome];
    
    UIButton *btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnContinue.frame = CGRectMake(60, 100, 50, 50);
    [btnContinue setImage:[UIImage imageNamed:@"iconPlay"] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnContinue];
    
    UIButton *btnRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRestart.frame = CGRectMake(120, 100, 50, 50);
    [btnRestart setImage:[UIImage imageNamed:@"iconRestart"] forState:UIControlStateNormal];
    [btnRestart addTarget:self action:@selector(goRestart) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnRestart];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(container.frame.size.width/2-170/2, 0, 170, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UICOLOR_FROM_HEX(0xffffff);
    label.text = @"PAUSED";
    label.textAlignment = UITextAlignmentCenter;
    [container addSubview:label];
    
    [container sizeToFit];
    [self addSubview:container];
    [view addSubview:self];
    
    /*ANIMATION*/
    CGAffineTransform trans = CGAffineTransformScale(self.transform, 0.01, 0.01);
    self.transform = trans;
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformScale(trans, 110, 110);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.transform = CGAffineTransformScale(trans, 100, 100);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)hideMenu:(void(^)(void))process{
    CGAffineTransform trans = CGAffineTransformScale(self.transform, 0.01, 0.01);
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformScale(trans, 0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        process();
    }];
}

- (void)goHome{
    if (self.onPressHome) {
        [self hideMenu:^{
            self.onPressHome();
        }];
    }
}

- (void)goContinue{
    if (self.onPressContinue) {
        [self hideMenu:^{
            self.onPressContinue();
        }];        
    }
}
- (void)goRestart{
    if (self.onPressRestart) {
        [self hideMenu:^{
            self.onPressRestart();
        }];          
    }
}

@end
