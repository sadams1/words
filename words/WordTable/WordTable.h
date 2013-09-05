//
//  WordTableViewController.h
//  word
//
//  Created by marius on 8/5/13.
//  Copyright (c) 2013 marius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"

#define TABLE_SIZE  11

@class WordTable;

@protocol WordTableDelegate <NSObject>

- (void)wordTable:(WordTable*)wordTable changedTmpWord:(NSString*)word;
- (void)wordTable:(WordTable*)wordTable foundWord:(NSString*)word;
- (void)wordTableCompletedGame:(WordTable*)wordTable;

@end

@interface WordTable : NSObject

@property (nonatomic, retain) UIView *view;

- (id)initWithFrame:(CGRect)frame words:(NSArray*)words delegate:(id<WordTableDelegate>)delegate;
- (void)viewDidLoad;

- (bool)canRemoveUnnecessaryChars:(int)charsCount;
- (void)removeUnnecessaryChars:(int)charsCount;
- (void)doWordStartCharHint;

- (void)touchesBegan:(CGPoint)point;
- (void)touchesCancelled:(CGPoint)point;
- (void)touchesEnded:(CGPoint)point;
- (void)touchesMoved:(CGPoint)point;

@end
