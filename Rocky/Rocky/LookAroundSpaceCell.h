//
//  LookAroundSpaceCell.h
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookAroundSpaceCell : UITableViewCell
{
    UIView *cellContentView;
    
    BOOL useDarkBackground;
    UIImageView *icon;
    NSString *name;
    NSString *memberCount;
    NSString *activeCount;
    
}

@property BOOL useDarkBackground;
@property(retain) UIImageView *icon;
@property (strong, nonatomic) UIImageView *iconCover;
@property(retain) NSString *name;
@property(retain) NSString *memberCount;
@property(retain) NSString *activeCount;
@property(retain) UIImageView *seperateImage;

@property (strong, nonatomic) NSDictionary *space;


@end
