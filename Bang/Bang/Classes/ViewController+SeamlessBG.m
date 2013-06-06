//
//  ViewController+Logic.m
//  Bang
//
//  Created by Martin on 5/29/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "ViewController+SeamlessBG.h"

@implementation ViewController (SeamlessBG)

- (void)viewDidLoad {
    [self cloudScroll];
    [super viewDidLoad];
}

-(void)cloudScroll {
    UIImage *backgroundImage = self.cloudsImageView.image;
    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
    CALayer *background = [CALayer layer];
    background.backgroundColor = backgroundPattern.CGColor;
    background.transform = CATransform3DMakeScale(0.5, -0.5, 1);
    background.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.cloudsImageView.bounds.size;
    background.frame = CGRectMake(0, 0, viewSize.width,  backgroundImage.size.height*2);
    [self.cloudsImageView.layer addSublayer:background];
    
    CGPoint endPoint = CGPointZero;
    CGPoint startPoint = CGPointMake(0, -backgroundImage.size.height);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:endPoint];
    animation.toValue = [NSValue valueWithCGPoint:startPoint];
    animation.repeatCount = HUGE_VALF;
    animation.duration = 200.0;
    [background addAnimation:animation forKey:@"position"];
}

- (void)applyCloudLayerAnimation {
    [self.cloudLayer addAnimation:self.cloudLayerAnimation forKey:@"position"];
}

- (void)viewDidUnload {
    [self setCloudsImageView:nil];
    [super viewDidUnload];
}

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
@end
