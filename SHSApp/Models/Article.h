//
//  Article.h
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *imageSubtitle;

-(id)initWithNID:(NSString *)ID title:(NSString *)titl author:(NSString *)authr body:(NSString *)bdy date:(NSString *)dte section: (NSString *)sction photoURL:(NSString *)photo imageSubtitle:(NSString *)sub;
@end
