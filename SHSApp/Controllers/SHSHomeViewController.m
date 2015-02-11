//
//  SHSHomeViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSHomeViewController.h"
#import "EScrollerView.h"
#import <MessageUI/MessageUI.h>
#import "SVWebViewController.h"
#import <MapKit/MapKit.h>


@interface SHSHomeViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SHSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    //array of images in the scroller view
    NSArray *images = @[@"1.jpg", @"2.jpg", @"3.jpg"];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) imageArray: images];
    imageScroller.delegate = self;
    [self.view addSubview:imageScroller];
    
    self.calanderContainer.frame = CGRectMake(self.calanderContainer.frame.origin.x, imageScroller.frame.origin.y + imageScroller.frame.size.height, self.calanderContainer.frame.size.width, self.calanderContainer.frame.size.width);
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.tintColor = [UIColor whiteColor];
    [infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.center = CGPointMake(self.view.frame.size.width - 25, 25);
    [self.view addSubview:infoButton];

}

// Adjusts the insets after laying out subviews
- (void)viewDidLayoutSubviews{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// Sets preferences before view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

// Sets preferences before view dissapears
- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

// Presets available info options
- (void)infoButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"More info"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Call School",@"Email School", @"Open Address in Maps", @"Go to School Website", nil];
    [actionSheet showInView:self.view];

}

// Runs respective code for each info option
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //call school
        NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://14088673411"]];
        [[UIApplication sharedApplication] openURL:url];
    } else if(buttonIndex == 1){
        //open email school controller
        NSString *emailTitle = @"Hi!";
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setToRecipients:@[@"shswebmaster@lgsuhsd.org"]];
        
        [self presentViewController:mc animated:YES completion:NULL];
        
    } else if(buttonIndex == 2) {
    //open address in maps
        // Check for iOS 6
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate =
            CLLocationCoordinate2DMake(37.266825, -122.029253);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:@"Saratoga High"];
            // Pass the map item to the Maps appfggvt
            [mapItem openInMapsWithLaunchOptions:nil];
        }
    } else if(buttonIndex == 3) {
        //go to school website
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://www.saratogahigh.org/"];
        [self.navigationController pushViewController:webViewController animated:YES];
  
    }
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


@end
