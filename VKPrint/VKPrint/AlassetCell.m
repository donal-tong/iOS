//
//  AlassetCell.m
//  wowo
//
//  Created by Donal on 13-7-22.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "AlassetCell.h"

@implementation AlassetCell
@synthesize alasset1, alasset2, alasset3, alasset4, alasset5, alasset6, alasset7, alasset8, alasset9, alasset10;
@synthesize object1, object2, object3, object4, object5, object6, object7, object8, object9, object10;
@synthesize delegate;

- (id)initWithiPadStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 155, 150)];
        [view1 setBackgroundColor:[UIColor clearColor]];
        alasset1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 4, 142, 142)];
        [alasset1 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset1 setClipsToBounds:YES];
        [alasset1 setUserInteractionEnabled:YES];
        [alasset1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset1Tap)]];
        [view1 addSubview:alasset1];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(155, 0, 150, 150)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        alasset2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 142, 142)];
        [alasset2 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset2 setClipsToBounds:YES];
        [alasset2 setUserInteractionEnabled:YES];
        [alasset2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset2Tap)]];
        [view2 addSubview:alasset2];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(305, 0, 150, 150)];
        [view3 setBackgroundColor:[UIColor clearColor]];
        alasset3 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 142, 142)];
        [alasset3 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset3 setClipsToBounds:YES];
        [alasset3 setUserInteractionEnabled:YES];
        [alasset3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset3Tap)]];
        [view3 addSubview:alasset3];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view3];
        
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(455, 0, 150, 150)];
        [view4 setBackgroundColor:[UIColor clearColor]];
        alasset4 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 142, 142)];
        [alasset4 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset4 setClipsToBounds:YES];
        [alasset4 setUserInteractionEnabled:YES];
        [alasset4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset4Tap)]];
        [view4 addSubview:alasset4];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view4];
        
        UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(605, 0, 163, 150)];
        [view5 setBackgroundColor:[UIColor clearColor]];
        alasset5 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 142, 142)];
        [alasset5 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset5 setClipsToBounds:YES];
        [alasset5 setUserInteractionEnabled:YES];
        [alasset5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset5Tap)]];
        [view5 addSubview:alasset5];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view5];
        
    }
    return self;
}

