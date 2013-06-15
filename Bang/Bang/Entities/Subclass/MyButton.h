//
//  MyButton.h
//  Bang
//
//  Created by Martin on 5/6/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *setId;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) int point;
@end
