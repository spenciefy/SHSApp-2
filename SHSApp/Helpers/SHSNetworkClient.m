//
//  SHSNetworkClient.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSNetworkClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "SHSHTTPRequestSerializer.h"

@implementation SHSNetworkClient {
    NSMutableData *receivedData;
    NSURLConnection *nidConnection;
    NSURLConnection *articleConnection;
}

+ (SHSNetworkClient *)sharedInstance {
    static SHSNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SHSNetworkClient alloc] init];
    });
    return _sharedInstance;
}

- (void)getNidsForSection:(NSString *)section withCount:(NSString *)count completionBlock:(void (^)(NSArray *nids, NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.saratogafalcon.org/ws"];
    NSString *parameterData = [NSString stringWithFormat:@"request_type=get_story_nids&story_type=%@&story_number=%@", section, count];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameterData dataUsingEncoding:NSUTF8StringEncoding]];

     //NSMutableData* result = [[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] mutableCopy];
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if(!error){
            NSString *nidArrayString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            nidArrayString = [nidArrayString stringByReplacingOccurrencesOfString:@"["
                                                                       withString:@""];
            nidArrayString = [nidArrayString stringByReplacingOccurrencesOfString:@"]"
                                                                       withString:@""];
            nidArrayString = [nidArrayString stringByReplacingOccurrencesOfString:@"\""
                                                                       withString:@""];
            NSArray *nids = [nidArrayString componentsSeparatedByString:@","];
            
            completionBlock(nids,nil);
        } else {
            completionBlock(nil, error);

        }
        

    }];

}

- (void)getArticleForNid:(NSString *)nid completionBlock:(void (^)(Article *article, NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://www.saratogafalcon.org/ws"];
    NSString *parameterData = [NSString stringWithFormat:@"request_type=get_story_details&story_nid=%@", nid];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[parameterData dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:theRequest queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
    NSDictionary *articleDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if(!error){
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
        [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
        NSDate *dateFromString = [timeFormatter dateFromString:[articleDict objectForKey:@"date"]];
        
        NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
        [stringFormatter setDateFormat:@"M/dd/yy"];
        [stringFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [stringFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
        
        NSString *newDate = [stringFormatter stringFromDate:dateFromString];
       const char *titleChar = [[articleDict objectForKey:@"title"] UTF8String];
        NSData *data = [NSData dataWithBytes:titleChar length:strlen(titleChar)];
        NSString *title = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        Article *article = [[Article alloc]initWithNID:[articleDict objectForKey:@"nid"] title:title author:[articleDict objectForKey:@"author"] body:[articleDict objectForKey:@"story"] date:newDate section:[articleDict objectForKey:@"storyType"] photoURL:[articleDict objectForKey:@"imageURL"] imageSubtitle:[articleDict objectForKey:@"imageSubtitle"]];
        
        completionBlock(article,nil);
        
    } else {
        completionBlock(nil, error);
    }
    }];



}



-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bummer." message:@"Make sure you have internet or you won't be able to read beautiful journalism. -Spencer" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alertView show];
    
    
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    if (connection == self.nidsConnection) {
//    }

}

@end