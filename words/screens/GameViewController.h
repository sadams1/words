//
//  GameViewController.h
//  words
//
//  Created by Marius Rott on 9/4/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordTable.h"

@interface GameViewController : UIViewController <WordTableDelegate>

@property (nonatomic, retain) IBOutlet UIButton *buttonStore;
@property (nonatomic, retain) IBOutlet UIButton *buttonHint;
@property (nonatomic, retain) IBOutlet UIButton *buttonRemoveChars;
@property (nonatomic, retain) IBOutlet UIButton *buttonResolveGame;
@property (nonatomic, retain) IBOutlet UIButton *buttonPause;


- (IBAction)doButtonStore:(id)sender;
- (IBAction)doButtonHint:(id)sender;
- (IBAction)doButtonRemoveChars:(id)sender;
- (IBAction)doButtonResolveGame:(id)sender;
- (IBAction)doButtonPause:(id)sender;


@end
