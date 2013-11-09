//
//  LookAroundViewController.m
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "LookAroundViewController.h"
#import "LookAroundSpaceCell.h"
#import "MoreCell.h"
#import "AlassetGroupViewController.h"
#import "VKConnectObj.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface LookAroundViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *spaceArray;
    NSMutableDictionary *spaceCoverArray;
    
    UITableView *spaceTableView;
    UIButton *sinaLoginButton;
    
    int tableviewDataState;
    int tableviewActionState;
    
    
    NSOperationQueue *netQueue;
    ASIDownloadCache *PicDownCache;
    NSMutableArray *downLoadImageList;
}


@end

@implementation LookAroundViewController
//@synthesize sinaWeibo;

-(void)dealloc
{
    for (ASIHTTPRequest *rq in [netQueue operations]) {
        [rq clearDelegatesAndCancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setiPhoneUI];
    
    netQueue = [[NSOperationQueue alloc] init];
    [netQueue setMaxConcurrentOperationCount:5];
    downLoadImageList = [NSMutableArray arrayWithCapacity:0];
    
    spaceArray = [NSMutableArray arrayWithCapacity:0];
    spaceCoverArray = [NSMutableDictionary dictionaryWithCapacity:0];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.oauthVC = self;
//    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:WeiboKey appSecret:WeiboSecret appRedirectURI:WeiboRedirectURI andDelegate:self];
    
    [self loadSpaceLaunch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)oauthLogin:(id)sender {
//    [sinaWeibo logIn];
    AlassetGroupViewController *vc = [[AlassetGroupViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)setiPhoneUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    spaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    spaceTableView.backgroundColor = [UIColor clearColor];
    spaceTableView.delegate = self;
    spaceTableView.dataSource = self;
    [spaceTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:spaceTableView];
    
    sinaLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaLoginButton setFrame:CGRectMake(0, screenframe.size.height-StatusBarHeight-50, screenframe.size.width, 50)];
    [sinaLoginButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [sinaLoginButton setBackgroundImage:[UIImage imageNamed:@"sina-login-default.png"] forState:UIControlStateNormal];
    [sinaLoginButton addTarget:self action:@selector(oauthLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sinaLoginButton];
}

#pragma mark - SinaWeibo Delegate

//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
//{
//    NSString *oauth_token = sinaweibo.accessToken;
////    NSString *expires_in =[NSString stringWithFormat:@"%i",(int)[sinaweibo.expirationDate timeIntervalSinceNow]];
//    
//    setWeiboAccessToken(sinaWeibo.accessToken)
//    
//    //    NSString *token=[[[self.devToken stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
//    
//    CGRect mainScreen=[[UIScreen mainScreen] bounds];
//    NSString *screen=[NSString stringWithFormat:@"%i*%i",(int)(mainScreen.size.width*[[UIScreen mainScreen] scale]),(int)(mainScreen.size.height*[[UIScreen mainScreen] scale])];
//    NSString *client_os = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    NSString *oauth_id = sinaweibo.userID;
////    NSString *oauth_token = sinaweibo.accessToken;
////    NSString *expires_in =[NSString stringWithFormat:@"%i",(int)[sinaweibo.expirationDate timeIntervalSinceNow]];
//    [dic setValue:@"sina2" forKey:@"oauth_type"];
//    [dic setValue:oauth_id forKey:@"oauth_id"];
//    [dic setValue:oauth_token forKey:@"oauth_token"];
////    [dic setValue:expires_in forKey:@"expires_in"];
//    //    [dic setValue:token forKey:@"device_token"];
//    [dic setValue:app_Version forKey:@"client_browser"];
//    [dic setValue:screen forKey:@"client_screen"];
//    [dic setValue:client_os forKey:@"client_os"];
//    [dic setValue:@"ios" forKey:@"client_type"];
//    [[Tool getTheWebConnect] addNetWorkConnect:[NSString stringWithFormat:@"%@/user/oauthlogin",WebSiteApi] data:dic delegate:self sel:@selector(oauthLoginFinish:) wsel:@selector(oauthLoginFailure)];
//    
//}

//- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
//{
//    NSLog(@"sinaweiboDidLogOut");
//}
//
//- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
//{
//    NSLog(@"sinaweiboLogInDidCancel");
//}
//
//- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
//{
//    NSLog(@"sinaweibo logInDidFailWithError %@", error);
//}
//
//- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
//{
//    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
//    
//}

-(void)oauthLoginFinish:(NSData*)data
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic=(NSDictionary*)jsonObject;
    if([[dic objectForKey:@"result"] intValue]!=1)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        NSDictionary *infoDic = [dic objectForKey:@"info"];
        NSString *user_id = [infoDic objectForKey:@"uid"];
        setIsLogin
        setWeiboUserId(user_id)
        if ([self.delegate respondsToSelector:@selector(sinaDidLogin)]) {
            [self.delegate sinaDidLogin];
        }
    }
}

-(void)oauthLoginFailure
{
    
}

#pragma mark tableview delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        return 78;
    }
    else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return spaceArray.count;
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
            [self addPicLink:avatarString key:avatarKey delegate:self sel:@selector(loadAvatar:key:) wsel:nil];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark asirequest delegate
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

#pragma mark space/load
-(void) loadSpaceLaunch {
    tableviewActionState = TABLEVIEW_ACTION_INIT;
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    MoreCell *cell = (MoreCell *)[spaceTableView cellForRowAtIndexPath:index];
    [cell.tipLabel setText:@"加载中..."];
    [cell.loadingView setHidden:NO];
    NSURL *nsurl=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/space/launch",WebSiteApi]];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate = self;
    obj.sel = @selector(loadSpaceLaunchFinish:);
    obj.wsel = @selector(loadSpaceLaunchFailure);
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nsurl];
    [request setDelegate:self];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj", nil];
    request.userInfo= dic;
    [netQueue addOperation:request];
}



