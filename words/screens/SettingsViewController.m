//
//  SettingsViewController.m
//  words
//
//  Created by Marius Rott on 9/13/13.
//  Copyright (c) 2013 mrott. All rights reserved.
//

#import "SettingsViewController.h"
#import "SoundUtils.h"

@interface SettingsViewController ()

- (void)updateScreen;

@end

@implementation SettingsViewController

- (id)init
{
    NSString *xib = @"SettingsViewController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        xib = @"SettingsViewController_iPad";
    }
    self = [super initWithNibName:xib bundle:nil];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScreen
{
    NSLog(@"%d - sound ", [SoundUtils sharedInstance].soundOn);
}

- (void)doButtonClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doButtonCredits:(id)sender
{
    
}

- (void)doButtonEmail:(id)sender
{
    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
	// So, we must verify the existence of the above class and provide a workaround for devices running
	// earlier versions of the iPhone OS.
	// We display an email composition interface if MFMailComposeViewController exists and the device
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil) {
        //[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
		else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:@"This device is not configured to send emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.view addSubview:alert];
            [alert show];
            [alert release];
		}
	}
	else	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:@"This device is not configured to send emails." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        [alert release];
	}
}

- (void)doButtonNotifications:(id)sender
{
    
}

- (void)doButtonSounds:(id)sender
{
    [SoundUtils sharedInstance].soundOn = ![SoundUtils sharedInstance].soundOn;
    [self updateScreen];
}


#pragma mark Compose Mail/SMS

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"contact@mgapps.net"];
	
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\nApp Name: %@ \nModel: %@ \nSystem Version: %@ \nLanguage: %@ \nCountry: %@ \nApp Version: %@", appName, model, systemVersion, language, country, appVersion];
    
	[picker setToRecipients:toRecipients];
    [picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker
                       animated:YES
                     completion:^{
                         
                     }];
	[picker release];
}

#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
            UIAlertView* alert;
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:@"There was an error sending your message. Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			break;
		default:
			break;
	}
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
