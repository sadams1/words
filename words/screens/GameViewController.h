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

- (IBAction)doButtonHint:(id)sender;
- (IBAction)doButtonRemoveChars:(id)sender;
- (IBAction)doButtonResolveGame:(id)sender;


@end