-(void)loadSpaceLaunchFinish:(NSData*)data
{
    tableviewActionState = -1;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = (NSDictionary*)jsonObject;
    debugLog(@"%@",dic);
    if([[dic objectForKey:@"result"] intValue]!=1)
    {
        tableviewDataState = TABLEVIEW_DATA_ERROR;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        //        debugLog(@"%@",[dic objectForKey:@"info"]);
        tableviewDataState = TABLEVIEW_DATA_EMPTY;
        int count = [[dic objectForKey:@"info"] count];
        for (int i=0; i<count; i++) {
            NSDictionary *space = [[dic objectForKey:@"info"] objectAtIndex:i];
            [spaceArray addObject:space];
            tableviewDataState = TABLEVIEW_DATA_FULL;
        }
        [spaceTableView reloadData];
    }
}

-(void)loadSpaceLaunchFailure
{
    tableviewActionState = -1;
    tableviewDataState = TABLEVIEW_DATA_ERROR;
}

#pragma mark asi load avatar 
-(void)addPicLink:(NSString*)link key:(NSString*)key delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    if(![link hasPrefix:@"http://"])
    {
        link=[VKWebSite stringByAppendingString:link];
    }
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    
    [downLoadImageList addObject:nsurl];
    
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=key;
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nsurl];
    request.delegate=self;
    [request setDidFinishSelector:@selector(picLoadFinish:)];
    [request setDidFailSelector:@selector(picLoadFail:)];
    if(!PicDownCache)
    {
        [self creatDownloadCache];
    }
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadCache:PicDownCache];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    request.userInfo= dic;
    [netQueue addOperation:request];
}

-(void)creatDownloadCache
{
    PicDownCache = [[ASIDownloadCache alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [PicDownCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"CachePic"]];
    [PicDownCache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
}

-(void)picLoadFinish:(ASIHTTPRequest *)request
{
    [downLoadImageList removeObject:request.url];
    
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([request responseStatusCode] == 200 || [request responseStatusCode] == 304){
        if([dic.delegate respondsToSelector:dic.sel] && request.responseData.length>0)
        {
            [dic.delegate performSelector:dic.sel withObject:request.responseData withObject:dic.key];
        }
        else
        {
            [request setSecondsToCache:0];
        }
    }
}

-(void)picLoadFail:(ASIHTTPRequest *)request
{
    [downLoadImageList removeObject:request.url];
    
    if([request.error code]!=4 &&  [request.error code]!=2)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

@end
