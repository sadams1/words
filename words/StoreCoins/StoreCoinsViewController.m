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
#import "SoundUtils.h"
#import "ImageUtils.h"
#import <StoreKit/StoreKit.h>
#import "Reachability.h"
#import "MGAdsManager.h"
#import <Tapjoy/Tapjoy.h>

@interface StoreCoinsViewController ()
{
    BOOL _videoPlayed;
    BOOL _showVideoNoAds;
}

@property (nonatomic, assign) id<StoreCoinsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL showNotEnough;

@property (nonatomic, retain) NSArray *skProducts;

- (void)loadSKProducts;
- (void)refreshView;

- (void)notificationProductPurchased:(NSNotification *)notification;
- (void)notificationProductPurchaseFailed:(NSNotification *)notification;

- (void)networkChanged:(NSNotification *)notification;

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offerwallClosed:)
                                                     name:TJC_VIEW_CLOSED_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(offerwallPointsEarned:)
                                                     name:TJC_TAPPOINTS_EARNED_NOTIFICATION object:nil];
        
        _showVideoNoAds = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationProductPurchased:)
                                                     name:IAPHelperProductPurchasedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationProductPurchaseFailed:)
                                                     name:IAPHelperProductPurchaseFailedNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [self.skProducts release];
    [self.buttonCoins1 release];
    [self.buttonCoins2 release];
    [self.buttonCoins3 release];
    [self.buttonCoins4 release];
    [self.buttonFreeCoins release];
    [self.buttonVideoAds release];
    
    [self.labelTitle release];
    [self.labelStoreCoins release];
    [self.labelButtonFreeTitle release];
    [self.labelButtonVideoTitle release];
    [self.labelButtonVideoCoins release];
    
    [self.labelCoins1Title release];
    [self.labelCoins2Title release];
    [self.labelCoins3Title release];
    [self.labelCoins4Title release];
    
    [self.labelCoins1Subtitle release];
    [self.labelCoins2Subtitle release];
    [self.labelCoins3Subtitle release];
    [self.labelCoins4Subtitle release];
    
    [self.labelCoins1Price release];
    [self.labelCoins2Price release];
    [self.labelCoins3Price release];
    [self.labelCoins4Price release];
    
    [self.labelCoins1Buy release];
    [self.labelCoins2Buy release];
    [self.labelCoins3Buy release];
    [self.labelCoins4Buy release];
    
    [self.labelNotEnough release];
    [self.labelNoVideoAds release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    if (reachability.currentReachabilityStatus != NotReachable)
    {
        [self loadSKProducts];
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Network Connection"
                                                         message:@"Please connect to internet to have access to Coins purchases!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.labelTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:30];
        self.labelStoreCoins.font = [UIFont fontWithName:@"Nexa Bold" size:15];
        self.labelNoVideoAds.font = [UIFont fontWithName:@"Segoe UI" size:22];
        self.labelNotEnough.font = [UIFont fontWithName:@"Segoe UI" size:36];
        self.labelButtonFreeTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        self.labelButtonVideoTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        self.labelButtonVideoCoins.font = [UIFont fontWithName:@"Nexa Bold" size:15];
        
        self.labelCoins1Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        self.labelCoins2Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        self.labelCoins3Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        self.labelCoins4Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:24];
        
        self.labelCoins1Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:22];
        self.labelCoins2Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:22];
        self.labelCoins3Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:22];
        self.labelCoins4Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:22];
        
        self.labelCoins1Price.font = [UIFont fontWithName:@"Nexa Bold" size:22];
        self.labelCoins2Price.font = [UIFont fontWithName:@"Nexa Bold" size:22];
        self.labelCoins3Price.font = [UIFont fontWithName:@"Nexa Bold" size:22];
        self.labelCoins4Price.font = [UIFont fontWithName:@"Nexa Bold" size:22];
        
        self.labelCoins1Buy.font = [UIFont fontWithName:@"Nexa Bold" size:18];
        self.labelCoins2Buy.font = [UIFont fontWithName:@"Nexa Bold" size:18];
        self.labelCoins3Buy.font = [UIFont fontWithName:@"Nexa Bold" size:18];
        self.labelCoins4Buy.font = [UIFont fontWithName:@"Nexa Bold" size:18];
    }
    else
    {
        self.labelTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:20];
        self.labelStoreCoins.font = [UIFont fontWithName:@"Nexa Bold" size:12];
        self.labelNoVideoAds.font = [UIFont fontWithName:@"Segoe UI" size:14];
        self.labelNotEnough.font = [UIFont fontWithName:@"Segoe UI" size:16];
        self.labelButtonFreeTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        self.labelButtonVideoTitle.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        self.labelButtonVideoCoins.font = [UIFont fontWithName:@"Nexa Bold" size:12];
        
        self.labelCoins1Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        self.labelCoins2Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        self.labelCoins3Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        self.labelCoins4Title.font = [UIFont fontWithName:@"Lucida Calligraphy" size:14];
        
        self.labelCoins1Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:12];
        self.labelCoins2Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:12];
        self.labelCoins3Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:12];
        self.labelCoins4Subtitle.font = [UIFont fontWithName:@"Segoe UI" size:12];
        
        self.labelCoins1Price.font = [UIFont fontWithName:@"Nexa Bold" size:14];
        self.labelCoins2Price.font = [UIFont fontWithName:@"Nexa Bold" size:14];
        self.labelCoins3Price.font = [UIFont fontWithName:@"Nexa Bold" size:14];
        self.labelCoins4Price.font = [UIFont fontWithName:@"Nexa Bold" size:14];
        
        self.labelCoins1Buy.font = [UIFont fontWithName:@"Nexa Bold" size:12];
        self.labelCoins2Buy.font = [UIFont fontWithName:@"Nexa Bold" size:12];
        self.labelCoins3Buy.font = [UIFont fontWithName:@"Nexa Bold" size:12];
        self.labelCoins4Buy.font = [UIFont fontWithName:@"Nexa Bold" size:12];
    }
    
    self.labelNoVideoAds.textColor = THEME_COLOR_RED;
    self.labelNotEnough.textColor = THEME_COLOR_RED;
    self.labelNotEnough.text = @"Not enough coins!";
    
    UIImage *imageRed = [ImageUtils imageWithColor:THEME_COLOR_RED
                                          rectSize:self.buttonFreeCoins.frame.size];
    
    [self.buttonFreeCoins setImage:imageRed
                          forState:UIControlStateNormal];
    [self.buttonVideoAds setImage:imageRed
                         forState:UIControlStateNormal];

    self.labelButtonVideoCoins.text = [NSString stringWithFormat:@"%d", COINS_REWARD_FOR_VIEWS];
    
    self.labelCoins1Title.text = STORE_BUNDLE_IN_APP_1_TITLE;
    self.labelCoins2Title.text = STORE_BUNDLE_IN_APP_2_TITLE;
    self.labelCoins3Title.text = STORE_BUNDLE_IN_APP_3_TITLE;
    self.labelCoins4Title.text = STORE_BUNDLE_IN_APP_4_TITLE;
    
    self.labelCoins1Subtitle.text = STORE_BUNDLE_IN_APP_1_DESCRIPTION;
    self.labelCoins2Subtitle.text = STORE_BUNDLE_IN_APP_2_DESCRIPTION;
    self.labelCoins3Subtitle.text = STORE_BUNDLE_IN_APP_3_DESCRIPTION;
    self.labelCoins4Subtitle.text = STORE_BUNDLE_IN_APP_4_DESCRIPTION;
    
    UIImage *imageBackButton = [ImageUtils imageWithColor:THEME_COLOR_GRAY_LIGHT
                                                 rectSize:self.buttonCoins1.frame.size];
    
    [self.buttonCoins1 setBackgroundImage:imageBackButton
                                 forState:UIControlStateHighlighted];
    [self.buttonCoins2 setBackgroundImage:imageBackButton
                                 forState:UIControlStateHighlighted];
    [self.buttonCoins3 setBackgroundImage:imageBackButton
                                 forState:UIControlStateHighlighted];
    [self.buttonCoins4 setBackgroundImage:imageBackButton
                                 forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshView];
    
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

