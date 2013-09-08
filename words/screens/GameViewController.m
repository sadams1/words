//
//  GameViewController.m
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "GameViewController.h"
#import "StoreCoinsViewController.h"

@interface GameViewController ()
{
    WordTable *_wordTable;
    NSArray *_wordStrings;
}
@end

@implementation GameViewController

- (id)init
{
    NSString *xib = @"GameViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"GameViewController_iPad";
    }
    self = [self initWithNibName:xib bundle:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _wordStrings = [[NSArray alloc] initWithObjects:@"aaaaaaaaa", @"bbbbbbbb", @"ccccccccc", @"ddddddddd", nil];
        _wordTable = [[WordTable alloc] initWithWords:_wordStrings
                                             delegate:self];
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_wordTable viewDidLoadWithFrame:CGRectMake(54, 136, 660, 660)];
    [self.view addSubview:_wordTable.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [_wordTable.view convertPoint:locationPoint fromView:self.view];
    if ([_wordTable.view pointInside:viewPoint withEvent:event])
    {
        [_wordTable touchesBegan:viewPoint];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [_wordTable.view convertPoint:locationPoint fromView:self.view];
    //if ([_wordTable.view pointInside:viewPoint withEvent:event])
    //{
    [_wordTable touchesCancelled:viewPoint];
    //}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [_wordTable.view convertPoint:locationPoint fromView:self.view];
    //if ([_wordTable.view pointInside:viewPoint withEvent:event])
    //{
    [_wordTable touchesEnded:viewPoint];
    //}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    CGPoint viewPoint = [_wordTable.view convertPoint:locationPoint fromView:self.view];
    if ([_wordTable.view pointInside:viewPoint withEvent:event])
    {
        [_wordTable touchesMoved:viewPoint];
    }
}

- (void)doButtonStore:(id)sender
{
    [self presentViewController:[StoreCoinsViewController sharedInstance]
                       animated:NO
                     completion:^{
                                              
                                }];
}

- (void)doButtonHint:(id)sender
{
    [_wordTable doWordStartCharHint];
}

- (void)doButtonRemoveChars:(id)sender
{
    [_wordTable doRemoveUnnecessaryChars:10];
}

- (void)doButtonResolveGame:(id)sender
{
    [_wordTable doResolveGame];
}

- (void)doButtonPause:(id)sender
{
    
}

#pragma mark WordTableDelegate

- (void)wordTable:(WordTable *)wordTable changedTmpWord:(NSString *)word
{
    NSLog(@"changed tmp word: %@", word);
}

- (void)wordTable:(WordTable *)wordTable foundWord:(NSString *)word
{
    NSLog(@"found word %@", word);
}

- (void)wordTableCompletedGame:(WordTable *)wordTable
{
    NSLog(@"completed game");
}

#pragma mark -

@end
