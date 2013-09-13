//
//  RetweetViewController.m
//  Rocky
//
//  Created by Donal on 13-7-31.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "RetweetViewController.h"
#import "Tool.h"
#import "NameCell.h"
#import "SVProgressHUD.h"
#import "Retweeter+generate.h"

@interface RetweetViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UITextField *midTF;
    NSString *twitterId;
    
    NSMutableArray *retweeterArray;
    UITableView *spaceTableView;
    
    UILabel *repostsCountLabel;
    UITextField *commentMidTF;
    UIButton *atButton;
    int atIndex;
    
    int tableviewDataState;
    int tableviewActionState;
    int currentPage;
}
@end

@implementation RetweetViewController

-(void)searchMid
{
    [midTF resignFirstResponder];
    debugLog(@"%@",midTF.text);
    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/queryid.json?mid=%@&access_token=%@&type=1&source=%@&isBase62=%@",@"zELzvc24i",getWeiboAccessToken, WeiboKey, @"1"] data:nil delegate:self sel:@selector(searchMidFinished:) wsel:@selector(searchMidFailed)];
    [SVProgressHUD show];
}

-(void)searchCommentMid
{
    atIndex = 1056;
    [atButton setEnabled:NO];
    [commentMidTF resignFirstResponder];
    debugLog(@"%@",commentMidTF.text);
    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/queryid.json?mid=%@&access_token=%@&type=1&source=%@&isBase62=%@",@"A2BGObx6E",getWeiboAccessToken, WeiboKey, @"1"] data:nil delegate:self sel:@selector(searchCommentMidFinished:) wsel:@selector(searchCommentMidFailed)];
    [SVProgressHUD show];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setiPhoneUI
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"AppBackground.png"]];
    [self.view addSubview:background];
   
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(5, 7, 35, 30)];
    [self.view addSubview:backButton];
    
    midTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, 100, 30)];
    [midTF setBorderStyle:UITextBorderStyleBezel];
    [midTF setDelegate:self];
    [self.view addSubview:midTF];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"搜索该Mid的转发者" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchMid) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setFrame:CGRectMake(160, 7, 150, 30)];
    [self.view addSubview:searchButton];
    
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, screenframe.size.width, 1)];
    [seperateView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:seperateView];
    
    spaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    spaceTableView.backgroundColor = [UIColor clearColor];
    spaceTableView.delegate = self;
    spaceTableView.dataSource = self;
    [self.view addSubview:spaceTableView];
    
    UIView *seperateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 410, screenframe.size.width, 1)];
    [seperateView1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:seperateView1];
    
    repostsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 423, 80, 20)];
    [repostsCountLabel setFont:[UIFont systemFontOfSize:10.0]];
    [repostsCountLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:repostsCountLabel];
    
    commentMidTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 423, 100, 30)];
    [commentMidTF setBorderStyle:UITextBorderStyleBezel];
    [commentMidTF setDelegate:self];
    [self.view addSubview:commentMidTF];
    
    atButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [atButton setTitle:@"@转发者到此微博Mid" forState:UIControlStateNormal];
    [atButton addTarget:self action:@selector(searchCommentMid) forControlEvents:UIControlEventTouchUpInside];
    [atButton setFrame:CGRectMake(160, 423, 150, 30)];
    [atButton setEnabled:NO];
    [self.view addSubview:atButton];
}

-(void)dealloc
{
    [[Tool getTheWebConnect] CancleNetWorkWithDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setiPhoneUI];
    retweeterArray = [NSMutableArray arrayWithCapacity:0];

}

