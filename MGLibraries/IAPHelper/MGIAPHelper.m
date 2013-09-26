//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "MGIAPHelper.h"
#import "configuration.h"

@implementation MGIAPHelper

+ (MGIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static MGIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      STORE_BUNDLE_IN_APP_1,
                                      STORE_BUNDLE_IN_APP_2,
                                      STORE_BUNDLE_IN_APP_3,
                                      STORE_BUNDLE_IN_APP_4,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
