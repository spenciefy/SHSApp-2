//
//  SHSHTTPRequestSerializer.h
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface SHSHTTPRequestSerializer : AFHTTPRequestSerializer
- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                     withBody:(NSString *)body
                                        error:(NSError * __autoreleasing *)error;
@end
