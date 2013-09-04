//
//  StoryCamViewController.m
//  wowo
//
//  Created by Donal on 13-8-27.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "StoryCamViewController.h"
#import "UIImage+Cut.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenHeight (IS_IPHONE5 ? 548.0 : 460.0)

@interface StoryCamViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIScrollViewDelegate>
{
    UIImageView *stillImageView;
    UIImage *finishedImage;
    
    UIButton *takePhotoButton;
    UIButton *deviceBtn;
    UIButton *flashModeButton;
    UIButton *retakePhotoButton;
    UIButton *doneButton;
}
@end

@implementation StoryCamViewController

#pragma mark - ButtonAction Methods

- (void)swapFrontAndBackCameras
{
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)retakePhoto
{
    if (finishedImage != nil) {
        finishedImage = nil;
        [stillImageView setImage:nil];
        [stillImageView setHidden:YES];
        doneButton.hidden = YES;
        retakePhotoButton.hidden = YES;
        takePhotoButton.hidden = NO;
        flashModeButton.hidden = NO;
        deviceBtn.hidden = NO;
    }
}

- (void)takePicture
{
    [super startVideoCapture];
}

-(void)takePhotoDone
{
    [doneButton setEnabled:NO];
}


#pragma mark get/show the UIView we want
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
    
        
        UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
        
        
        [self setShowsCameraControls:NO];
        
        stillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, screenframe.size.height-55)];
        [stillImageView setHidden:YES];
        [PLCameraView addSubview:stillImageView];
        
        
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0, screenframe.size.height - 55, screenframe.size.width, 55)];
        [overlyView setBackgroundColor:[UIColor clearColor]];
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, overlyView.frame.size.height)];
        [bg setImage:[UIImage imageNamed:@"OverLayBackground.png"]];
        [bg setContentMode:UIViewContentModeScaleAspectFill];
        [bg setClipsToBounds:YES];
        [overlyView addSubview:bg];
        
        UIImage *camerImage = [UIImage imageNamed:@"TakePhotoButtonDefault.png"];
        takePhotoButton = [[UIButton alloc] initWithFrame:
                               CGRectMake((screenframe.size.width-camerImage.size.width)/2, (overlyView.frame.size.height-camerImage.size.height)/2, camerImage.size.width, camerImage.size.height)];
        [takePhotoButton setImage:camerImage forState:UIControlStateNormal];
        [takePhotoButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:takePhotoButton];
        
        UIImage *retakePhotoImage = [UIImage imageNamed:@"RetakePhotoButtonDefault.png"];
        retakePhotoButton = [[UIButton alloc] initWithFrame:
                           CGRectMake(46, (overlyView.frame.size.height-retakePhotoImage.size.height)/2, retakePhotoImage.size.width, retakePhotoImage.size.height)];
        [retakePhotoButton setImage:retakePhotoImage forState:UIControlStateNormal];
        [retakePhotoButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
        retakePhotoButton.hidden = YES;
        [overlyView addSubview:retakePhotoButton];
        
        UIImage *doneImage = [UIImage imageNamed:@"DoneButtonDefault.png"];
        doneButton = [[UIButton alloc] initWithFrame:
                           CGRectMake((screenframe.size.width-doneImage.size.width)/2, (overlyView.frame.size.height-doneImage.size.height)/2, doneImage.size.width, doneImage.size.height)];
        [doneButton setImage:doneImage forState:UIControlStateNormal];
        doneButton.hidden = YES;
        [doneButton addTarget:self action:@selector(takePhotoDone) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:doneButton];
        
        self.cameraOverlayView = overlyView;
        
        UIImage *deviceImage = [UIImage imageNamed:@"CamerasButtonDefault.png"];
        deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setBackgroundImage:deviceImage forState:UIControlStateNormal];
        [deviceBtn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setFrame:CGRectMake(screenframe.size.width-deviceImage.size.width-9, 22, deviceImage.size.width, deviceImage.size.height)];
        [PLCameraView addSubview:deviceBtn];
        
        UIImage *flashLightImage = [UIImage imageNamed:@"FlashLightButtonDefault.png"];
        flashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [flashModeButton setBackgroundImage:flashLightImage forState:UIControlStateNormal];
        [flashModeButton setFrame:CGRectMake(10, 22, flashLightImage.size.width, flashLightImage.size.height)];
        [PLCameraView addSubview:flashModeButton];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType]; 
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image clipImageWithScaleWithsize:CGSizeMake(1200, 1600)];
        [stillImageView setHidden:NO];
        doneButton.hidden = NO;
        [doneButton setEnabled:YES];
        retakePhotoButton.hidden = NO;
        takePhotoButton.hidden = YES;
        flashModeButton.hidden = YES;
        deviceBtn.hidden = YES;
        [stillImageView setImage:image];
        finishedImage = image;
    }
    
    //使用的檔案格式是影片
    if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    if(_isSingle){
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
