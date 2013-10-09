//
//  SoundUtils.m
//  Snake4iPhone
//
//  Created by marius on 5/11/13.
//  Copyright (c) 2013 DibiStore. All rights reserved.
//

#import "SoundUtils.h"
#import <AVFoundation/AVFoundation.h>

#define SOUNDUTILS_SOUND_ON_KEY     @"SOUNDUTILS_SOUND_ON_KEY"

@interface SoundUtils ()
{
    AVQueuePlayer *_queuePlayer;
    SystemSoundID ssClickOnButton;
    SystemSoundID ssBack;
    SystemSoundID ssFoundWord;
}

- (void)queuePlayerReachedEnd:(NSNotification*)notification;

@end

@implementation SoundUtils

@synthesize soundOn = _soundOn;

+ (SoundUtils *)sharedInstance
{
    static SoundUtils *instance;
    if (instance == nil)
    {
        instance = [[SoundUtils alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:SOUNDUTILS_SOUND_ON_KEY])
        {
            instance.soundOn = [userDefaults boolForKey:SOUNDUTILS_SOUND_ON_KEY];
        }
        else
        {
            instance.soundOn = TRUE;
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:nil];
        
        _queuePlayer = [[AVQueuePlayer alloc] init];
        [_queuePlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queuePlayerReachedEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_queuePlayer.items];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Sound Type Back" ofType:@"mp3"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        OSStatus error = AudioServicesCreateSystemSoundID ((CFURLRef)pathURL, &ssBack);
        if (error) NSLog(@"SoundPlayer doInit Error is %ld",error);
        
        path = [[NSBundle mainBundle] pathForResource:@"SoundTypeFoundWord" ofType:@"mp3"];
        pathURL = [NSURL fileURLWithPath : path];
        error = AudioServicesCreateSystemSoundID ((CFURLRef)pathURL, &ssFoundWord);
        if (error) NSLog(@"SoundPlayer doInit Error is %ld",error);
        
        path = [[NSBundle mainBundle] pathForResource:@"SoundTypeClickOnButton" ofType:@"mp3"];
        pathURL = [NSURL fileURLWithPath : path];
        error = AudioServicesCreateSystemSoundID ((CFURLRef)pathURL, &ssClickOnButton);
        if (error) NSLog(@"SoundPlayer doInit Error is %ld",error);
        
    }
    return self;
}

- (void)dealloc
{
    [_queuePlayer release];
    [super dealloc];
}

- (void)setSoundOn:(BOOL)sON
{
    _soundOn = sON;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sON forKey:SOUNDUTILS_SOUND_ON_KEY];
    [userDefaults synchronize];
}

- (void)playMusic:(SOUND_TYPE)soundType
{
    if (!self.soundOn)
    {
        return;
    }
    
    if ([self isPlaying])
    {
        return;
    }
    
    UInt32 propertySize, audioIsAlreadyPlaying=0;
    propertySize = sizeof(UInt32);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &audioIsAlreadyPlaying);
    if (audioIsAlreadyPlaying)
    {
        return;
    }
    
    NSString *path;
    switch (soundType)
    {
        case SoundTypeStartTmpWord:
            path = [[NSBundle mainBundle] pathForResource:@"SoundTypeStartTmpWord" ofType:@"mp3"];
            break;
        case SoundTypeCoinsAdded:
            path = [[NSBundle mainBundle] pathForResource:@"Coins Added" ofType:@"mp3"];
            break;
        case SoundTypeGameFinished:
            path = [[NSBundle mainBundle] pathForResource:@"SoundTypeGameFinished_01" ofType:@"mp3"];
            break;
        case SoundTypeHint:
            path = [[NSBundle mainBundle] pathForResource:@"SoundTypeHint" ofType:@"mp3"];
            break;
        case SoundTypeQuestCompleted:
            path = [[NSBundle mainBundle] pathForResource:@"SoundTypeGameFinished_04" ofType:@"mp3"];
            break;
        case SoundTypeRemoveChars:
            path = [[NSBundle mainBundle] pathForResource:@"SoundTypeRemoveChars" ofType:@"mp3"];
            break;
        default:
            NSLog(@"PLAY MUSIC ERROR, file not defined");
            return;
            break;
    }
    
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    AVPlayerItem *item = [[[AVPlayerItem alloc] initWithURL:pathURL] autorelease];
    [_queuePlayer insertItem:item afterItem:[_queuePlayer.items lastObject]];
}

- (void)playSoundEffect:(SOUND_TYPE)soundType
{
    if (!self.soundOn)
    {
        return;
    }
    
    switch (soundType)
    {
        case SoundTypeBack:
            AudioServicesPlaySystemSound (ssBack);
            break;
        case SoundTypeFoundWord:
            AudioServicesPlaySystemSound (ssFoundWord);
            break;
        case SoundTypeClickOnButton:
            AudioServicesPlaySystemSound (ssClickOnButton);
            break;
        default:
            return;
    }
}

- (BOOL)isPlaying
{
    return _queuePlayer.items.count != 0;
}

- (void)queuePlayerReachedEnd:(NSNotification *)notification
{
    [_queuePlayer removeAllItems];
}

@end
