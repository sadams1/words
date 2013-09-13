//
//  SettingsViewController.h
//  words
//
//  Created by Marius Rott on 9/13/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate>

- (IBAction)doButtonClose:(id)sender;
- (IBAction)doButtonNotifications:(id)sender;
- (IBAction)doButtonSounds:(id)sender;
- (IBAction)doButtonEmail:(id)sender;
- (IBAction)doButtonCredits:(id)sender;


@end
