//
//  PackageViewController.h
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;
@class PackageGameCell;

@interface PackageViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet PackageGameCell *cellGame;
@property (nonatomic, retain) UINib *cellLoaderGame;

- (id)initWithCategory:(Category*)category;

- (IBAction)doButtonBack:(id)sender;

@end
