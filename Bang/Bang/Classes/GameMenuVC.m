//
//  GameMenuVC.m
//  Bang
//
//  Created by Martin on 5/25/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "GameMenuVC.h"
#import "GameCenterManager.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectSetVC.h"

@interface GameMenuVC ()

@end

@implementation GameMenuVC
- (void)viewDidLoad {
    [self cloudScroll];
    [super viewDidLoad];
}

-(void)cloudScroll {
        UIImage *backgroundImage = [UIImage imageNamed:@"kill.png"];
        UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
        CALayer *background = [CALayer layer];
        background.backgroundColor = backgroundPattern.CGColor;
        background.transform = CATransform3DMakeScale(1, -1, 1);
        background.anchorPoint = CGPointMake(0, 1);
        CGSize viewSize = self.backgroundImageView.bounds.size;
        background.frame = CGRectMake(0, 0, viewSize.width,  backgroundImage.size.height*2);
        [self.backgroundImageView.layer addSublayer:background];
        
        CGPoint endPoint = CGPointZero;
        CGPoint startPoint = CGPointMake(0, -backgroundImage.size.height);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = [NSValue valueWithCGPoint:endPoint];
        animation.toValue = [NSValue valueWithCGPoint:startPoint];
        animation.repeatCount = HUGE_VALF;
        animation.duration = 10.0;
        [background addAnimation:animation forKey:@"position"];
}

- (void)applyCloudLayerAnimation {
    [self.cloudLayer addAnimation:self.cloudLayerAnimation forKey:@"position"];
}

- (void)viewDidUnload {
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
}

#define HEX_FROM UICOLOR(x) [NSString ]
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    [self applyCloudLayerAnimation];
}

- (IBAction)goMultiplayer:(id)sender{
    [[[GameCenterManager sharedInstance]leaderboard]showBoard:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

@end