#pragma mark textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == commentMidTF) {
        CGRect viewFrame = [self.view frame];
        viewFrame.origin.y = -216;
        [self.view setFrame:viewFrame];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL returnValue = NO;
    if (textField == midTF) {
        if ([textField.text length] != 0) {
            [midTF resignFirstResponder];
            returnValue = YES;
        }
    }
    if (textField == commentMidTF) {
        if ([textField.text length] != 0) {
            [commentMidTF resignFirstResponder];
            returnValue = YES;
        }
    }
    return returnValue;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == commentMidTF) {
        CGRect viewFrame = [self.view frame];
        viewFrame.origin.y = 0;
        [self.view setFrame:viewFrame];
    }
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
    return retweeterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"MoreCell";
    NameCell *cell = (NameCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[NameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Retweeter *retweeter = [retweeterArray objectAtIndex:indexPath.row];
    cell.tipLabel.text = retweeter.screen_name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[midTF resignFirstResponder];
    [commentMidTF resignFirstResponder];
}

#pragma mark searchMid
-(void)searchMidFinished:(NSData *)data
{
    [SVProgressHUD dismiss];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if ([[dic objectForKey:@"id"] isEqualToString:@"-1"]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"mid错误了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        debugLog(@"%@",[dic objectForKey:@"id"]);
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSArray *tempArray = [Retweeter getRetweetersOfTwitterID:[dic objectForKey:@"id"] inManagedObjectContext:appDelegate.managedObjectContext];
        if (tempArray.count > 0) {
            debugLog(@"%i",tempArray.count);
            repostsCountLabel.text = [NSString stringWithFormat:@"共%i转发者",tempArray.count];
            [atButton setEnabled:YES];
            [retweeterArray addObjectsFromArray:tempArray];
            [spaceTableView reloadData];
        }
        else {
            currentPage = 1;
            [self searchRetweeter:[dic objectForKey:@"id"]];
        }
    }
}

-(void)searchMidFailed
{
    [SVProgressHUD dismiss];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络不给力哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark search retweeter
-(void)searchRetweeter:(NSString *)wid
{
    twitterId = wid;
    debugLog(@"%@",[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/repost_timeline.json?access_token=%@&id=%@",WeiboAccessToken, wid]);
    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/repost_timeline.json?access_token=%@&id=%@&count=200&page=1",getWeiboAccessToken, wid] data:nil delegate:self sel:@selector(searchRetweeterFinished:) wsel:@selector(searchRetweeterFailed)];
    [SVProgressHUD show];
}

-(void)searchRetweeterFinished:(NSData *)data
{
    [SVProgressHUD dismiss];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
    @try {
        NSArray *reposts = [dic objectForKey:@"reposts"];
        debugLog(@"reposts:%i",reposts.count);
        for (NSDictionary *repost in reposts) {
            Retweeter *retweeter = [Retweeter saveRetweeter:repost andTwitterID:twitterId inManagedObjectContext:appDelegate.managedObjectContext];
            [appDelegate saveContext];
            if (![retweeterArray containsObject:retweeter]) {
                [retweeterArray addObject:retweeter];
            }
        }
        [spaceTableView reloadData];
        if (reposts.count != 0) {
            currentPage++;
            [self searchRetweeterNextPage:currentPage];
//            NSDictionary *lastDictionay = [reposts lastObject];
//            debugLog(@"%@",[NSString stringWithFormat:@"%ld",[[lastDictionay objectForKey:@"id"] longValue]]);
//            [self searchRetweeterNextCursor:[NSString stringWithFormat:@"%ld",[[lastDictionay objectForKey:@"id"] longValue]]];
        }
        else {
            repostsCountLabel.text = [NSString stringWithFormat:@"共%i转发者",retweeterArray.count];
            [atButton setEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        debugLog(@"Exception: %@", exception);
        debugLog(@"%@",dic);
        debugLog(@"%i",retweeterArray.count);
        repostsCountLabel.text = [NSString stringWithFormat:@"共%i转发者",retweeterArray.count];
        [atButton setEnabled:YES];
    }
}

-(void)searchRetweeterFailed
{
    [SVProgressHUD dismiss];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络不给力哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)searchRetweeterNextPage:(int)nextPage
{
    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/repost_timeline.json?access_token=%@&id=%@&page=%i&count=200",getWeiboAccessToken, twitterId, nextPage] data:nil delegate:self sel:@selector(searchRetweeterFinished:) wsel:@selector(searchRetweeterFailed)];
    [SVProgressHUD show];
}

-(void)searchRetweeterNextCursor:(NSString *)next_cursor
{
    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/repost_timeline.json?access_token=%@&id=%@&max_id=%@&count=200",getWeiboAccessToken, twitterId, next_cursor] data:nil delegate:self sel:@selector(searchRetweeterFinished:) wsel:@selector(searchRetweeterFailed)];
    [SVProgressHUD show];
}

#pragma mark searchCommentMid
-(void)searchCommentMidFinished:(NSData *)data
{
    [SVProgressHUD dismiss];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
    if ([[dic objectForKey:@"id"] isEqualToString:@"-1"]) {
        [atButton setEnabled:YES];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"mid错误了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        debugLog(@"%@",[dic objectForKey:@"id"]);
        if(retweeterArray.count > 3){
            Retweeter *retwtter0 = [retweeterArray objectAtIndex:atIndex];
            Retweeter *retwtter1 = [retweeterArray objectAtIndex:atIndex+1];
            Retweeter *retwtter2 = [retweeterArray objectAtIndex:atIndex+2];
            NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,感谢你的支持,【Iphone手机下载记忆碎片】【Android手机下载 爱的流声机】即可获得卡片",retwtter0.screen_name,retwtter1.screen_name, retwtter2.screen_name];
            NSString *key = [NSString stringWithFormat:@"%@##%@##%@##%@",retwtter0.retweeterID,retwtter1.retweeterID, retwtter2.retweeterID, twitterId];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:getWeiboAccessToken, @"access_token", contentString, @"comment", @"3606215382748872", @"id", nil];
            [[Tool getTheWebConnect] postComment:@"https://api.weibo.com/2/comments/create.json" key:key data:params delegate:self sel:@selector(atRetweeterFinished:key:) wsel:@selector(atRetweeterFailed:)];
            
//            [SVProgressHUD show];
        }
    }
}

-(void)searchCommentMidFailed
{
    [SVProgressHUD dismiss];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"网络不给力哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [atButton setEnabled:YES];
}

#pragma mark atRetweeter
-(void)atRetweeterFinished:(NSData *)data key:(NSString *)key
{
    NSArray *array=[key componentsSeparatedByString:@"##"];
    NSString *retweeterID0 = [array objectAtIndex:0];
    NSString *retweeterID1 = [array objectAtIndex:1];
    NSString *retweeterID2 = [array objectAtIndex:2];
    debugLog(@"%@",retweeterID0);
    NSString *currentTwitterID = [array objectAtIndex:3];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
//    debugLog(@"%@",dic);
    int errorCode = [[dic objectForKey:@"error_code"] intValue];
    if (errorCode != 0 && errorCode != 20101) {
        debugLog(@"%@",dic);
        [[Tool getTheWebConnect] CancleNetWorkWithDelegate:self];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误1" message:[dic objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [Retweeter editRetweeter:retweeterID0 andTwitterID:currentTwitterID inManagedObjectContext:appDelegate.managedObjectContext];
        [appDelegate saveContext];
        [Retweeter editRetweeter:retweeterID1 andTwitterID:currentTwitterID inManagedObjectContext:appDelegate.managedObjectContext];
        [appDelegate saveContext];
        [Retweeter editRetweeter:retweeterID2 andTwitterID:currentTwitterID inManagedObjectContext:appDelegate.managedObjectContext];
        [appDelegate saveContext];
        [self performSelector:@selector(atRetweeterAgain) withObject:nil afterDelay:15];
    }
}

-(void)atRetweeterFailed:(NSString *)key
{
//    NSArray *array=[key componentsSeparatedByString:@"##"];
//    NSString *retweeterID0 = [array objectAtIndex:0];
//    NSString *retweeterID1 = [array objectAtIndex:1];
//    NSString *retweeterID2 = [array objectAtIndex:2];
//    NSString *currentTwitterID = [array objectAtIndex:3];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"comment错误了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)atRetweeterAgain
{
    atIndex = atIndex + 3;
    if (atIndex < retweeterArray.count) {
        if(atIndex == (retweeterArray.count-1)){
            Retweeter *retwtter0 = [retweeterArray objectAtIndex:atIndex];
            NSString *contentString = [NSString stringWithFormat:@"%@,感谢你的支持,【Iphone手机下载记忆碎片】【Android手机下载 爱的流声机】即可获得卡片",retwtter0.screen_name];
            NSString *key = [NSString stringWithFormat:@"%@##%@##%@##%@",retwtter0.retweeterID, @"", @"", twitterId];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:getWeiboAccessToken, @"access_token", contentString, @"comment", @"3606215382748872", @"id", nil];
            [[Tool getTheWebConnect] postComment:@"https://api.weibo.com/2/comments/create.json" key:key data:params delegate:self sel:@selector(atRetweeterFinished:key:) wsel:@selector(atRetweeterFailed:)];
        }
        else if ( atIndex == (retweeterArray.count-2) ) {
            Retweeter *retwtter0 = [retweeterArray objectAtIndex:atIndex];
            Retweeter *retwtter1 = [retweeterArray objectAtIndex:atIndex+1];
            NSString *contentString = [NSString stringWithFormat:@"%@,%@,感谢你的支持,【Iphone手机下载记忆碎片】【Android手机下载 爱的流声机】即可获得卡片",retwtter0.screen_name,retwtter1.screen_name];
            NSString *key = [NSString stringWithFormat:@"%@##%@##%@##%@",retwtter0.retweeterID,retwtter1.retweeterID, @"0", twitterId];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:getWeiboAccessToken, @"access_token", contentString, @"comment", @"3606215382748872", @"id", nil];
            [[Tool getTheWebConnect] postComment:@"https://api.weibo.com/2/comments/create.json" key:key data:params delegate:self sel:@selector(atRetweeterFinished:key:) wsel:@selector(atRetweeterFailed:)];
        }
        else {
            Retweeter *retwtter0 = [retweeterArray objectAtIndex:atIndex];
            Retweeter *retwtter1 = [retweeterArray objectAtIndex:atIndex+1];
            Retweeter *retwtter2 = [retweeterArray objectAtIndex:atIndex+2];
            NSString *contentString = [NSString stringWithFormat:@"%@,%@,%@,感谢你的支持,【Iphone手机下载记忆碎片】【Android手机下载 爱的流声机】即可获得卡片",retwtter0.screen_name,retwtter1.screen_name, retwtter2.screen_name];
            NSString *key = [NSString stringWithFormat:@"%@##%@##%@##%@",retwtter0.retweeterID,retwtter1.retweeterID, retwtter2.retweeterID, twitterId];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:getWeiboAccessToken, @"access_token", contentString, @"comment", @"3606215382748872", @"id", nil];
            [[Tool getTheWebConnect] postComment:@"https://api.weibo.com/2/comments/create.json" key:key data:params delegate:self sel:@selector(atRetweeterFinished:key:) wsel:@selector(atRetweeterFailed:)];
        }
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ok" message:@"at 完" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
