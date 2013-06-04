//
//  AudioManager.h
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioManager : NSObject

+ (void)playSound:(NSURL *)audioFile;
@end
