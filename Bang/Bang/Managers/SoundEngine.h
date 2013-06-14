//
//  SoundEngine.h
//  qMemoryGame
//
//  Created by haarryy16 on 6/7/13.
//  Copyright (c) 2013 Harry Cabamalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundEngine : NSObject

/**
 * create a singleton of SoundEngine
 */
+ (SoundEngine*)sharedEngine;
/**
 * Play background music
 */
- (void)playBackgroundMusic:(NSString*)filePath;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;
- (void)stopBackgroundMusic;

/**
 * Play loop effect e.g. game timer
 */
- (void)playLoopEffect:(NSString*)filePath withLoop:(int)loops;
- (void)stopLoopEffect;

/**
 * Play simple effects
 */
- (void)playSimpleEffect:(NSString*)filePath;

@end
