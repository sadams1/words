//
//  GameSession.m
//  words
//
//  Created by Marius Rott on 9/11/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "GameSession.h"
#import "CoreDataUtils.h"
#import "QuestManager.h"
#import "Game.h"
#import "Session.h"


@interface GameSession ()
{
    NSTimeInterval _timeInterval;
    id<GameSessionDelegate> _delegate;
    NSTimer *_timer;
}

@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) NSArray *completedQuests;

- (void)onTimerUpdate;
- (void)writeSessionInDB;

@end

@implementation GameSession

- (id)initWithGame:(Game*)game delegate:(id<GameSessionDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.game = game;
        _delegate = delegate;
        _timeInterval = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(onTimerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    _timer = nil;
    [self.game release];
    [self.completedQuests release];
    [super dealloc];
}

- (void)pause
{
    [_timer invalidate];
    _timer = nil;
}

- (void)resume
{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimerUpdate)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)gameCompleted
{
    [_timer invalidate];
    _timer = nil;
    
    [self writeSessionInDB];
    
    QuestManager *questManager = [[[QuestManager alloc] init] autorelease];
    self.completedQuests = [questManager getCompletedQuests];
    NSLog(@"%d completed quests", self.completedQuests.count);
}

- (BOOL)isHighscore
{
    for (Session *session in _game.sessions)
    {
        if (session.duration.intValue < _timeInterval)
        {
            return NO;
        }
    }
    return YES;
}

- (int)getSessionPoints
{
    //  todo
    return 100;
}

- (NSArray *)getQuestsCompleted
{
    return self.completedQuests;
}

- (void)onTimerUpdate
{
    _timeInterval++;
    if (_delegate != nil)
    {
        NSString *time = @"";
        
        int hours = _timeInterval / 3600;
        if (hours)
        {
            time = [NSString stringWithFormat:@"%d:", hours];
        }
        
        int minutes = (_timeInterval - (hours * 3600)) / 60;
        time = [NSString stringWithFormat:@"%@%@%d:", time, minutes<10?@"0":@"", minutes];
        
        int seconds = _timeInterval - (hours * 3600) - (minutes * 60);
        time = [NSString stringWithFormat:@"%@%@%d", time, seconds<10?@"0":@"", seconds];
        
        [_delegate onTimeChanged:time];
    }
}

- (void)writeSessionInDB
{
    Session *session = [NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                                     inManagedObjectContext:[CoreDataUtils sharedInstance].managedObjectContext];
    session.game = _game;
    session.duration = [NSNumber numberWithInt:_timeInterval];
    session.date = [NSDate date];
    session.points = [NSNumber numberWithInt:[self getSessionPoints]];
    
    NSError *error = nil;
    [[CoreDataUtils sharedInstance].managedObjectContext save:&error];
    if (error)
    {
        NSLog(error.debugDescription);
    }
}


@end
