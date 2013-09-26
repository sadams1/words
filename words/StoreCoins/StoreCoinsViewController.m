//
//  StoreCoinsViewController.m
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "StoreCoinsViewController.h"
#import "CoinsManager.h"
#import "configuration.h"
#import "MGIAPHelper.h"
#import "Flurry.h"

@interface StoreCoinsViewController ()

@property (nonatomic, assign) id<StoreCoinsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL showNotEnough;

@end

@implementation StoreCoinsViewController

+ (StoreCoinsViewController *)sharedInstanceWithDelegate:(id<StoreCoinsViewControllerDelegate>)delegate showNotEnoughCoins:(BOOL)showNotEnough
{
    static StoreCoinsViewController *instance;
    if (instance == nil)
    {
        instance = [[StoreCoinsViewController alloc] init];
    }
    instance.delegate = delegate;
    instance.showNotEnough = showNotEnough;
    
    return instance;
}

- (id)init
{
    NSString *xib = @"StoreCoinsViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"StoreCoinsViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [self.buttonCoins1 release];
    [self.buttonCoins2 release];
    [self.buttonCoins3 release];
    [self.buttonCoins4 release];
    [self.buttonFreeCoins release];
    [self.buttonVideoAds release];
    [self.labelNotEnough release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MGIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showNotEnough)
    {
        self.labelNotEnough.hidden = NO;
    }
    else
    {
        self.labelNotEnough.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doButtonBuyCoins:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    NSString *bundleID = @"";
    switch (tag)
    {
        case 1: bundleID = STORE_BUNDLE_IN_APP_1; break;
        case 2: bundleID = STORE_BUNDLE_IN_APP_2; break;
        case 3: bundleID = STORE_BUNDLE_IN_APP_3; break;
        case 4: bundleID = STORE_BUNDLE_IN_APP_4; break;
    }
    
    [Flurry logEvent:@"StoreCoins: doButtonBuyCoins"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                      @"coins",
                      [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]],
                      @"bundleID",
                      bundleID,
                      nil]];
}

- (void)doButtonFreeCoins:(id)sender
{
    [Flurry logEvent:@"GAME: doButtonFreeCoins"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"coins", [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]], nil]];
    
}

- (void)doButtonVideoAds:(id)sender
{
    [Flurry logEvent:@"GAME: doButtonVideoAds"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"coins", [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]], nil]];
    
}

- (void)doButtonClose:(id)sender
{
    [Flurry logEvent:@"GAME: doButtonRemoveClose"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"coins", [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]], nil]];
    
    [self dismissViewControllerAnimated:NO
                             completion:^{
                                 if (self.delegate)
                                 {
                                     if ([self.delegate respondsToSelector:@selector(storeCoinsViewControllerOnClose)])
                                     {
                                         [self.delegate storeCoinsViewControllerOnClose];
                                     }
                                 }
                                        }];
}

@end
