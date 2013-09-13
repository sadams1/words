//
//  PauseViewController.h
//  words
//
//  Created by Marius Rott on 9/5/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface PauseViewController : UIViewController

- (id)initWithDelegate:(id<GameViewControllerDelegate>)delegate;

- (IBAction)doButtonBack:(id)sender;
- (IBAction)doBUttonResume:(id)sender;
- (IBAction)doButtonRestart:(id)sender;
- (IBAction)doButtonMoreGames:(id)sender;
- (IBAction)doButtonPackage:(id)sender;
- (IBAction)doButtonSettings:(id)sender;

@end
