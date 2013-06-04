//
//  Helper.h
//  Bang
//
//  Created by Martin on 6/2/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (void)maskView:(UIView *)view withImage:(UIImage *)image;
+ (UIImage *)grayscaleImage:(UIImage *)baseImage color:(UIColor *)theColor;
@end
