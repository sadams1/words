//
//  StoreCoinsViewController.h
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreCoinsViewControllerDelegate <NSObject>

- (void)storeCoinsViewControllerOnClose;

@end

@interface StoreCoinsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *buttonCoins1;
@property (nonatomic, retain) IBOutlet UIButton *buttonCoins2;
@property (nonatomic, retain) IBOutlet UIButton *buttonCoins3;
@property (nonatomic, retain) IBOutlet UIButton *buttonCoins4;
@property (nonatomic, retain) IBOutlet UIButton *buttonFreeCoins;   //  share
@property (nonatomic, retain) IBOutlet UIButton *buttonVideoAds;

- (IBAction)doButtonBuyCoins:(id)sender;
- (IBAction)doButtonFreeCoins:(id)sender;
- (IBAction)doButtonVideoAds:(id)sender;
- (IBAction)doButtonClose:(id)sender;

+ (StoreCoinsViewController*)sharedInstanceWithDelegate:(id<StoreCoinsViewControllerDelegate>)delegate;

@end
