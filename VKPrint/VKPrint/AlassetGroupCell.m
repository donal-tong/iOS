//
//  AlassetGroupCell.m
//  wowo
//
//  Created by Donal on 13-7-23.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "AlassetGroupCell.h"

@implementation AlassetGroupCell
@synthesize alassetGroupCover, alassetGroupDetail, seperatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        alassetGroupCover = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 50, 50)];
        [alassetGroupCover setContentMode:UIViewContentModeScaleAspectFill];
        [alassetGroupCover setClipsToBounds:YES];
        [self.contentView addSubview:alassetGroupCover];
        
        alassetGroupDetail = [[UILabel alloc] initWithFrame:CGRectMake(68, 22, 200, 20)];
        [alassetGroupDetail setFont:[UIFont systemFontOfSize:15.0]];
        [alassetGroupDetail setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:alassetGroupDetail];
        
        seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, 320, 1)];
        [seperatorView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
        [self.contentView addSubview:seperatorView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [seperatorView setFrame:CGRectMake(0, 63, frame.size.width, 1)];
}

@end
