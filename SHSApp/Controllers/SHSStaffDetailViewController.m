//
//  SHSStaffDetailViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSStaffDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface SHSStaffDetailViewController () <MFMailComposeViewControllerDelegate, UIScrollViewDelegate>

@end

@implementation SHSStaffDetailViewController

// Setup view/labels with staff info and button info
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scroll.delegate = self;
    self.scroll.scrollEnabled = YES;
    [self.scroll setContentSize:CGSizeMake(320, 540)];
    self.navigationItem.title = [_staffInfo objectForKey:@"Type"];
    _nameLabel.text = [_staffInfo objectForKey:@"Name"];
    [_emailButton setTitle:[NSString stringWithFormat:@"Email: %@",[_staffInfo objectForKey:@"Email"]] forState:UIControlStateNormal];
    [_callButton setTitle:[NSString stringWithFormat:@"Call Extension: %@",[_staffInfo objectForKey:@"Extension"]] forState:UIControlStateNormal];
}

// When email button tapped, show a email compose view controller with preset values
- (IBAction)emailAction:(id)sender {
    NSString *emailTitle = @"Hi!";
    NSString *messageBody = [NSString stringWithFormat:@"Hi %@,", [_staffInfo objectForKey:@"Name"]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:@[[_staffInfo objectForKey:@"Email"]]];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

// Mail view controller delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Call phone number when button tapped
- (IBAction)callAction:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"14088673411"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

// Open webViewController with website
- (IBAction)websiteAction:(id)sender {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[_staffInfo objectForKey:@"Website"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end