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
#import "MoreCell.h"
#import "VKPrint.h"
#import "ASIHTTPRequest.h"
#import "VKConnectObj.h"

#define UserUnLogin 2009

@interface IndexViewController () <LookAroundViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *spaceArray;
    NSMutableArray *joinedSpaceArray;
    NSMutableArray *invitedSpaceArray;
    NSMutableDictionary *spaceCoverArray;
    
    UITableView *spaceTableView;
    
    int tableviewDataState;
    int tableviewActionState;
    
    ASIHTTPRequest *asiRequest;
}
@end

@implementation IndexViewController

-(void)dealloc
{
    [asiRequest clearDelegatesAndCancel];
}

-(void)setiPhoneUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    spaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, iPhone5?454:366)];
    spaceTableView.backgroundColor = [UIColor clearColor];
    spaceTableView.delegate = self;
    spaceTableView.dataSource = self;
    [spaceTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:spaceTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setiPhoneUI];
        
    spaceArray = [NSMutableArray arrayWithCapacity:0];
    joinedSpaceArray = [NSMutableArray arrayWithCapacity:0];
    invitedSpaceArray = [NSMutableArray arrayWithCapacity:0];
    spaceCoverArray = [NSMutableDictionary dictionaryWithCapacity:0];
    
//    if (!isLogin) {
//        [self performSelector:@selector(goToLookAround) withObject:nil afterDelay:0];
//    }
//    else {
        [self performSelector:@selector(loadSpaceLaunch) withObject:nil afterDelay:0];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [self loadSpaceLaunch];
    [spaceTableView reloadData];
}

