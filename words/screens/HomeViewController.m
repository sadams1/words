//
//  HomeViewController.m
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "HomeViewController.h"
#import "GameViewController.h"
#import "StoreCoinsViewController.h"
#import "PackageViewController.h"
#import "CoreDataUtils.h"
#import "CoinsManager.h"
#import "QuestManager.h"
#import "Category.h"
#import "Quest.h"
#import "Level.h"

#define TABLE_VIEW_TYPE_CATEGORY     1
#define TABLE_VIEW_TYPE_QUEST        2

@interface HomeViewController ()
{
    int _tableViewType;
}

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *quests;

- (void)configurePackageCell:(HomePackageCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)configureQuestCell:(HomeQuestCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation HomeViewController

- (id)init
{
    NSString *xib = @"HomeViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"HomeViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self) {
        _tableViewType = TABLE_VIEW_TYPE_CATEGORY;
        
        //  load data
        NSSortDescriptor *sortDescriptorID = [[NSSortDescriptor alloc] initWithKey:@"identifier"
                                                                         ascending:YES];
        
        NSFetchRequest *requestCategory = [[[NSFetchRequest alloc] initWithEntityName:@"Category"] autorelease];
        requestCategory.sortDescriptors = [NSArray arrayWithObjects:sortDescriptorID, nil];
        NSError *error1 = nil;
        self.categories = [[CoreDataUtils sharedInstance].managedObjectContext executeFetchRequest:requestCategory error:&error1];
        
        NSFetchRequest *requestQuests = [[[NSFetchRequest alloc] initWithEntityName:@"Quest"] autorelease];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completed == NO"];
        [requestQuests setPredicate:predicate];
        requestQuests.sortDescriptors = [NSArray arrayWithObjects:sortDescriptorID, nil];
        NSError *error2 = nil;
        NSArray *quests = [[CoreDataUtils sharedInstance].managedObjectContext executeFetchRequest:requestQuests error:&error2];
        if (!error2)
        {
            if (quests.count)
            {
                self.quests = [((Quest*)[quests objectAtIndex:0]).level.quests allObjects];
                self.quests = [self.quests sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptorID]];
            }
        }
        
        //  load cell
        NSString *xib = @"HomePackageCell";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            xib = @"HomePackageCell_iPad";
        }
        self.cellLoaderPackage = [UINib nibWithNibName:xib bundle:nil];
        xib = @"HomeQuestCell";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            xib = @"HomeQuestCell_iPad";
        }
        self.cellLoaderQuest = [UINib nibWithNibName:xib bundle:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.tableView release];
    [self.categories release];
    [self.quests release];
    [self.cellLoaderPackage release];
    [self.cellLoaderQuest release];
    [self.cellPackage release];
    [self.cellQuest release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doButtonCategory:(id)sender
{
    _tableViewType = TABLE_VIEW_TYPE_CATEGORY;
    [self.tableView reloadData];
}

- (IBAction)doButtonQuest:(id)sender
{
    _tableViewType = TABLE_VIEW_TYPE_QUEST;
    [self.tableView reloadData];
}

- (void)doButtonStore:(id)sender
{
    [self presentViewController:[StoreCoinsViewController sharedInstanceWithDelegate:self]
                       animated:NO
                     completion:^{
                         
                     }];
}

- (void)doButtonQuickPlay:(id)sender
{
    
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableViewType == TABLE_VIEW_TYPE_CATEGORY)
        return self.categories.count;
    else
        return self.quests.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 60;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        height = 100;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_tableViewType == TABLE_VIEW_TYPE_CATEGORY)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TABLE_VIEW_TYPE_CATEGORY"];
        if (cell == nil) {
            [self.cellLoaderPackage instantiateWithOwner:self options:nil];
            cell = self.cellPackage;
            self.cellPackage = nil;
        }
        
        [self.cellLoaderPackage instantiateWithOwner:self options:nil];
        
        [self configurePackageCell:cell
                       atIndexPath:indexPath];
    }
    else
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"TABLE_VIEW_TYPE_QUESTS"];
        if (cell == nil) {
            [self.cellLoaderQuest instantiateWithOwner:self options:nil];
            cell = self.cellQuest;
            self.cellQuest = nil;
        }
        
        [self.cellLoaderQuest instantiateWithOwner:self options:nil];
        
        [self configureQuestCell:cell
                     atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageViewController *packageViewCont = [[PackageViewController alloc] initWithCategory:[self.categories objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:packageViewCont animated:YES];
}

- (void)configurePackageCell:(HomePackageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [self.categories objectAtIndex:indexPath.row];
    cell.labelName.text = category.name;
}

- (void)configureQuestCell:(HomeQuestCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Quest *quest = [self.quests objectAtIndex:indexPath.row];
    
    QuestManager *questManager = [[[QuestManager alloc] init] autorelease];
    
    float completionPercentage = [questManager getQuestCompletionPercentage:quest];
    
    cell.labelName.text = [NSString stringWithFormat:@"%f - %@", completionPercentage, quest.desc];
    if (quest.completed.boolValue == YES)
    {
        cell.buttonSkip.hidden = YES;
    }
    else
    {
        [cell.buttonSkip setTitle:[NSString stringWithFormat:@"Skip: %d coins", quest.cost.intValue]
                         forState:UIControlStateNormal];
        cell.buttonSkip.tag = indexPath.row;
    }
}

- (void)doButtonSkipQuest:(id)sender
{
    Quest *quest = [self.quests objectAtIndex:((UIButton*)sender).tag];
    
    if ([[CoinsManager sharedInstance] getCoins] < quest.cost.intValue)
    {
        [self presentViewController:[StoreCoinsViewController sharedInstance]
                           animated:NO
                         completion:^{
                             
                         }];
        return;
    }    
    [[CoinsManager sharedInstance] substractCoins:quest.cost.intValue];

    quest.completed = [NSNumber numberWithBool:YES];
    NSError *error = nil;
    [[CoreDataUtils sharedInstance].managedObjectContext save:&error];
    if (error)
    {
        NSLog(error.debugDescription);
    }
    [self.tableView reloadData];
}

#pragma mark -

#pragma mark StoreCoinsViewControllerDelegate

- (void)storeCoinsViewControllerOnClose
{
    
}

#pragma mark -

@end
