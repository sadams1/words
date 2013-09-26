//
//  StorePayCoinsManager.m
//  words
//
//  Created by Marius Rott on 9/25/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "StorePayCoinsPopupManager.h"
#import "StorePayCoinsPopupView.h"

@interface StorePayCoinsPopupManager ()
{
    UIView *_parentView;
}

@property (nonatomic, copy) void(^onButton)(BOOL execute, BOOL resumeSession);

@end

static StorePayCoinsPopupManager *_instance;

@implementation StorePayCoinsPopupManager

@synthesize showPopup = _showPopup;

+ (StorePayCoinsPopupManager *)sharedInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[StorePayCoinsPopupManager alloc] init];
            
            //  load cell
            NSString *xib = @"StorePayCoinsPopupView";
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                xib = @"StorePayCoinsPopupView_iPad";
            }
            _instance.viewLoaderPayCoins = [UINib nibWithNibName:xib bundle:nil];
        }
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _showPopup = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.viewLoaderPayCoins release];
    [self.viewPopupPayCoins release];
    [super dealloc];
}

- (void)showPopupName:(NSString *)name description:(NSString *)description cost:(int)cost image:(UIImage *)image inView:(UIView *)parentView onButton:(void (^)(BOOL, BOOL))onButton
{
    if (_showPopup)
    {
        if (!self.viewPopupPayCoins)
        {
            [self.viewLoaderPayCoins instantiateWithOwner:self options:nil];
        }
        
        _parentView = parentView;
        self.viewPopupPayCoins.labelTitle.text = name;
        self.viewPopupPayCoins.labelDescription.text = description;
        self.viewPopupPayCoins.labelCost.text = [NSString stringWithFormat:@"Cost: %d coins", cost];
        self.viewPopupPayCoins.imageView.image = image;
        self.onButton = onButton;
        
        [parentView addSubview:self.viewPopupPayCoins];
    }
}

- (void)doButtonPopupOK:(id)sender
{
    _showPopup = NO;
    if (self.onButton)
    {
        self.onButton(YES, YES);
    }
    [self.viewPopupPayCoins removeFromSuperview];
}

- (void)doButtonPopupCancel:(id)sender
{
    if (self.onButton)
    {
        self.onButton(NO, YES);
    }
    [self.viewPopupPayCoins removeFromSuperview];
}

@end
