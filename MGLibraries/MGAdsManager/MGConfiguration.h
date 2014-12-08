//
//  MGConfiguration.h
//  MGAds
//
//  Created by Marius Rott on 11/23/12.
//  Copyright (c) 2012 Marius Rott. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     MG_ADS_REVMOB_APP_ID        @"52551d86e1a7a0edf9000041"
#define     MG_ADS_CHARTBOOST_APP_ID    @"52381fd017ba47537d000004"
#define     MG_ADS_CHARTBOOST_APP_SIG   @"31c66b3014ec371c05b1350f4014304fd4caaa1f"


#define     MG_REFETCH_AFTER            30

#define     MG_APP_AD_MIN_DISPLAY       1
#define     MG_APP_AD_SECONDS_BETWEEN   90


typedef enum
{
    MgAdsProviderRevMob = 1,
    MgAdsProviderChartboost,
    MgAdsProviderPlayHaven,
    MgAdsProviderAppLovin
} MgAdsTypeProvider;

#define     MG_ADS_PROVIDER_ORDER_1     MgAdsProviderAppLovin
#define     MG_ADS_PROVIDER_ORDER_2     MgAdsProviderChartboost
#define     MG_ADS_PROVIDER_ORDER_3     MgAdsProviderRevMob
#define     MG_ADS_PROVIDER_ORDER_4     MgAdsProviderPlayHaven
#define     MG_ADS_NUM_PROVIDERS        4

