//
//  LookAroundViewController.h
//  wowo
//
//  Created by Donal on 13-7-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@protocol LookAroundViewControllerDelegate <NSObject>

-(void)sinaDidLogin;

@end

@interface LookAroundViewController : UIViewController <SinaWeiboDelegate>

@property (strong, nonatomic) SinaWeibo *sinaWeibo;
@property (assign, nonatomic) id<LookAroundViewControllerDelegate> delegate;

@end
