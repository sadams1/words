//
//  FinishViewController.h
//  words
//
//  Created by Marius Rott on 9/12/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@class GameSession;

@interface FinishViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelPoints;

- (id)initWithDelegate:(id<GameViewControllerDelegate>)delegate gameSession:(GameSession*)gameSession;

- (IBAction)doButtonBack:(id)sender;
- (IBAction)doButtonRestart:(id)sender;
- (IBAction)doButtonMoreGames:(id)sender;
- (IBAction)doButtonPackage:(id)sender;
- (IBAction)doButtonSettings:(id)sender;

@end
