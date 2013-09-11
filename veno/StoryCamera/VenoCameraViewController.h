//
//  WaterCameraViewController.h
//  wowo
//
//  Created by Donal on 13-8-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleEditor.h"

@protocol VenoCameraViewControllerDelegate <NSObject>

-(void)publishVideo:(NSString *)filePath;

@end

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface VenoCameraViewController : UIViewController
@property (nonatomic, strong) SimpleEditor *editor;
@property (nonatomic, assign) id<VenoCameraViewControllerDelegate> delegate;

@end
