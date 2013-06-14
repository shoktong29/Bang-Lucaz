//
//  SoundEngine.m
//  qMemoryGame
//
//  Created by haarryy16 on 6/7/13.
//  Copyright (c) 2013 Harry Cabamalan. All rights reserved.
//

#import "SoundEngine.h"

@interface SoundEngine()
{
    AVAudioPlayer *_sfxPlayer;
    AVAudioPlayer *_bgmPlayer;
    AVAudioPlayer *_loopPlayer;
    int counter;

}
@end

@implementation SoundEngine

static SoundEngine *_soundEngine = nil;

+ (SoundEngine *)sharedEngine
{
    @synchronized([SoundEngine class])
    {
        if (_soundEngine == nil)
            _soundEngine = [[[self class] alloc] init];
        
        return _soundEngine;
    }
    
    return nil;
}

+ (id)alloc
{
    @synchronized([SoundEngine class])
    {
        NSAssert(_soundEngine == nil, @"Attempted to allocate a second instance of singleton");
        _soundEngine = [super alloc];
        return _soundEngine;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
                
        NSError *error = nil;
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        [audioSession setActive:YES error: &error];

        
    }
    return self;
}

#pragma mark - Background Music

- (void)playBackgroundMusic:(NSString*)filePath
{
    NSArray *filePathArray = [filePath componentsSeparatedByString:@"."];
    NSString *fileName = [filePathArray objectAtIndex:0];
    NSString *fileExtension = [filePathArray objectAtIndex:filePathArray.count-1];
    ;
    NSError *error = nil;
    NSURL *pathURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
    _bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    _bgmPlayer.numberOfLoops = -1;
    _bgmPlayer.volume = 1.0;
    [_bgmPlayer prepareToPlay];
    [_bgmPlayer play];
}

- (void)pauseBackgroundMusic
{
    [_bgmPlayer pause];
}

- (void)resumeBackgroundMusic
{
    [_bgmPlayer play];
}

- (void)stopBackgroundMusic
{
    [_bgmPlayer stop];
}
#pragma mark -

#pragma mark - Loop Effects
- (void)playLoopEffect:(NSString*)filePath withLoop:(int)loops
{
    counter++;
    NSArray *filePathArray = [filePath componentsSeparatedByString:@"."];
    NSString *fileName = [filePathArray objectAtIndex:0];
    NSString *fileExtension = [filePathArray objectAtIndex:filePathArray.count-1];
    ;
    NSError *error = nil;
    NSURL *pathURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
    _loopPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    _loopPlayer.numberOfLoops = loops;
    _loopPlayer.volume = 1.0;
    [_loopPlayer prepareToPlay];
    [_loopPlayer play];
    
}

- (void)stopLoopEffect
{
    [_loopPlayer stop];
}
#pragma mark -

#pragma mark - Simple Effects
- (void)playSimpleEffect:(NSString*)filePath
{
    counter++;
    NSArray *filePathArray = [filePath componentsSeparatedByString:@"."];
    NSString *fileName = [filePathArray objectAtIndex:0];
    NSString *fileExtension = [filePathArray objectAtIndex:filePathArray.count-1];
    ;
    NSError *error = nil;
    NSURL *pathURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension]];
    _sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    _sfxPlayer.volume = 1.0;
    [_sfxPlayer prepareToPlay];
    [_sfxPlayer play];

}
#pragma mark -

#pragma mark audio player delegate methods
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"audioRecorderDidFinishRecording");
}

@end
