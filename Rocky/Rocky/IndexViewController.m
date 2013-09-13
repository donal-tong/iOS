//
//  IndexViewController.m
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "IndexViewController.h"
#import "LookAroundViewController.h"
#import "LookAroundSpaceCell.h"
#import "Tool.h"
#import "NameCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RetweetViewController.h"

#define UserUnLogin 2009

@interface IndexViewController () <LookAroundViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UIView *menuView;
    
    NSMutableArray *spaceArray;
    NSMutableArray *joinedSpaceArray;
    NSMutableArray *invitedSpaceArray;
    NSMutableDictionary *spaceCoverArray;
    
    UITableView *spaceTableView;
    
    int tableviewDataState;
    int tableviewActionState;
    
}
@end

@implementation IndexViewController


-(void)setiPhoneUI
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"AppBackground.png"]];
    [self.view addSubview:background];
        
    spaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    spaceTableView.backgroundColor = [UIColor clearColor];
    spaceTableView.delegate = self;
    spaceTableView.dataSource = self;
    [self.view addSubview:spaceTableView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setiPhoneUI];
    
    spaceArray = [NSMutableArray arrayWithCapacity:0];
    [spaceArray addObject:@"load转发者"];
    [spaceTableView reloadData];
    
//    if (!isLogin) {
        [self performSelector:@selector(goToLookAround) withObject:nil afterDelay:0];
//    }
}


-(void)goToLookAround
{
    LookAroundViewController *vc = [[LookAroundViewController alloc] init];
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [vc setDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark LookAroundViewControllerDelegate
-(void)sinaDidLogin
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return spaceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"MoreCell";
    NameCell *cell = (NameCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[NameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.tipLabel.text = (NSString *)[spaceArray objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            RetweetViewController *vc = [[RetweetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
    }
}

@end
