//
//  Helper.m
//  Bang
//
//  Created by Martin on 6/2/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "Helper.h"
#import <QuartzCore/QuartzCore.h>

@implementation Helper

+ (void)maskView:(UIView *)view withImage:(UIImage *)image{
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (__bridge id)[image CGImage];
    maskLayer.frame = (CGRect){.origin=CGPointZero,.size=image.size};//CGRectMake(0,0,250,25);
    // Apply the mask to your uiview layer
    view.layer.mask = maskLayer;
}

+ (UIImage *)grayscaleImage:(UIImage *)baseImage color:(UIColor *)theColor
{
	UIGraphicsBeginImageContext(baseImage.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
	
	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -area.size.height);
	
	CGContextSaveGState(ctx);
	CGContextClipToMask(ctx, area, baseImage.CGImage);
	
	[theColor set];
	CGContextFillRect(ctx, area);
	
	CGContextRestoreGState(ctx);
	
	CGContextSetBlendMode(ctx, kCGBlendModeDestinationOver);
	
	CGContextDrawImage(ctx, area, baseImage.CGImage);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}
@end