#pragma mark tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 50;
    }
    else
        return 78;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return spaceArray.count;
    }
    else if (section == 1) {
        return joinedSpaceArray.count;
    }
    else if (section == 2) {
        return invitedSpaceArray.count;
    }
    else {
        if (tableviewDataState == TABLEVIEW_DATA_FULL) {
            return 0;
        }
        else
            return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"SpaceCell";
        LookAroundSpaceCell *cell = (LookAroundSpaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[LookAroundSpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *space = [spaceArray objectAtIndex:indexPath.row];
        cell.space = space;
        NSString *avatarString = [space objectForKey:@"cover"];
        NSURL *avatarUrl = [NSURL URLWithString:avatarString];
        NSString *avatarHashCode = [NSString stringWithFormat:@"%u",[[avatarUrl description] hash]];
        NSString *avatarKey = [NSString stringWithFormat:@"%i##%i##%@",indexPath.row,indexPath.section, avatarHashCode];
        UIImage *image = [spaceCoverArray objectForKey:avatarHashCode];
        if (image) {
            [cell.icon setImage:image];
        }
        else
        {
            //        [cell.avatarImageView  setImage:[UIImage imageNamed:@"widget_dface.png"]];
        }
        cell.name = [space objectForKey:@"spacename"];
        cell.memberCount = [NSString stringWithFormat:@"成员数:%@", [space objectForKey:@"memberCount"]];
        cell.activeCount = [NSString stringWithFormat:@"发展度:%@", [space objectForKey:@"twitterCount"]];
        cell.seperateImage = [UIImage imageNamed:@"divider.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        CellIdentifier = @"JoinedSpaceCell";
        LookAroundSpaceCell *cell = (LookAroundSpaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[LookAroundSpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *space = [joinedSpaceArray objectAtIndex:indexPath.row];
        cell.space = space;
        NSString *avatarString = [space objectForKey:@"cover"];
        NSURL *avatarUrl = [NSURL URLWithString:avatarString];
        NSString *avatarHashCode = [NSString stringWithFormat:@"%u",[[avatarUrl description] hash]];
        NSString *avatarKey = [NSString stringWithFormat:@"%i##%i##%@",indexPath.row,indexPath.section, avatarHashCode];
        UIImage *image = [spaceCoverArray objectForKey:avatarHashCode];
        if (image) {
            [cell.icon setImage:image];
        }
        else
        {
            //        [cell.avatarImageView  setImage:[UIImage imageNamed:@"widget_dface.png"]];
        }
        cell.name = [space objectForKey:@"spacename"];
        cell.memberCount = [NSString stringWithFormat:@"成员数:%@", [space objectForKey:@"memberCount"]];
        cell.activeCount = [NSString stringWithFormat:@"发展度:%@", [space objectForKey:@"twitterCount"]];
        cell.seperateImage = [UIImage imageNamed:@"divider.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2) {
        CellIdentifier = @"InvitedSpaceCell";
        LookAroundSpaceCell *cell = (LookAroundSpaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[LookAroundSpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *space = [invitedSpaceArray objectAtIndex:indexPath.row];
        cell.space = space;
        NSString *avatarString = [space objectForKey:@"cover"];
        NSURL *avatarUrl = [NSURL URLWithString:avatarString];
        NSString *avatarHashCode = [NSString stringWithFormat:@"%u",[[avatarUrl description] hash]];
        NSString *avatarKey = [NSString stringWithFormat:@"%i##%i##%@",indexPath.row,indexPath.section, avatarHashCode];
        UIImage *image = [spaceCoverArray objectForKey:avatarHashCode];
        if (image) {
            [cell.icon setImage:image];
        }
        else
        {
            //        [cell.avatarImageView  setImage:[UIImage imageNamed:@"widget_dface.png"]];
        }
        cell.name = [space objectForKey:@"spacename"];
        cell.memberCount = [NSString stringWithFormat:@"成员数:%@", [space objectForKey:@"memberCount"]];
        cell.activeCount = [NSString stringWithFormat:@"发展度:%@", [space objectForKey:@"twitterCount"]];
        cell.seperateImage = [UIImage imageNamed:@"divider.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        CellIdentifier = @"MoreCell";
        MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (tableviewActionState == TABLEVIEW_ACTION_INIT) {
            cell.tipLabel.text = @"加载中...";
            [cell.loadingView setHidden:NO];
        }
        if (tableviewDataState == TABLEVIEW_DATA_EMPTY) {
            [cell.tipLabel setText:@"这里什么都没有"];
            [cell.loadingView setHidden:YES];
        }
        if (tableviewDataState == TABLEVIEW_DATA_ERROR) {
            [cell.tipLabel setText:@"网络不给力哦!"];
            [cell.loadingView setHidden:YES];
        }
        return cell;
    }
}


-(void)loadAvatar:(NSData*)data key:(NSString*)key
{
    UIImage *img = [UIImage imageWithData:data];
    NSArray *array=[key componentsSeparatedByString:@"##"];
    int row = [[array objectAtIndex:0] intValue];
    int section = [[array objectAtIndex:1] intValue];
    if(!img)
    {
        
    }
    else {
        [spaceCoverArray setObject:img forKey:[array objectAtIndex:2]];
        NSIndexPath *Mindexpath=[NSIndexPath indexPathForRow:row inSection:section];
        LookAroundSpaceCell* cell = (LookAroundSpaceCell *)[spaceTableView cellForRowAtIndexPath:Mindexpath];
        cell.icon.alpha=0;
        [cell.icon setImage:img];
        [UIView beginAnimations:@"displayImage" context:nil];
        [UIView setAnimationDuration:0.5];
        cell.icon.alpha=1;
        [UIView commitAnimations];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark space/load
-(void) loadSpaceLaunch {
    tableviewDataState = -1;
    tableviewActionState = TABLEVIEW_ACTION_INIT;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:3];
    MoreCell *cell = (MoreCell *)[spaceTableView cellForRowAtIndexPath:index];
    [cell.tipLabel setText:@"加载中..."];
    [cell.loadingView setHidden:NO];
    
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate = self;
    obj.sel = @selector(loadSpaceLaunchFinish:);
    obj.wsel = @selector(loadSpaceLaunchFailure);
    NSURL *nsurl=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/space/list",WebSiteApi]];
    asiRequest = [ASIHTTPRequest requestWithURL:nsurl];
    [asiRequest setDelegate:self];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    [asiRequest setUserInfo:dic];
    [asiRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate != nil)
    {
        if([dic.delegate respondsToSelector:dic.sel])
        {
            [dic.delegate performSelector:dic.sel withObject:request.responseData];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.wsel])
        {
            [dic.delegate performSelector:dic.wsel] ;
        }
    }
}

-(void)loadSpaceLaunchFinish:(NSData*)data
{
    tableviewActionState = -1;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if([[dic objectForKey:@"result"] intValue]!=1)
    {
        tableviewDataState = TABLEVIEW_DATA_ERROR;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:[dic objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = [[dic objectForKey:@"errorCode"] intValue];
        [alert show];
    }
    else{
        debugLog(@"%@",[dic objectForKey:@"info"]);
        tableviewDataState = TABLEVIEW_DATA_EMPTY;
        int count = [[[dic objectForKey:@"info"] objectForKey:@"mySpace"] count];
        for (int i=0; i<count; i++) {
            tableviewDataState = TABLEVIEW_DATA_FULL;
            NSDictionary *space = [[[dic objectForKey:@"info"] objectForKey:@"mySpace"] objectAtIndex:i];
            [spaceArray addObject:space];
        }
        
        int joinedCount = [[[dic objectForKey:@"info"] objectForKey:@"joinedSpace"] count];
        for (int i=0; i<joinedCount; i++) {
            tableviewDataState = TABLEVIEW_DATA_FULL;
            NSDictionary *space = [[[dic objectForKey:@"info"] objectForKey:@"joinedSpace"] objectAtIndex:i];
            [joinedSpaceArray addObject:space];
        }
        int invitedCount = [[[dic objectForKey:@"info"] objectForKey:@"invitedSpace"] count];
        for (int i=0; i<invitedCount; i++) {
            tableviewDataState = TABLEVIEW_DATA_FULL;
            NSDictionary *space = [[[dic objectForKey:@"info"] objectForKey:@"invitedSpace"] objectAtIndex:i];
            [invitedSpaceArray addObject:space];
        }
        [spaceTableView reloadData];
    }
}

-(void)loadSpaceLaunchFailure
{
    tableviewActionState = -1;
    tableviewDataState = TABLEVIEW_DATA_ERROR;
}

#pragma mark alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == UserUnLogin) {
        [self performSelector:@selector(goToLookAround) withObject:nil afterDelay:0.3];
    }
}
@end
