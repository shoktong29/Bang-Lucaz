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
        self.backgroundColor = [UIColor brownColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showMenu:(UIView *)view{
    UIView *container = [[UIView alloc]init];
    container.frame = (CGRect){.origin=self.bounds.origin,.size={170,50}};
    container.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    container.backgroundColor = [UIColor blackColor];
    
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnHome.frame = CGRectMake(0, 0, 50, 50);
    [btnHome setImage:[UIImage imageNamed:@"iconHome"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnHome];
    
    UIButton *btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnContinue.frame = CGRectMake(60, 0, 50, 50);
    [btnContinue setImage:[UIImage imageNamed:@"iconPlay"] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(goContinue) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnContinue];
    
    UIButton *btnRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRestart.frame = CGRectMake(120, 0, 50, 50);
    [btnRestart setImage:[UIImage imageNamed:@"iconSettings"] forState:UIControlStateNormal];
    [btnRestart addTarget:self action:@selector(goRestart) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btnRestart];
    
    [container sizeToFit];
    [self addSubview:container];
    
    [view addSubview:self];
}

- (void)hideMenu{
    [self removeFromSuperview];
}

- (void)goHome{
    if ([_delegate respondsToSelector:@selector(didPressHome)]) {
        [_delegate didPressHome];
    }
}

- (void)goContinue{
    if ([_delegate respondsToSelector:@selector(didPressContinue)]) {
        [_delegate didPressContinue];
    }
}

- (void)goRestart{
    if ([_delegate respondsToSelector:@selector(didPressRestart)]) {
        [_delegate didPressRestart];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
