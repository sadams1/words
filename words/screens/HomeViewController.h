//
//  HomeViewController.h
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCoinsViewController.h"
#import "HomePackageCell.h"
#import "HomeQuestCell.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, StoreCoinsViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIButton *buttonStore;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet HomePackageCell *cellPackage;
@property (nonatomic, retain) IBOutlet HomeQuestCell *cellQuest;

@property (nonatomic, retain) UINib *cellLoaderPackage;
@property (nonatomic, retain) UINib *cellLoaderQuest;

- (IBAction)doButtonCategory:(id)sender;
- (IBAction)doButtonQuest:(id)sender;
- (IBAction)doButtonStore:(id)sender;
- (IBAction)doButtonQuickPlay:(id)sender;

- (IBAction)doButtonSkipQuest:(id)sender;

@end
