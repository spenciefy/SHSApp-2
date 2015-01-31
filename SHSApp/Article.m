//
//  Article.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "Article.h"

@implementation Article
@synthesize nid;
@synthesize title;
@synthesize author;
@synthesize body;
@synthesize date;
@synthesize section;
@synthesize photoURL;


-(id)initWithNID:(NSString *)ID title:(NSString *)titl author:(NSString *)authr body:(NSString *)bdy date:(NSString *)dte section: (NSString *)sction photoURL:(NSString *)photo imageSubtitle:(NSString *)sub {
    self = [super init];
    if(self)
    {
        self.nid = ID;
        self.title = titl;
        self.author = authr;
        self.body = bdy;
        self.date = dte;
        self.section = sction;
        self.photoURL = photo;
        self.imageSubtitle = sub;
    }
    return self;
}

@end
