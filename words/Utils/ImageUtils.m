//
//  ImageUtils.m
//  words
//
//  Created by Marius Rott on 9/17/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "ImageUtils.h"
#import "configuration.h"

@implementation ImageUtils

+ (UIView*)getStarImageViewForPercentage:(float)percentage
{
    int offset = 10;
    UIImage *imageStar = [UIImage imageNamed:@"transparent-star.png"];
    float starPercent = 1.0 / STAR_IMAGES_COUNT;
    
    
    int viewWidth = STAR_IMAGES_COUNT *imageStar.size.width + ((STAR_IMAGES_COUNT - 1) * offset);
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, imageStar.size.height)] autorelease];
    
    int fullStars = percentage / starPercent;
    for (int i = 0; i < fullStars; i++)
    {
        UIView *background = [[[UIView alloc] initWithFrame:CGRectMake((i * imageStar.size.width) + (i * offset),
                                                                       0,
                                                                       imageStar.size.width,
                                                                       imageStar.size.height)] autorelease];
        background.backgroundColor = STAR_IMAGE_BACK_COLOR;
        [view addSubview:background];
        UIImageView *imgView = [[[UIImageView alloc] initWithImage:imageStar] autorelease];
        imgView.frame = CGRectMake(background.frame.origin.x,
                                   background.frame.origin.y,
                                   imgView.frame.size.width,
                                   imgView.frame.size.height);
        [view addSubview:imgView];
    }
    
    float lastPercent = (percentage - (fullStars * starPercent)) * STAR_IMAGES_COUNT;
    UIView *background = [[[UIView alloc] initWithFrame:CGRectMake((fullStars * imageStar.size.width) + (fullStars * offset),
                                                                   0,
                                                                   imageStar.size.width * lastPercent,
                                                                   imageStar.size.height)] autorelease];
    background.backgroundColor = STAR_IMAGE_BACK_COLOR;
    [view addSubview:background];
    UIImageView *imgView = [[[UIImageView alloc] initWithImage:imageStar] autorelease];
    imgView.frame = CGRectMake(background.frame.origin.x,
                               background.frame.origin.y,
                               imgView.frame.size.width,
                               imgView.frame.size.height);
    [view addSubview:imgView];
    
    return view;
}

@end
