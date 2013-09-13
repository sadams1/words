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
        _queuePlayer = [[AVQueuePlayer alloc] init];
        [_queuePlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queuePlayerReachedEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_queuePlayer.items];
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

- (void)playSound:(SOUND_TYPE)soundType
{
    if (!self.soundOn)
    {
        return;
    }
    
    NSString *path;
    switch (soundType)
    {
        case SoundTypeBack:
            path = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"mp3"];
            break;
    }
    
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    AVPlayerItem *item = [[[AVPlayerItem alloc] initWithURL:pathURL] autorelease];
    [_queuePlayer insertItem:item afterItem:[_queuePlayer.items lastObject]];
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
