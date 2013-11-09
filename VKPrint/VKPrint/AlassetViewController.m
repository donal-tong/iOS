//
//  AlassetViewController.m
//  wowo
//
//  Created by Donal on 13-7-22.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "AlassetViewController.h"
#import "AlassetCell.h"

@interface AlassetViewController () <UITableViewDataSource, UITableViewDelegate, AlassetCellDelegate>
{
    UITableView *alassetTableView;
    NSMutableArray *alassetArray;
    
    NSMutableArray *alassetSelectedArray;
    
    bool isPortrait;
}
@end

@implementation AlassetViewController

-(void)setiPhoneUIinPortrait
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, 1)];
    [seperatorView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    [seperatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:seperatorView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackAndicatorDefault.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    alassetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44)];
    alassetTableView.backgroundColor = [UIColor clearColor];
    alassetTableView.delegate = self;
    alassetTableView.dataSource = self;
    [alassetTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [alassetTableView setAutoresizesSubviews:YES];
    [self.view addSubview:alassetTableView];
}

-(void)setUIinPortrait
{
    if (self.view == alassetTableView.superview) {
        [alassetTableView removeFromSuperview];
    }
    alassetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44)];
    alassetTableView.backgroundColor = [UIColor clearColor];
    alassetTableView.delegate = self;
    alassetTableView.dataSource = self;
    [alassetTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [alassetTableView setAutoresizesSubviews:YES];
    [self.view addSubview:alassetTableView];
}

-(void)setUIinLandscape
{
    if (self.view == alassetTableView.superview) {
        [alassetTableView removeFromSuperview];
    }
    alassetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.height, screenframe.size.width-StatusBarHeight-44)];
    alassetTableView.backgroundColor = [UIColor clearColor];
    alassetTableView.delegate = self;
    alassetTableView.dataSource = self;
    [alassetTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [alassetTableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [alassetTableView setAutoresizesSubviews:YES];
    [self.view addSubview:alassetTableView];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
//        //翻转为竖屏时
//        [self setiPhoneUIinPortrait];
//        isPortrait = YES;
//    }else if (toInterfaceOrientation==UIDeviceOrientationLandscapeLeft || toInterfaceOrientation ==UIDeviceOrientationLandscapeRight) {
//        //翻转为横屏时
//        [self setiPhoneUIinLandscape];
//        isPortrait = NO;
//    }
//}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self setUIinPortrait];
        isPortrait = YES;
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self setUIinLandscape];
        isPortrait = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPortrait = YES;
    [self setiPhoneUIinPortrait];
    
    
    alassetArray = [NSMutableArray arrayWithCapacity:0];
    alassetSelectedArray = [NSMutableArray arrayWithCapacity:0];
    
    [self performSelector:@selector(preparePhotos) withObject:nil afterDelay:0];
}

-(void)preparePhotos
{
    [self.currentAlassetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [self.currentAlassetGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(nil == result)
         {
             return;
         }
         [alassetArray addObject:result];
     }];
    
	
	[alassetTableView reloadData];
}


