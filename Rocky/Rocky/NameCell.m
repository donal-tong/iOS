//
//  NameCell.m
//  Rocky
//
//  Created by Donal on 13-7-31.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "NameCell.h"

@implementation NameCell
@synthesize tipLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 21)];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:tipLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
