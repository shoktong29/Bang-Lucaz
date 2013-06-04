//
//  AudioManager.m
//  Bang
//
//  Created by Martin on 5/22/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager


void MyAudioServicesSystemSoundCompletionProc(SystemSoundID ssID, void *clientData) {
	NSLog(@"Done playing file");
}

+ (void)playSound:(NSURL *)audioFile {
    SystemSoundID systemSoundID;
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef) audioFile, &systemSoundID);
    AudioServicesPlaySystemSound(systemSoundID);
    AudioServicesAddSystemSoundCompletion(systemSoundID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, (__bridge void *)(self));
    // Sounds played with AudioServicesPlaySystemSound can not be longer then 30 secs.
    // So we can dispose the system sound id after that period.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        AudioServicesDisposeSystemSoundID(systemSoundID);
    });
}
@end
