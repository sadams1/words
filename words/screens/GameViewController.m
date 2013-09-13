//
//  GameViewController.m
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "GameViewController.h"
#import "PauseViewController.h"
#import "CoreDataUtils.h"
#import "Game.h"
#import "WordStr.h"
#import "configuration.h"
#import "CoinsManager.h"

@interface GameViewController ()
{
    WordTable *_wordTable;
    NSArray *_wordStrings;
    NSMutableArray *_labelWords;
    GameSession *_gameSession;
    UIViewController *_parentViewController;
}

@property (nonatomic, retain) Game *game;

- (void)updateScreen;
- (void)openStore;
- (void)setLabelWordsInFrame:(CGRect)frame;
- (NSArray*)getWordStringsFromCDSet:(NSSet*)cdArray;

@end

@implementation GameViewController

- (id)initWithGame:(Game *)game parentViewController:(UIViewController *)viewController
{
    NSString *xib = @"GameViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"GameViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        self.game = game;
        
        _wordStrings = [[NSArray alloc] initWithArray:[self getWordStringsFromCDSet:game.words]];
        _wordTable = [[WordTable alloc] initWithWords:_wordStrings
                                             delegate:self];
        _labelWords = [[NSMutableArray alloc] init];
        _gameSession = [[GameSession alloc] initWithGame:game
                                                delegate:self];
        _parentViewController = viewController;
    }
    return self;
}

- (void)dealloc
{
    [self.buttonHint release];
    [self.buttonPause release];
    [self.buttonRemoveChars release];
    [self.buttonResolveGame release];
    [self.buttonStore release];
    [self.labelTime release];
    [self.labelTmpWord release];
    [_wordTable release];
    [_wordStrings release];
    [_labelWords release];
    [_gameSession release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [_wordTable viewDidLoadWithFrame:CGRectMake(54, 136, 660, 660)];
        [self setLabelWordsInFrame:CGRectMake(54, 800, 660, 98)];
    }
    else
    {
        
    }
    
    [self.view addSubview:_wordTable.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScreen
{
    [self.buttonStore setTitle:[NSString stringWithFormat:@"S: %d", [[CoinsManager sharedInstance] getCoins]]
                      forState:UIControlStateNormal];
}

- (void)openStore
{
    //  pause game & open store
    [_gameSession pause];
    [self presentViewController:[StoreCoinsViewController sharedInstanceWithDelegate:self]
                       animated:NO
                     completion:^{
                         
                     }];
}

- (void)setLabelWordsInFrame:(CGRect)frame
{
    int offset = 4;
    float width = (frame.size.width - (2*offset)) / 3; // 3 columns
    float height = (frame.size.height - (2*offset)) / 3;
    
    for (int i = 0; i < _wordStrings.count; i++)
    {
        NSString *word = [_wordStrings objectAtIndex:i];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + ((i % 3) * (width + offset)),
                                                                   frame.origin.y + (((int)i/3) * (height + offset)),
                                                                   width,
                                                                   height)] autorelease];
        label.text = word;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [_labelWords addObject:label];
    }
}

- (NSArray *)getWordStringsFromCDSet:(NSSet *)cdArray
{
    NSMutableArray *tmpWArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tmpArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *inputArray = [cdArray allObjects];
    
    while (tmpWArray.count < WORDS_PER_GAME)
    {
        WordStr *wStr = [inputArray objectAtIndex:arc4random() % (inputArray.count)];
        if (![tmpWArray containsObject:wStr])
        {
            [tmpWArray addObject:wStr];
        }
    }
    
    for (WordStr *wordStr in tmpWArray)
    {
        [tmpArray addObject:wordStr.string];
    }
    return tmpArray;
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
    [self openStore];
}

- (void)doButtonHint:(id)sender
{
    /*
    if ([[CoinsManager sharedInstance] getCoins] < COST_HINT)
    {
        [self openStore];
        return;
    }
     */
    [_wordTable doWordStartCharHint];
    [[CoinsManager sharedInstance] substractCoins:COST_HINT];
    [self updateScreen];
}

- (void)doButtonRemoveChars:(id)sender
{
    if ([[CoinsManager sharedInstance] getCoins] < COST_REMOVE_LETTERS)
    {
        [self openStore];
        return;
    }
    if ([_wordTable canRemoveUnnecessaryChars:WORD_TABLE_REMOVE_CHARS])
    {
        [_wordTable doRemoveUnnecessaryChars:WORD_TABLE_REMOVE_CHARS];
        [[CoinsManager sharedInstance] substractCoins:COST_REMOVE_LETTERS];
        [self updateScreen];
    }
    else
    {
        //  todo: show something ... can not remove num of chars
    }
}

- (void)doButtonResolveGame:(id)sender
{
    if ([[CoinsManager sharedInstance] getCoins] < COST_RESOLVE_GAME)
    {
        [self openStore];
        return;
    }
    [_wordTable doResolveGame];
    [[CoinsManager sharedInstance] substractCoins:COST_RESOLVE_GAME];
    [self updateScreen];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //  todo: open finish game screen
    });
}

- (void)doButtonPause:(id)sender
{
    [_gameSession pause];
    PauseViewController *pauseViewController = [[[PauseViewController alloc] initWithDelegate:self] autorelease];
    [self.navigationController pushViewController:pauseViewController animated:NO];
}

#pragma mark protocol GameViewControllerDelegate

- (void)onBack
{
    NSLog(@"%@", self.parentViewController.class);
    [self.navigationController popToViewController:_parentViewController animated:YES];
}

- (void)onRestart
{
    [_wordStrings release];
    _wordStrings = [[NSArray alloc] initWithArray:[self getWordStringsFromCDSet:self.game.words]];
    
    [_wordTable.view removeFromSuperview];
    [_wordTable release];
    _wordTable = [[WordTable alloc] initWithWords:_wordStrings
                                         delegate:self];
    for (UILabel *label in _labelWords)
    {
        [label removeFromSuperview];
    }
    [_labelWords release];
    _labelWords = [[NSMutableArray alloc] init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [_wordTable viewDidLoadWithFrame:CGRectMake(54, 136, 660, 660)];
        [self setLabelWordsInFrame:CGRectMake(54, 800, 660, 98)];
    }
    else
    {
        
    }
    [self.view addSubview:_wordTable.view];
    
    [_gameSession release];
    _gameSession = [[GameSession alloc] initWithGame:self.game
                                            delegate:self];
    self.labelTime.text = @"00:00";
}

- (void)onResume
{
    [_gameSession resume];
}

#pragma mark -

#pragma mark WordTableDelegate

- (void)wordTable:(WordTable *)wordTable changedTmpWord:(NSString *)word
{
    self.labelTmpWord.text = word;
}

- (void)wordTable:(WordTable *)wordTable foundWord:(NSString *)word
{
    for (UILabel *label in _labelWords)
    {
        if ([label.text caseInsensitiveCompare:word] == NSOrderedSame)
        {
            label.backgroundColor = [UIColor blueColor];
        }
    }
}

- (void)wordTableCompletedGame:(WordTable *)wordTable
{
    [_gameSession gameCompleted];
}

#pragma mark -

#pragma mark GameSessionDelegate

- (void)onTimeChanged:(NSString *)timeString
{
    self.labelTime.text = timeString;
}

#pragma mark -

#pragma mark StoreCoinsViewControllerDelegate

- (void)storeCoinsViewControllerOnClose
{
    [_gameSession resume];
    [self updateScreen];
}

#pragma mark -

@end
