//
//  StorePayCoinsPopupView.m
//  words
//
//  Created by Marius Rott on 9/25/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "StorePayCoinsPopupView.h"

@implementation StorePayCoinsPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [self.labelTitle release];
    [self.labelDescription release];
    [self.labelCost release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
