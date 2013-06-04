//
//  Fade.m
//  Bang
//
//  Created by Martin on 5/30/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "Fade.h"
#import <QuartzCore/QuartzCore.h>
@implementation Fade


- (void)perform{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade ;
    
    [[[[[self sourceViewController] view] window] layer] addAnimation:transition forKey:kCATransitionFade];
    
    [[self sourceViewController]
     presentViewController:[self destinationViewController]
     animated:NO completion:NULL];
}

@end
