//
//  DataManager.h
//  Bang
//
//  Created by Martin on 5/27/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "GameElement.h"
@interface DataManager : NSObject

@property (nonatomic,readwrite) GameSettings gameSettings;
+ (DataManager *)sharedInstance;
@end
