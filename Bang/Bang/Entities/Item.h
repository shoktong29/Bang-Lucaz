//
//  Item.h
//  Bang
//
//  Created by Martin on 5/3/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (nonatomic) NSString *setId;
@property (nonatomic) NSString *uniqueId;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) int point;
@end
