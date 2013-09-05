//
//  HomeViewController.m
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "HomeViewController.h"
#import "GameViewController.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *xib = @"GameViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"GameViewController_iPad";
    }
    GameViewController *gameViewCont = [[GameViewController alloc] initWithNibName:xib bundle:nil];
    [self.navigationController pushViewController:gameViewCont animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
