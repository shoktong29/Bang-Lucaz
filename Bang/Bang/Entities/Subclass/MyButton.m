//
//  MyButton.m
//  Bang
//
//  Created by Martin on 5/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyButton

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 2.0f;
        self.layer.borderWidth = 3.0f;
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"id:%@ | points:%d",_uniqueId,_point];
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