- (void)loadSKProducts
{
    if (!self.skProducts.count)
    {
        [[MGIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success)
            {
                self.skProducts = products;
                [self refreshView];
            }
        }];
    }
}

- (void)refreshView
{
//    NSLog(@"%d videos", [[CoinsManager sharedInstance] getVideoViews]);
    
    self.labelStoreCoins.text = [NSString stringWithFormat:@"%d", [[CoinsManager sharedInstance] getCoins]];
    
    self.labelButtonVideoTitle.text = [NSString stringWithFormat:@"Watch %d videos", [[CoinsManager sharedInstance] getVideoViews]];
    
    if (!self.labelNoVideoAds.hidden)
    {
        self.labelNoVideoAds.hidden = YES;
    }
    
    SKProduct *coins1 = [self getSKProductForBundleID:STORE_BUNDLE_IN_APP_1];
    if (coins1)
        self.labelCoins1Price.text = [MGIAPHelper priceForSKProduct:coins1];
    SKProduct *coins2 = [self getSKProductForBundleID:STORE_BUNDLE_IN_APP_2];
    if (coins2)
        self.labelCoins2Price.text = [MGIAPHelper priceForSKProduct:coins2];
    SKProduct *coins3 = [self getSKProductForBundleID:STORE_BUNDLE_IN_APP_3];
    if (coins3)
        self.labelCoins3Price.text = [MGIAPHelper priceForSKProduct:coins3];
    SKProduct *coins4 = [self getSKProductForBundleID:STORE_BUNDLE_IN_APP_4];
    if (coins4)
        self.labelCoins4Price.text = [MGIAPHelper priceForSKProduct:coins4];
    
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
    
    SKProduct *product = [self getSKProductForBundleID:bundleID];
    if (!product)
        return;
    
    [[MGIAPHelper sharedInstance] buyProduct:product];
    
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
    
    [Tapjoy showOffersWithViewController:self];
}