#pragma mark tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPad) {
        if (isPortrait) {
            return 150;
        }
        else
            return 102;
    }
    else {
        if (isPortrait) {
            return 102;
        }
        else
            return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isPad) {
        if (isPortrait) {
            return ceil([alassetArray count]/5.0);
        }
        else
            return ceil([alassetArray count]/10.0);
    }
    else {
        if (isPortrait) {
            return ceil([alassetArray count]/3.0);
        }
        else
            return ceil([alassetArray count]/6.0);
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"AlassetCell";
    AlassetCell *cell = (AlassetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (isPad) {
        if (isPortrait) {
            if (nil == cell) {
                cell  = [[AlassetCell alloc] initWithiPadStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAutoresizesSubviews:YES];
            if (indexPath.row*5 < alassetArray.count) {
                ALAsset *alasset0 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*5)];
                [cell.alasset1 setImage:[UIImage imageWithCGImage:[alasset0 thumbnail]]];
                cell.object1 = indexPath.row*5;
                [cell removeAlasset1Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*5];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset1Mark];
                }
            }
            else {
                [cell.alasset1 setImage:nil];
                cell.object1 = -1;
            }
            
            if (indexPath.row*5+1 < alassetArray.count) {
                ALAsset *alasset1 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*5+1)];
                [cell.alasset2 setImage:[UIImage imageWithCGImage:[alasset1 thumbnail]]];
                cell.object2 = indexPath.row*3+1;
                [cell removeAlasset2Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*5+1];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset2Mark];
                }
            }
            else {
                [cell.alasset2 setImage:nil];
                cell.object2 = -1;
            }
            
            if (indexPath.row*5+2 < alassetArray.count) {
                ALAsset *alasset2 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*5+2)];
                [cell.alasset3 setImage:[UIImage imageWithCGImage:[alasset2 thumbnail]]];
                cell.object3 = indexPath.row*5+2;
                [cell removeAlasset3Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*5+2];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset3Mark];
                }
            }
            else {
                [cell.alasset3 setImage:nil];
                cell.object3 = -1;
            }
            
            if (indexPath.row*5+3 < alassetArray.count) {
                ALAsset *alasset3 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*5+3)];
                [cell.alasset4 setImage:[UIImage imageWithCGImage:[alasset3 thumbnail]]];
                cell.object4 = indexPath.row*5+3;
                [cell removeAlasset4Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*5+3];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset4Mark];
                }
            }
            else {
                [cell.alasset4 setImage:nil];
                cell.object4 = -1;
            }
            
            if (indexPath.row*5+4 < alassetArray.count) {
                ALAsset *alasset4 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*5+4)];
                [cell.alasset5 setImage:[UIImage imageWithCGImage:[alasset4 thumbnail]]];
                cell.object5 = indexPath.row*5+4;
                [cell removeAlasset5Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*5+4];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset5Mark];
                }
            }
            else {
                [cell.alasset5 setImage:nil];
                cell.object5 = -1;
            }
        }
        else {
            if (nil == cell) {
                cell  = [[AlassetCell alloc] initWithiPadLandscapeStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAutoresizesSubviews:YES];
            if (indexPath.row*10 < alassetArray.count) {
                ALAsset *alasset0 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10)];
                [cell.alasset1 setImage:[UIImage imageWithCGImage:[alasset0 thumbnail]]];
                cell.object1 = indexPath.row*10;
                [cell removeAlasset1Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset1Mark];
                }
            }
            else {
                [cell.alasset1 setImage:nil];
                cell.object1 = -1;
            }
            
            if (indexPath.row*10+1 < alassetArray.count) {
                ALAsset *alasset1 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+1)];
                [cell.alasset2 setImage:[UIImage imageWithCGImage:[alasset1 thumbnail]]];
                cell.object2 = indexPath.row*10+1;
                [cell removeAlasset2Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+1];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset2Mark];
                }
            }
            else {
                [cell.alasset2 setImage:nil];
                cell.object2 = -1;
            }
            
            if (indexPath.row*10+2 < alassetArray.count) {
                ALAsset *alasset2 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+2)];
                [cell.alasset3 setImage:[UIImage imageWithCGImage:[alasset2 thumbnail]]];
                cell.object3 = indexPath.row*10+2;
                [cell removeAlasset3Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+2];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset3Mark];
                }
            }
            else {
                [cell.alasset3 setImage:nil];
                cell.object3 = -1;
            }
            
            if (indexPath.row*10+3 < alassetArray.count) {
                ALAsset *alasset3 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+3)];
                [cell.alasset4 setImage:[UIImage imageWithCGImage:[alasset3 thumbnail]]];
                cell.object4 = indexPath.row*10+3;
                [cell removeAlasset4Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+3];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset4Mark];
                }
            }
            else {
                [cell.alasset4 setImage:nil];
                cell.object4 = -1;
            }
            
            if (indexPath.row*10+4 < alassetArray.count) {
                ALAsset *alasset4 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+4)];
                [cell.alasset5 setImage:[UIImage imageWithCGImage:[alasset4 thumbnail]]];
                cell.object5 = indexPath.row*10+4;
                [cell removeAlasset5Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+4];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset5Mark];
                }
            }
            else {
                [cell.alasset5 setImage:nil];
                cell.object5 = -1;
            }
            
            if (indexPath.row*10+5 < alassetArray.count) {
                ALAsset *alasset0 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+5)];
                [cell.alasset6 setImage:[UIImage imageWithCGImage:[alasset0 thumbnail]]];
                cell.object6 = indexPath.row*10+5;
                [cell removeAlasset6Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+5];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset6Mark];
                }
            }
            else {
                [cell.alasset6 setImage:nil];
                cell.object6 = -1;
            }
            
            if (indexPath.row*10+6 < alassetArray.count) {
                ALAsset *alasset1 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+6)];
                [cell.alasset7 setImage:[UIImage imageWithCGImage:[alasset1 thumbnail]]];
                cell.object7 = indexPath.row*10+6;
                [cell removeAlasset7Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+6];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset7Mark];
                }
            }
            else {
                [cell.alasset7 setImage:nil];
                cell.object7 = -1;
            }
            
            if (indexPath.row*10+7 < alassetArray.count) {
                ALAsset *alasset2 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+7)];
                [cell.alasset8 setImage:[UIImage imageWithCGImage:[alasset2 thumbnail]]];
                cell.object8 = indexPath.row*10+7;
                [cell removeAlasset8Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+7];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset8Mark];
                }
            }
            else {
                [cell.alasset8 setImage:nil];
                cell.object8 = -1;
            }
            
            if (indexPath.row*10+8 < alassetArray.count) {
                ALAsset *alasset3 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+8)];
                [cell.alasset9 setImage:[UIImage imageWithCGImage:[alasset3 thumbnail]]];
                cell.object9 = indexPath.row*10+8;
                [cell removeAlasset9Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+8];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset9Mark];
                }
            }
            else {
                [cell.alasset9 setImage:nil];
                cell.object9 = -1;
            }
            
            if (indexPath.row*10+9 < alassetArray.count) {
                ALAsset *alasset4 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*10+9)];
                [cell.alasset10 setImage:[UIImage imageWithCGImage:[alasset4 thumbnail]]];
                cell.object10 = indexPath.row*10+9;
                [cell removeAlasset10Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*10+9];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset10Mark];
                }
            }
            else {
                [cell.alasset10 setImage:nil];
                cell.object10 = -1;
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        if (isPortrait) {
            if (nil == cell) {
                cell  = [[AlassetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAutoresizesSubviews:YES];
            if (indexPath.row*3 < alassetArray.count) {
                ALAsset *alasset0 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*3)];
                [cell.alasset1 setImage:[UIImage imageWithCGImage:[alasset0 thumbnail]]];
                cell.object1 = indexPath.row*3;
                [cell removeAlasset1Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*3];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset1Mark];
                }
            }
            else {
                [cell.alasset1 setImage:nil];
                cell.object1 = -1;
            }
            
            if (indexPath.row*3+1 < alassetArray.count) {
                ALAsset *alasset1 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*3+1)];
                [cell.alasset2 setImage:[UIImage imageWithCGImage:[alasset1 thumbnail]]];
                cell.object2 = indexPath.row*3+1;
                [cell removeAlasset2Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*3+1];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset2Mark];
                }
            }
            else {
                [cell.alasset2 setImage:nil];
                cell.object2 = -1;
            }
            
            if (indexPath.row*3+2 < alassetArray.count) {
                ALAsset *alasset2 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*3+2)];
                [cell.alasset3 setImage:[UIImage imageWithCGImage:[alasset2 thumbnail]]];
                cell.object3 = indexPath.row*3+2;
                [cell removeAlasset3Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*3+2];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset3Mark];
                }
            }
            else {
                [cell.alasset3 setImage:nil];
                cell.object3 = -1;
            }
        }
        else {
            if (nil == cell) {
                cell  = [[AlassetCell alloc] initWithiPhoneLandscapeStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAutoresizesSubviews:YES];
            if (indexPath.row*6 < alassetArray.count) {
                ALAsset *alasset0 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6)];
                [cell.alasset1 setImage:[UIImage imageWithCGImage:[alasset0 thumbnail]]];
                cell.object1 = indexPath.row*6;
                [cell removeAlasset1Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset1Mark];
                }
            }
            else {
                [cell.alasset1 setImage:nil];
                cell.object1 = -1;
            }
            
            if (indexPath.row*6+1 < alassetArray.count) {
                ALAsset *alasset1 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6+1)];
                [cell.alasset2 setImage:[UIImage imageWithCGImage:[alasset1 thumbnail]]];
                cell.object2 = indexPath.row*6+1;
                [cell removeAlasset2Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6+1];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset2Mark];
                }
            }
            else {
                [cell.alasset2 setImage:nil];
                cell.object2 = -1;
            }
            
            if (indexPath.row*6+2 < alassetArray.count) {
                ALAsset *alasset2 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6+2)];
                [cell.alasset3 setImage:[UIImage imageWithCGImage:[alasset2 thumbnail]]];
                cell.object3 = indexPath.row*6+2;
                [cell removeAlasset3Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6+2];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset3Mark];
                }
            }
            else {
                [cell.alasset3 setImage:nil];
                cell.object3 = -1;
            }
            
            if (indexPath.row*6+3 < alassetArray.count) {
                ALAsset *alasset3 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6+3)];
                [cell.alasset4 setImage:[UIImage imageWithCGImage:[alasset3 thumbnail]]];
                cell.object4 = indexPath.row*6+3;
                [cell removeAlasset4Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6+3];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset4Mark];
                }
            }
            else {
                [cell.alasset4 setImage:nil];
                cell.object4 = -1;
            }
            
            if (indexPath.row*6+4 < alassetArray.count) {
                ALAsset *alasset4 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6+4)];
                [cell.alasset5 setImage:[UIImage imageWithCGImage:[alasset4 thumbnail]]];
                cell.object5 = indexPath.row*6+4;
                [cell removeAlasset5Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6+4];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset5Mark];
                }
            }
            else {
                [cell.alasset5 setImage:nil];
                cell.object5 = -1;
            }
            
            if (indexPath.row*6+5 < alassetArray.count) {
                ALAsset *alasset5 = (ALAsset *)[alassetArray objectAtIndex:(indexPath.row*6+5)];
                [cell.alasset6 setImage:[UIImage imageWithCGImage:[alasset5 thumbnail]]];
                cell.object6 = indexPath.row*6+5;
                [cell removeAlasset6Mark];
                NSString *obj = [NSString stringWithFormat:@"%i",indexPath.row*6+5];
                if ([alassetSelectedArray containsObject:obj]) {
                    [cell setAlasset6Mark];
                }
            }
            else {
                [cell.alasset6 setImage:nil];
                cell.object6 = -1;
            }
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark AlassetCell Delegate
-(void)AlassetCell:(AlassetCell *)sender gotObjectIndex:(int)object
{
    debugLog(@"%i",object);
    NSString *obj = [NSString stringWithFormat:@"%i",object];
    [alassetSelectedArray addObject:obj];
}


@end
