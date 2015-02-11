//
//  SHSNetworkClient.h
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface SHSNetworkClient : NSObject

+ (SHSNetworkClient*)sharedInstance;

- (void)getNidsForSection:(NSString *)section withCount:(NSString *)count completionBlock:(void (^)(NSArray *nids, NSError *error))completionBlock;

- (void)getArticleForNid:(NSString *)nid completionBlock:(void (^)(Article *article, NSError *error))completionBlock;

@end