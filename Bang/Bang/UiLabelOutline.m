//
//  UiLabelOutline.m
//
//  Created by Martin on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UiLabelOutline.h"

@implementation UiLabelOutline

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.textAlignment = UITextAlignmentCenter;
    }
    
    return self;
}


- (void)drawTextInRect:(CGRect)rect 
{    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = UICOLOR_FROM_HEX(0x333333);
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
//grayscale
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    
//    CGContextSelectFont(context, "Doctor Soos Bold", 20.0f, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextClip);
//    CGContextSetTextPosition(context, 0.0f, round(20.0f / 4.0f));
//    CGContextShowText(context, [self.text UTF8String], strlen([self.text UTF8String]));
//    
//    CGContextClip(context);
//    
//    CGGradientRef gradient;
//    CGColorSpaceRef rgbColorspace;
//    size_t num_locations = 2;
//    CGFloat locations[2] = { 0.0, 1.0 };
//    CGFloat components[8] = { 0.38, 0.90, 0.35, 1.0,  // Start color
//        1.0, 0, 0, 0.5 }; // End color
//    
//    rgbColorspace = CGColorSpaceCreateDeviceRGB();
//    gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
//    
//    CGRect currentBounds = self.bounds;
//    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
//    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
//    CGContextDrawLinearGradient(context, gradient, topCenter, midCenter, 0);
//    
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(rgbColorspace);             
//    
//    CGContextRestoreGState(context);
}
@end
