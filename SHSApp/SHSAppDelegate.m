//
//  SHSAppDelegate.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSAppDelegate.h"
#import <Parse/Parse.h>

@implementation SHSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure app UI settings/colors
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:207/255.0 green:0/255.0 blue:15/255.0 alpha:1.0]];
    } else {
        [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:207/255.0 green:0/255.0 blue:15/255.0 alpha:1.0]];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont boldSystemFontOfSize:18.0], NSFontAttributeName, nil]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:220.0/255.0 green:0 blue:0 alpha:1]];
    
    //Setup backend app IDs and register device for push notifications
    [Parse setApplicationId:@"mBeDrmdeuRATh3rO7CqbTZMYKcXkuSrCKPEkPFDG"
                  clientKey:@"VoIiZFddiKtfH9i7iz5jyQMsT9H45KgnDUOtEDo2"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound |
           UIUserNotificationTypeAlert |
           UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge |
          UIUserNotificationTypeSound |
          UIUserNotificationTypeAlert)];
    }

    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

// New in iOS 8
-(void) application:(UIApplication*) application didRegisterUserNotificationSettings: (UIUserNotificationSettings*) notificationSettings {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
