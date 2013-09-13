//
//  QuestPopupManager.m
//  words
//
//  Created by Marius Rott on 9/13/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "QuestPopupManager.h"
#import "QuestPopupView.h"
#import "LevelPopupView.h"
#import "Quest.h"
#import "Level.h"

@interface QuestPopupManager ()
{
    NSArray *_quests;
    UIView *_parentView;
    int _questIndex;
}

- (void)showNextPopup;
- (void)checkAndShowPopupLevel;

- (void)configureView:(QuestPopupView*)view withQuest:(Quest*)quest;
- (void)configureView:(LevelPopupView*)view withLevel:(Level*)level;


@end

@implementation QuestPopupManager

- (id)initWithFinishedQuests:(NSArray *)quests inView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _quests = [quests retain];
        _parentView = [view retain];
        
        //  load cell
        NSString *xib = @"QuestPopupView";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            xib = @"QuestPopupView_iPad";
        }
        self.viewLoaderQuest = [UINib nibWithNibName:xib bundle:nil];
        
        //  load cell
        xib = @"LevelPopupView";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            xib = @"LevelPopupView_iPad";
        }
        self.viewLoaderLevel = [UINib nibWithNibName:xib bundle:nil];
        
        self.viewPopupQuest = nil;
        self.viewPopupLevel = nil;
    }
    return self;
}

- (void)dealloc
{
    [_quests release];
    [_parentView release];
    [self.viewLoaderLevel release];
    [self.viewLoaderQuest release];
    [self.viewPopupLevel release];
    [self.viewPopupQuest release];
    [super dealloc];
}

- (void)showPopups
{
    if (_quests.count)
    {
        _questIndex = 0;
        [self showNextPopup];
    }
}

- (void)doButtonPopupOK:(id)sender
{
    if (self.viewPopupQuest && self.viewPopupQuest.superview == _parentView)
    {
        [self.viewPopupQuest removeFromSuperview];
    }
    if (self.viewPopupLevel && self.viewPopupLevel.superview == _parentView)
    {
        [self.viewPopupLevel removeFromSuperview];
    }
    [self showNextPopup];
}

- (void)showNextPopup
{
    if (self.viewPopupQuest != nil)
    {
        _questIndex++;
    }
    
    if (_questIndex < _quests.count)
    {
        //  show quest popup
        [self.viewLoaderQuest instantiateWithOwner:self options:nil];
        [self configureView:self.viewPopupQuest withQuest:[_quests objectAtIndex:_questIndex]];
        [_parentView addSubview:self.viewPopupQuest];
    }
    else if (self.viewPopupLevel == nil)
    {
        [self checkAndShowPopupLevel];
    }
}

- (void)checkAndShowPopupLevel
{
    Quest *quest0 = [_quests objectAtIndex:0];
    BOOL completed = YES;
    for (Quest *quest in quest0.level.quests)
    {
        if (quest.completed.boolValue == NO)
        {
            completed = NO;
        }
    }
    if (completed)
    {
        //  show level popup
        [self.viewLoaderLevel instantiateWithOwner:self options:nil];
        [self configureView:self.viewPopupLevel withLevel:quest0.level];
        [_parentView addSubview:self.viewPopupLevel];
    }
}

- (void)configureView:(QuestPopupView *)view withQuest:(Quest *)quest
{
    view.labelQuest.text = quest.desc;
}

- (void)configureView:(LevelPopupView *)view withLevel:(Level *)level
{
    view.labelLevel.text = level.name;
}

@end
