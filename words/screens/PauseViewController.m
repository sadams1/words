//
//  PauseViewController.m
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()
{
    id<GameViewControllerDelegate> _delegate;
}

@end

@implementation PauseViewController

- (id)initWithDelegate:(id<GameViewControllerDelegate>)delegate
{
    NSString *xib = @"PauseViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"PauseViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void)doBUttonResume:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    if ([_delegate respondsToSelector:@selector(onResume)])
    {
        [_delegate onResume];
    }
}

-(void)doButtonSettings:(id)sender
{
    
}

@end
