//
//  SHSStaffTableViewCell.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSStaffTableViewCell.h"

@implementation SHSStaffTableViewCell
@synthesize nameLabel = _nameLabel;
@synthesize typeLabel = _typeLabel;

//Setup custom table view cell with name and type
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end