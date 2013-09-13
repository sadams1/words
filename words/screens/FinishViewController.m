//
//  FinishViewController.m
//  words
//
//  Created by Marius Rott on 9/12/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "FinishViewController.h"
#import "GameSession.h"

@interface FinishViewController ()
{
    id<GameViewControllerDelegate> _delegate;
    GameSession *_gameSession;  //  retained in parent viewcontroller
}

@end

@implementation FinishViewController

- (id)initWithDelegate:(id<GameViewControllerDelegate>)delegate gameSession:(GameSession *)gameSession
{
    NSString *xib = @"FinishViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"FinishViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        _delegate = delegate;
        _gameSession = gameSession;
    }
    return self;
}

- (void)dealloc
{
    [self.labelPoints release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelPoints.text = [NSString stringWithFormat:@"%d", [_gameSession getSessionPoints]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)doButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)doButtonMoreGames:(id)sender
{
    
}

- (void)doButtonPackage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(onBack)])
    {
        [_delegate onBack];
    }
}

- (void)doButtonRestart:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    if ([_delegate respondsToSelector:@selector(onRestart)])
    {
        [_delegate onRestart];
    }
}

-(void)doButtonSettings:(id)sender
{
    
}


@end
