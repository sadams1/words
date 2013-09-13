//
//  StoreCoinsViewController.m
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "StoreCoinsViewController.h"

@interface StoreCoinsViewController ()

@property (nonatomic, assign) id<StoreCoinsViewControllerDelegate> delegate;

@end

@implementation StoreCoinsViewController

+ (StoreCoinsViewController *)sharedInstanceWithDelegate:(id<StoreCoinsViewControllerDelegate>)delegate
{
    static StoreCoinsViewController *instance;
    if (instance == nil)
    {
        instance = [[StoreCoinsViewController alloc] init];
    }
    instance.delegate = delegate;
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
    if (self) {
        
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
    [super dealloc];
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

- (void)doButtonBuyCoins:(id)sender
{
    
}

- (void)doButtonFreeCoins:(id)sender
{
    
}

- (void)doButtonVideoAds:(id)sender
{
    
}

- (void)doButtonClose:(id)sender
{
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
