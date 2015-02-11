//
//  SHSMeViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSMeViewController.h"
#import "SVWebViewController.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface SHSMeViewController ()

@end

@implementation SHSMeViewController {
    UIImage *idImage;
}

@synthesize idButton;

// Setup UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scroll.delegate = self;
    self.scroll.scrollEnabled = YES;
    [self.scroll setContentSize:CGSizeMake(320, 550)];
    self.idButton.layer.cornerRadius = 10;
    [[idButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"idImage"];
    idImage = [UIImage imageWithData:imageData];
    [idButton setImage:idImage forState:UIControlStateNormal];
    
    if(idButton.currentBackgroundImage == nil){
        idButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        idButton.titleLabel.textAlignment = NSTextAlignmentCenter;
           [idButton setTitle:@"Take a picture of your ID\nto use it from the app!" forState:UIControlStateNormal];
    }
}

// Display student id picture in full screen
- (IBAction) fullscreen: (id)sender {
    IDMPhoto *photo = [IDMPhoto photoWithImage:idImage];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos: @[photo]];
    [browser shouldAutorotate];
    [self presentViewController: browser animated:NO completion:nil];
}

// Bring up camera app to take picture
- (IBAction)useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:^{
                             UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"IMPORANT!" message:@"Make sure your phone is in LANDSCAPE mode in order for this to work. Make sure the flash button is facing in the opposite direction of the cancel button." delegate:self cancelButtonTitle:@"I WILL ROTATE MY PHONE!" otherButtonTitles:nil];
                               [alert show];
                           }];
        
        _newMedia = YES;
    }
}

#pragma mark UIImagePickerControllerDelegate

// Get the picture selected from the camera roll
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        idImage = info[UIImagePickerControllerOriginalImage];
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(idImage)            forKey:@"idImage"];

        UIImage *rotatedImage = [[UIImage alloc] initWithCGImage:idImage.CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationRight];
        [idButton setImage:idImage forState:UIControlStateNormal];
    }
}

// Dismiss camera view
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Open up web browser to Aeries website
- (IBAction)aeriesButton:(id)sender {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"https://aeries.lgsuhsd.org/aeries.net/Loginparent.aspx"];
    [self.navigationController pushViewController:webViewController animated:YES];
}

// Open up web browser to Naviance website
- (IBAction)navianceAction:(id)sender {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"https://connection.naviance.com/family-connection/auth/login/?hsid=saratogahigh"];

    [self.navigationController pushViewController:webViewController animated:YES];
}

// Open up web browser to Canvas website
- (IBAction)canvasAction:(id)sender {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"https://lgsuhsd.instructure.com/login"];
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
