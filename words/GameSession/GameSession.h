//
//  GameSession.h
//  words
//
//  Created by Marius Rott on 9/11/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@protocol GameSessionDelegate <NSObject>

- (void)onTimeChanged:(NSString*)timeString;

@end

@interface GameSession : NSObject

- (id)initWithGame:(Game*)game delegate:(id<GameSessionDelegate>)delegate;

- (void)pause;
- (void)resume;         
- (void)gameCompleted;  //  write session in DB
- (BOOL)isHighscore;

- (int)getSessionPoints;
- (NSArray*)getQuestsCompleted;

@end
