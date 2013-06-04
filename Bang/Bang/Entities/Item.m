//
//  Item.m
//  Bang
//
//  Created by Martin on 5/3/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "Item.h"

@implementation Item


- (NSString *)description{
    return [NSString stringWithFormat:@"id:%@ | points:%d",_uniqueId,_point];
}
@end
