//
//  LookAroundViewController.m
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "LookAroundViewController.h"
#import "AppDelegate.h"
#import "Tool.h"
#import "LookAroundSpaceCell.h"
#import "MoreCell.h"
#import "SVProgressHUD.h"

@interface LookAroundViewController () 
{
    UIButton *sinaLoginButton;
}

@end

@implementation LookAroundViewController
@synthesize sinaWeibo;

-(void)dealloc
{
    [[Tool getTheWebConnect] CancleNetWorkWithDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUI];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.oauthVC = self;
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:WeiboKey appSecret:WeiboSecret appRedirectURI:WeiboRedirectURI andDelegate:self];
    
}

- (IBAction)oauthLogin:(id)sender {
    [sinaWeibo logIn];
}

-(void)setUI
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"AppBackground.png"]];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:background];
    
    
    sinaLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sinaLoginButton setFrame:CGRectMake(0, screenframe.size.height-StatusBarHeight-50, screenframe.size.width, 50)];
    [sinaLoginButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [sinaLoginButton setTitle:@"登录" forState:UIControlStateNormal];
//    [sinaLoginButton setBackgroundImage:[UIImage imageNamed:@"sina-login-default.png"] forState:UIControlStateNormal];
    [sinaLoginButton addTarget:self action:@selector(oauthLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sinaLoginButton];
    
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    setWeiboAccessToken(sinaWeibo.accessToken)
    setIsLogin
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    
}

@end
