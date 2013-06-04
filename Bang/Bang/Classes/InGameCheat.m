//
//  InGameCheat.m
//  Bang
//
//  Created by Martin on 5/19/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "InGameCheat.h"

@implementation InGameCheat{
    NSMutableArray *listGestures;
    int gestureCount;
}

- (void)setDefaultValues{
    gestureCount = 0;
}

- (void)addCheatGestureOnView:(UIView *)view{
    static UISwipeGestureRecognizer *swipeHorizontal;
    static UISwipeGestureRecognizer *swipeVertical;
    
    if (!swipeHorizontal) {
        swipeHorizontal = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [swipeHorizontal setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
        [view addGestureRecognizer:swipeHorizontal];
    }
    
    if (!swipeVertical) {
        swipeVertical = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [swipeVertical setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown )];
        [view addGestureRecognizer:swipeVertical];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gesture{
    gestureCount++;
    if(gestureCount > 8){
        
    }
}
@end
