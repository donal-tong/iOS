//
//  AlassetCell.h
//  wowo
//
//  Created by Donal on 13-7-22.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlassetCell;

@protocol AlassetCellDelegate <NSObject>

-(void)AlassetCell:(AlassetCell *)sender gotObjectIndex:(int)object;

@end

@interface AlassetCell : UITableViewCell

@property(retain) UIImageView *alasset1;
@property(retain) UIImageView *alasset2;
@property(retain) UIImageView *alasset3;
@property(retain) UIImageView *alasset4;
@property(retain) UIImageView *alasset5;
@property(retain) UIImageView *alasset6;
@property(retain) UIImageView *alasset7;
@property(retain) UIImageView *alasset8;
@property(retain) UIImageView *alasset9;
@property(retain) UIImageView *alasset10;

@property int object1;
@property int object2;
@property int object3;
@property int object4;
@property int object5;
@property int object6;
@property int object7;
@property int object8;
@property int object9;
@property int object10;

@property (assign, nonatomic) id<AlassetCellDelegate> delegate;

-(void)setAlasset1Mark;
-(void)removeAlasset1Mark;

-(void)setAlasset2Mark;
-(void)removeAlasset2Mark;

-(void)setAlasset3Mark;
-(void)removeAlasset3Mark;

-(void)setAlasset4Mark;
-(void)removeAlasset4Mark;

-(void)setAlasset5Mark;
-(void)removeAlasset5Mark;

-(void)setAlasset6Mark;
-(void)removeAlasset6Mark;

-(void)setAlasset7Mark;
-(void)removeAlasset7Mark;

-(void)setAlasset8Mark;
-(void)removeAlasset8Mark;

-(void)setAlasset9Mark;
-(void)removeAlasset9Mark;

-(void)setAlasset10Mark;
-(void)removeAlasset10Mark;

- (id)initWithiPadStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithiPadLandscapeStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithiPhoneLandscapeStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
