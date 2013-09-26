//
//  MGAdsManager.m
//  MGAds
//
//  Created by Marius Rott on 11/23/12.
//  Copyright (c) 2012 Marius Rott. All rights reserved.
//

#import "MGAdsManager.h"
#import "MGRevMob.h"
#import "MGChartboost.h"
#import "MGPlayHaven.h"

#import "Flurry.h"

#define MG_ADS_LOCK_UNLOCK_KEY      @"MG_ADS_LOCK_UNLOCK_KEY"

@implementation MGAdsManager

+ (MGAdsManager *)sharedInstance
{
    static MGAdsManager *instance;
    if (instance == nil)
    {
        instance = [[MGAdsManager alloc] init];
    
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _numOfDisplays = 0;
        _showAdsLocked = false;
    }
    return self;
}

- (void)dealloc
{
    if (self.mgAdPlayHaven)
        [self.mgAdPlayHaven release];
    if (self.mgAdRevMob)
        [self.mgAdRevMob release];
    if (self.mgAdChartboost)
        [self.mgAdChartboost release];
    [super dealloc];
}

- (void)startAdsManager
{
    if (![self isAdsEnabled])
    {
        //  disable ads purchased
        return;
    }
    self.mgAdRevMob = [[[MGRevMob alloc] init] autorelease];
    self.mgAdPlayHaven = [[[MGPlayHaven alloc] init] autorelease];
    self.mgAdChartboost = [[[MGChartboost alloc] init] autorelease];
    
    [self fetchAds];
}

- (void)fetchAds
{
    [[self getProviderForType:MG_ADS_PROVIDER_ORDER_1] fetchAds];
    [[self getProviderForType:MG_ADS_PROVIDER_ORDER_2] fetchAds];
    [[self getProviderForType:MG_ADS_PROVIDER_ORDER_3] fetchAds];
}

- (BOOL)isAvailable
{
    return ([self isAdsEnabled] &&
            !_showAdsLocked && (
            [[self getProviderForType:MG_ADS_PROVIDER_ORDER_1] isAvailable] ||
            [[self getProviderForType:MG_ADS_PROVIDER_ORDER_2] isAvailable] ||
            [[self getProviderForType:MG_ADS_PROVIDER_ORDER_3] isAvailable] ));
}

- (void)displayAdInViewController:(UIViewController *)viewController
{
    if (![self isAvailable])
    {
        [Flurry logEvent:@"MGAdsManager: isAvailable - false"];
        return;
    }
    
    //  type 1
    if ([[self getProviderForType:MG_ADS_PROVIDER_ORDER_1] isAvailable])
    {
        [[self getProviderForType:MG_ADS_PROVIDER_ORDER_1] showAdFromViewController:viewController];
        [self unlockShowAdsAfterInterval];
        _numOfDisplays++;
        return;
    }
    //  type 2
    if ([[self getProviderForType:MG_ADS_PROVIDER_ORDER_2] isAvailable])
    {
        [[self getProviderForType:MG_ADS_PROVIDER_ORDER_2] showAdFromViewController:viewController];
        [self unlockShowAdsAfterInterval];
        _numOfDisplays++;
        return;
    }
    //  type 3
    if ([[self getProviderForType:MG_ADS_PROVIDER_ORDER_3] isAvailable])
    {
        [[self getProviderForType:MG_ADS_PROVIDER_ORDER_3] showAdFromViewController:viewController];
        [self unlockShowAdsAfterInterval];
        _numOfDisplays++;
        return;
    }
}

- (id<MGAdsProvider>)getProviderForType:(MgAdsTypeProvider)providerType
{
    switch (providerType)
    {
        case MgAdsProviderPlayHaven:
            return self.mgAdPlayHaven;
        case MgAdsProviderRevMob:
            return self.mgAdRevMob;
        case MgAdsProviderChartboost:
            return self.mgAdChartboost;
        default:
            nil;
    }
}


- (BOOL)isAdsEnabled
{
    //  PRO VERSION HAS ADS DISABLED
#ifndef FREE_VERSION
    return false;
#endif
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MG_ADS_LOCK_UNLOCK_KEY] != NULL)
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:MG_ADS_LOCK_UNLOCK_KEY];
    }
    return TRUE;
}

- (void)disableAds
{
    NSLog(@"Ads disabled .... ");
    
    [Flurry logEvent:@"MGAdsManager: disableAds"];
    [[NSUserDefaults standardUserDefaults] setBool:false
                                            forKey:MG_ADS_LOCK_UNLOCK_KEY];
}

- (void)unlockShowAdsAfterInterval
{
    _showAdsLocked = true;
    
    int64_t delayInSeconds = MG_APP_AD_SECONDS_BETWEEN;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _showAdsLocked = false;
    });
}

@end
