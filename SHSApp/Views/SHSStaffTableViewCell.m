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
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end