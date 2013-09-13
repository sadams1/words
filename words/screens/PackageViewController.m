//
//  PackageViewController.m
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "PackageViewController.h"
#import "GameViewController.h"
#import "CoreDataUtils.h"
#import "Category.h"
#import "Game.h"
#import "PackageGameCell.h"

@interface PackageViewController ()

@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSArray *games;

- (void)configureGameCell:(PackageGameCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PackageViewController

- (id)initWithCategory:(Category *)category
{
    NSString *xib = @"PackageViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"PackageViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        self.category = category;
        
        NSSortDescriptor *sortDescriptorID = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                         ascending:YES];
        self.games = [[self.category.games allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptorID]];
        
        //  load cell
        NSString *xib = @"PackageGameCell";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            xib = @"PackageGameCell_iPad";
        }
        self.cellLoaderGame = [UINib nibWithNibName:xib bundle:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.category release];
    [self.games release];
    [self.tableView release];
    [self.cellGame release];
    [self.cellLoaderGame release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.category.games.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageGameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TABLE_VIEW_TYPE_GAME"];
    if (cell == nil) {
        [self.cellLoaderGame instantiateWithOwner:self options:nil];
        cell = self.cellGame;
        self.cellGame = nil;
    }
    
    [self.cellLoaderGame instantiateWithOwner:self options:nil];
    
    [self configureGameCell:cell
                atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [[self.category.games allObjects] objectAtIndex:indexPath.row];
    GameViewController *gameViewCont = [[GameViewController alloc] initWithGame:game parentViewController:self];
    [self.navigationController pushViewController:gameViewCont animated:YES];
}

- (void)configureGameCell:(PackageGameCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [self.games objectAtIndex:indexPath.row];
    cell.labelName.text = game.name;
    
    NSNumber *sum = [game.sessions valueForKeyPath:@"@sum.points"];
    NSString *points = [NSString stringWithFormat:@"%d", sum.intValue];
    
    cell.labelName.text = [NSString stringWithFormat:@"%@ --- %@", points, cell.labelName.text];
}

#pragma mark -


@end