- (id)initWithiPadLandscapeStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 103, 102)];
        [view1 setBackgroundColor:[UIColor clearColor]];
        alasset1 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset1 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset1 setClipsToBounds:YES];
        [alasset1 setUserInteractionEnabled:YES];
        [alasset1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset1Tap)]];
        [view1 addSubview:alasset1];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(103, 0, 102, 102)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        alasset2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset2 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset2 setClipsToBounds:YES];
        [alasset2 setUserInteractionEnabled:YES];
        [alasset2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset2Tap)]];
        [view2 addSubview:alasset2];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(205, 0, 102, 102)];
        [view3 setBackgroundColor:[UIColor clearColor]];
        alasset3 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset3 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset3 setClipsToBounds:YES];
        [alasset3 setUserInteractionEnabled:YES];
        [alasset3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset3Tap)]];
        [view3 addSubview:alasset3];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view3];
        
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(307, 0, 102, 102)];
        [view4 setBackgroundColor:[UIColor clearColor]];
        alasset4 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset4 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset4 setClipsToBounds:YES];
        [alasset4 setUserInteractionEnabled:YES];
        [alasset4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset4Tap)]];
        [view4 addSubview:alasset4];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view4];
        
        UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(409, 0, 102, 102)];
        [view5 setBackgroundColor:[UIColor clearColor]];
        alasset5 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset5 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset5 setClipsToBounds:YES];
        [alasset5 setUserInteractionEnabled:YES];
        [alasset5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset5Tap)]];
        [view5 addSubview:alasset5];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view5];
        
        UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(511, 0, 102, 102)];
        [view6 setBackgroundColor:[UIColor clearColor]];
        alasset6 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset6 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset6 setClipsToBounds:YES];
        [alasset6 setUserInteractionEnabled:YES];
        [alasset6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset6Tap)]];
        [view6 addSubview:alasset6];
        [view6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view6 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view6];
        
        UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(613, 0, 102, 102)];
        [view7 setBackgroundColor:[UIColor clearColor]];
        alasset7 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset7 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset7 setClipsToBounds:YES];
        [alasset7 setUserInteractionEnabled:YES];
        [alasset7 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset7Tap)]];
        [view7 addSubview:alasset7];
        [view7 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view7 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view7];
        
        UIView *view8 = [[UIView alloc] initWithFrame:CGRectMake(715, 0, 102, 102)];
        [view8 setBackgroundColor:[UIColor clearColor]];
        alasset8 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset8 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset8 setClipsToBounds:YES];
        [alasset8 setUserInteractionEnabled:YES];
        [alasset8 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset8Tap)]];
        [view8 addSubview:alasset8];
        [view8 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view8 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view8];
        
        UIView *view9 = [[UIView alloc] initWithFrame:CGRectMake(817, 0, 102, 102)];
        [view9 setBackgroundColor:[UIColor clearColor]];
        alasset9 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset9 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset9 setClipsToBounds:YES];
        [alasset9 setUserInteractionEnabled:YES];
        [alasset9 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset9Tap)]];
        [view9 addSubview:alasset9];
        [view9 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view9 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view9];
        
        UIView *view10 = [[UIView alloc] initWithFrame:CGRectMake(919, 0, 105, 102)];
        [view10 setBackgroundColor:[UIColor clearColor]];
        alasset10 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset10 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset10 setClipsToBounds:YES];
        [alasset10 setUserInteractionEnabled:YES];
        [alasset10 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset10Tap)]];
        [view10 addSubview:alasset10];
        [view10 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view10 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view10];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 107, 102)];
        [view1 setBackgroundColor:[UIColor clearColor]];
        alasset1 = [[UIImageView alloc] initWithFrame:CGRectMake(9, 2, 98, 98)];
        [alasset1 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset1 setClipsToBounds:YES];
        [alasset1 setUserInteractionEnabled:YES];
        [alasset1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset1Tap)]];
        [view1 addSubview:alasset1];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(107, 0, 102, 102)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        alasset2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset2 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset2 setClipsToBounds:YES];
        [alasset2 setUserInteractionEnabled:YES];
        [alasset2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset2Tap)]];
        [view2 addSubview:alasset2];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(209, 0, 111, 102)];
        [view3 setBackgroundColor:[UIColor clearColor]];
        alasset3 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 98, 98)];
        [alasset3 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset3 setClipsToBounds:YES];
        [alasset3 setUserInteractionEnabled:YES];
        [alasset3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset3Tap)]];
        [view3 addSubview:alasset3];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view3];
        
    }
    return self;
}

- (id)initWithiPhoneLandscapeStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [view1 setBackgroundColor:[UIColor clearColor]];
        alasset1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 74, 74)];
        [alasset1 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset1 setClipsToBounds:YES];
        [alasset1 setUserInteractionEnabled:YES];
        [alasset1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset1Tap)]];
        [view1 addSubview:alasset1];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        alasset2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 3, 74, 74)];
        [alasset2 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset2 setClipsToBounds:YES];
        [alasset2 setUserInteractionEnabled:YES];
        [alasset2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset2Tap)]];
        [view2 addSubview:alasset2];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 80, 80)];
        [view3 setBackgroundColor:[UIColor clearColor]];
        alasset3 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 74, 74)];
        [alasset3 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset3 setClipsToBounds:YES];
        [alasset3 setUserInteractionEnabled:YES];
        [alasset3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset3Tap)]];
        [view3 addSubview:alasset3];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view3];
        
        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(240, 0, 80, 80)];
        [view4 setBackgroundColor:[UIColor clearColor]];
        alasset4 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 3, 74, 74)];
        [alasset4 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset4 setClipsToBounds:YES];
        [alasset4 setUserInteractionEnabled:YES];
        [alasset4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset4Tap)]];
        [view4 addSubview:alasset4];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view4 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view4];
        
        UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 80, 80)];
        [view5 setBackgroundColor:[UIColor clearColor]];
        alasset5 = [[UIImageView alloc] initWithFrame:CGRectMake(1, 3, 74, 74)];
        [alasset5 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset5 setClipsToBounds:YES];
        [alasset5 setUserInteractionEnabled:YES];
        [alasset5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset5Tap)]];
        [view5 addSubview:alasset5];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view5 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view5];
        
        UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(400, 0, 80, 80)];
        [view6 setBackgroundColor:[UIColor clearColor]];
        alasset6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 74, 74)];
        [alasset6 setContentMode:UIViewContentModeScaleAspectFill];
        [alasset6 setClipsToBounds:YES];
        [alasset6 setUserInteractionEnabled:YES];
        [alasset6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alasset6Tap)]];
        [view6 addSubview:alasset6];
        [view6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view6 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:view6];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAlasset1Mark
{
    [alasset1 setAlpha:0.5];
}

-(void)removeAlasset1Mark
{
    [alasset1 setAlpha:1];
}

-(void)alasset1Tap
{
    [self setAlasset1Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object1];
    }
}

-(void)setAlasset2Mark
{
    [alasset2 setAlpha:0.5];
}

-(void)removeAlasset2Mark
{
    [alasset2 setAlpha:1];
}

-(void)alasset2Tap
{
    [self setAlasset2Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object2];
    }
}

-(void)setAlasset3Mark
{
    [alasset3 setAlpha:0.5];
}

-(void)removeAlasset3Mark
{
    [alasset3 setAlpha:1];
}

-(void)alasset3Tap
{
    [self setAlasset3Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object3];
    }
}

-(void)setAlasset4Mark
{
    [alasset4 setAlpha:0.5];
}

-(void)removeAlasset4Mark
{
    [alasset4 setAlpha:1];
}

-(void)alasset4Tap
{
    [self setAlasset4Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object4];
    }
}

-(void)setAlasset5Mark
{
    [alasset5 setAlpha:0.5];
}

-(void)removeAlasset5Mark
{
    [alasset5 setAlpha:1];
}

-(void)alasset5Tap
{
    [self setAlasset5Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object5];
    }
}

-(void)setAlasset6Mark
{
    [alasset6 setAlpha:0.5];
}

-(void)removeAlasset6Mark
{
    [alasset6 setAlpha:1];
}

-(void)alasset6Tap
{
    [self setAlasset6Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object6];
    }
}

-(void)setAlasset7Mark
{
    [alasset7 setAlpha:0.5];
}

-(void)removeAlasset7Mark
{
    [alasset7 setAlpha:1];
}

-(void)alasset7Tap
{
    [self setAlasset7Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object7];
    }
}

-(void)setAlasset8Mark
{
    [alasset8 setAlpha:0.5];
}

-(void)removeAlasset8Mark
{
    [alasset8 setAlpha:1];
}

-(void)alasset8Tap
{
    [self setAlasset8Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object8];
    }
}

-(void)setAlasset9Mark
{
    [alasset9 setAlpha:0.5];
}

-(void)removeAlasset9Mark
{
    [alasset9 setAlpha:1];
}

-(void)alasset9Tap
{
    [self setAlasset9Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object9];
    }
}

-(void)setAlasset10Mark
{
    [alasset10 setAlpha:0.5];
}

-(void)removeAlasset10Mark
{
    [alasset10 setAlpha:1];
}

-(void)alasset10Tap
{
    [self setAlasset10Mark];
    if ([delegate respondsToSelector:@selector(AlassetCell:gotObjectIndex:)]) {
        [delegate AlassetCell:self gotObjectIndex:object10];
    }
}

@end
