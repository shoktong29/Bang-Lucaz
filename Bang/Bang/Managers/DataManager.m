//
//  DataManager.m
//  Bang
//
//  Created by Martin on 5/27/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager *_instance = nil;
+ (DataManager *)sharedInstance{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc]init];
        });
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
