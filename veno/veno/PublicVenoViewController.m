//
//  PublicVenoViewController.m
//  veno
//
//  Created by Donal on 13-9-6.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "PublicVenoViewController.h"
#import "VenoCameraViewController.h"

@interface PublicVenoViewController ()

@end

@implementation PublicVenoViewController

-(void)addVeno
{
    VenoCameraViewController *vc = [[VenoCameraViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)setUI
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, 44)];
    [menuView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:190/255.0 blue:143/255.0 alpha:1.0]];
    [self.view addSubview:menuView];
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setFrame:CGRectMake(screenframe.size.width-65, 0, 65, 44)];
    [RightButton setBackgroundImage:[UIImage imageNamed:@"AddVeno.png"] forState:UIControlStateNormal];
    [RightButton addTarget:self action:@selector(addVeno) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:RightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}

@end
