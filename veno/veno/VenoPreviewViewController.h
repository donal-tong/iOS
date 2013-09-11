//
//  VinoPreviewViewController.h
//  veno
//
//  Created by Donal on 13-9-7.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VenoPreviewViewControllerDelegate <NSObject>

-(void)publishVideo:(NSString *)filePath;
-(void)cancelPublishAndDeleteVideo;

@end


@interface VenoPreviewViewController : UIViewController

@property (nonatomic, assign) id<VenoPreviewViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *videoFilePath;



@end
