//
//  SHSStaffDetailViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSStaffDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface SHSStaffDetailViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SHSStaffDetailViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scroll.delegate = self;
    self.scroll.scrollEnabled = YES;
    [self.scroll setContentSize:CGSizeMake(320, 540)];
    self.navigationItem.title = [_staffInfo objectForKey:@"Type"];
    _nameLabel.text = [_staffInfo objectForKey:@"Name"];
    [_emailButton setTitle:[NSString stringWithFormat:@"Email: %@",[_staffInfo objectForKey:@"Email"]] forState:UIControlStateNormal];
    [_callButton setTitle:[NSString stringWithFormat:@"Call Extension: %@",[_staffInfo objectForKey:@"Extension"]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)callAction:(id)sender {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[NSString stringWithFormat:@"14088673411"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

- (IBAction)websiteAction:(id)sender {
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[_staffInfo objectForKey:@"Website"]];
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end