- (void)doButtonVideoAds:(id)sender
{
    [Flurry logEvent:@"GAME: doButtonVideoAds"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"coins", [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]], nil]];
    
    if ([VGVunglePub adIsAvailable])
    {
        [VGVunglePub setDelegate:self];
        [VGVunglePub playModalAd:self
                        animated:YES
                       showClose:YES];
    }
    else
    {
        self.labelNoVideoAds.hidden = NO;
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.labelNoVideoAds.hidden = YES;
        });
    }
}

- (void)doButtonClose:(id)sender
{
    [Flurry logEvent:@"GAME: doButtonRemoveClose"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"coins", [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]], nil]];
    
    [[SoundUtils sharedInstance] playSoundEffect:SoundTypeBack];
    
    if (_delegate && [_delegate respondsToSelector:@selector(storeCoinsViewControllerOnClose)])
    {
        [_delegate storeCoinsViewControllerOnClose];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark VGVungleDelegate

-(void)vungleMoviePlayed:(VGPlayData*)playData
{
    _videoPlayed = YES;
}

-(void)vungleStatusUpdate:(VGStatusData*)statusData
{
    
}

-(void)vungleViewDidDisappear:(UIViewController*)viewController
{
    if (_videoPlayed)
    {
        BOOL canReceiveCoins = [[CoinsManager sharedInstance] substractVideoViews];
        
        if (canReceiveCoins)
        {
            [Flurry logEvent:@"StoreCoins: vungleReceiveCoins"
              withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"coins",
                              [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]],
                              nil]];
            
            [[CoinsManager sharedInstance] addCoins:COINS_REWARD_FOR_VIEWS];
            [[SoundUtils sharedInstance] playSoundEffect:SoundTypeCoinsAdded];
        }
    }
    [self refreshView];
}

-(void)vungleViewWillAppear:(UIViewController*)viewController
{
    _videoPlayed = NO;
}

#pragma mark -

- (void)notificationProductPurchased:(NSNotification *)notification
{
    NSString *bundleID = notification.object;
    int coins = 0;
    if ([bundleID caseInsensitiveCompare:STORE_BUNDLE_IN_APP_1] == NSOrderedSame)
    {
        coins = STORE_BUNDLE_IN_APP_1_COINS;
    }
    else if ([bundleID caseInsensitiveCompare:STORE_BUNDLE_IN_APP_2] == NSOrderedSame)
    {
        coins = STORE_BUNDLE_IN_APP_2_COINS;
    }
    else if ([bundleID caseInsensitiveCompare:STORE_BUNDLE_IN_APP_3] == NSOrderedSame)
    {
        coins = STORE_BUNDLE_IN_APP_3_COINS;
    }
    else if ([bundleID caseInsensitiveCompare:STORE_BUNDLE_IN_APP_4] == NSOrderedSame)
    {
        coins = STORE_BUNDLE_IN_APP_4_COINS;
    }
    
    [Flurry logEvent:@"StoreCoins: purchasedProduct"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                      @"coins",
                      [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]],
                      @"bundleID",
                      bundleID,
                      nil]];
    
    //  disable MGAdsManager ads
    [[MGAdsManager sharedInstance] disableAds];
    
    [[CoinsManager sharedInstance] addCoins:coins];
    [[SoundUtils sharedInstance] playSoundEffect:SoundTypeCoinsAdded];
    [self refreshView];
    
    NSLog(@"current coins %d", [[CoinsManager sharedInstance] getCoins]);
}

- (void)notificationProductPurchaseFailed:(NSNotification *)notification
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Purchase error"
                                                     message:@"There was an error completing your purchase. Please try again later!"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

- (SKProduct *)getSKProductForBundleID:(NSString *)bundleID
{
    if (self.skProducts != nil && [self.skProducts count] > 0)
    {
        for (SKProduct *tmp in self.skProducts)
        {
            if ([tmp.productIdentifier compare:bundleID] == NSOrderedSame)
            {
                return tmp;
            }
        }
    }
    return nil;
}

- (void)networkChanged:(NSNotification *)notification
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"not reachable");
    }
    else
    {
        [self loadSKProducts];
    }
}

//  tapjoy
-(void)offerwallClosed:(NSNotification*)notifyObj
{
    [Tapjoy getTapPoints];
    NSLog(@"Offerwall closed");
    
}

-(void)offerwallPointsEarned:(NSNotification*)notifyObj
{
    NSNumber *tapPointsEarned = notifyObj.object;
	int earnedNum = [tapPointsEarned intValue];
	
	NSLog(@"Currency earned: %d", earnedNum);
    
    [Flurry logEvent:@"StoreCoins: tapjoyEarnedCoins"
      withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                      @"coins",
                      [NSNumber numberWithInt:[[CoinsManager sharedInstance] getCoins]],
                      @"earnedNum",
                      [NSNumber numberWithInt:earnedNum],
                      nil]];
    
    [[CoinsManager sharedInstance] addCoins:earnedNum];
    [[SoundUtils sharedInstance] playSoundEffect:SoundTypeCoinsAdded];
}

@end
