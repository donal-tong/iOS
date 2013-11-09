//
//  AlassetGroupViewController.m
//  wowo
//
//  Created by Donal on 13-7-23.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "AlassetGroupViewController.h"
#import "AlassetGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlassetViewController.h"


@interface AlassetGroupViewController () <UITableViewDelegate, UITableViewDataSource>
{
    ALAssetsLibrary *library;
    
    UITableView *alassetGroupTableView;
    NSMutableArray *alassetGroupArray;
}

@end

@implementation AlassetGroupViewController

-(void)setiPhoneUI
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
    
    alassetGroupTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44)];
    alassetGroupTableView.backgroundColor = [UIColor clearColor];
    alassetGroupTableView.delegate = self;
    alassetGroupTableView.dataSource = self;
    [alassetGroupTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [alassetGroupTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [alassetGroupTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:alassetGroupTableView];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setiPhoneUI];
    
    alassetGroupArray = [NSMutableArray arrayWithCapacity:0];
    
    library = [[ALAssetsLibrary alloc] init];
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
       {
           // Albums 遍历 Block
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
           {
               [group setAssetsFilter:[ALAssetsFilter allPhotos]];
               NSInteger gCount = [group numberOfAssets];
               if (nil == group || 0 == gCount)
               {
                   return;
               }
               [alassetGroupArray addObject:group];
               // Reload albums
               [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
           };
           
           // Albums 遍历 Failure Block
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
               [alert show];
           };	
           
           // 遍历 Albums
           [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator 
                                failureBlock:assetGroupEnumberatorFailure];
       });
}

-(void)reloadData
{
    [alassetGroupTableView reloadData];
}

#pragma mark tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return alassetGroupArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"AlassetGroupCell";
    AlassetGroupCell *cell = (AlassetGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[AlassetGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ALAssetsGroup *group = (ALAssetsGroup *)[alassetGroupArray objectAtIndex:indexPath.row];
    
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [group numberOfAssets];
    cell.alassetGroupDetail.text = [NSString stringWithFormat:@"%@ (%i)",[group valueForProperty:ALAssetsGroupPropertyName], gCount];
    [cell.alassetGroupCover setImage:[UIImage imageWithCGImage:[group posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *group = (ALAssetsGroup*)[alassetGroupArray objectAtIndex:indexPath.row];
    AlassetViewController *vc = [[AlassetViewController alloc] init];
    [vc setCurrentAlassetGroup:group];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
