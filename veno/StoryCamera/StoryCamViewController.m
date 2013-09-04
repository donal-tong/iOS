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
    UIScrollView *waterScrollView;
    UIPageControl *waterPageControl;
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
        [self addHollowOpenToView:stillImageView];
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

- (void)addHollowOpenToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"cameraIrisHollowOpen";
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)addHollowCloseToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIrisHollowClose";
    animation.subtype = kCATransitionFromLeft;
    [view.layer addAnimation:animation forKey:@"HollowClose"];
}

- (void)takePicture
{
    [super takePicture];
}

- (void)showPhoto
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)takePhotoDone
{
    [doneButton setEnabled:NO];
    UIImage *composedImage = finishedImage;
    UIView *waterMark = [waterScrollView viewWithTag:100];
    for (UIView *view in waterMark.subviews) {
        UIImage *subImage = nil;
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *subImageView = (UIImageView *)view;
            subImage = subImageView.image;
        }
        else
            subImage = [self captureView:view];
        composedImage = [self composeImage:subImage toImage:composedImage atFrame:view.frame];
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[composedImage CGImage] orientation:(ALAssetOrientation)[composedImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        [doneButton setEnabled:YES];
    }];
}

-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    UIImage* image = nil;
    UIGraphicsBeginImageContext(rect.size);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [theView.layer renderInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage atFrame:(CGRect)frame
{
    CGSize superSize = superImage.size;
    CGFloat widthScale = frame.size.width / screenframe.size.width;
    CGFloat heightScale = frame.size.height / waterScrollView.frame.size.height;
    CGFloat xScale = frame.origin.x / screenframe.size.width;
    CGFloat yScale = frame.origin.y / waterScrollView.frame.size.height;
    CGRect subFrame = CGRectMake(xScale * superSize.width, yScale * superSize.height, widthScale * superSize.width, heightScale * superSize.height);
    UIGraphicsBeginImageContext(superSize);
    [superImage drawInRect:CGRectMake(0, 0, superSize.width, superSize.height)];
    [subImage drawInRect:subFrame];
    UIImage *finish = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finish;
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
        
        waterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, screenframe.size.height-50)];
        [waterScrollView setBouncesZoom:YES];
        [waterScrollView setScrollEnabled:YES];
        [waterScrollView setPagingEnabled:YES];
        [waterScrollView setDelegate:self];
        [waterScrollView setBackgroundColor:[UIColor clearColor]];
        [waterScrollView setShowsHorizontalScrollIndicator:NO];
        [waterScrollView setContentSize:CGSizeMake(screenframe.size.width*2, screenframe.size.height-50)];
        [PLCameraView addSubview:waterScrollView];
        waterPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((screenframe.size.width-38)/2, screenframe.size.height-88, 38, 36)];
        [waterPageControl setNumberOfPages:2];
        [waterPageControl setCurrentPage:0];
        [PLCameraView addSubview:waterPageControl];
        
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
        
        [self setMark];
        [self performSelector:@selector(hidePage) withObject:nil afterDelay:0.5];
    }
}

-(void)setMark
{
    UIView *markView0 =[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, waterScrollView.frame.size.height)];
    [markView0 setBackgroundColor:[UIColor clearColor]];
    UIImage *starImage = [UIImage imageNamed:@"FunnyStar.png"];
    UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(markView0.frame.size.width-17-starImage.size.width, 342, starImage.size.width, starImage.size.height)];
    [starImageView setImage:starImage];
    [markView0 addSubview:starImageView];
    UIImage *starTagImage = [UIImage imageNamed:@"FunnyStarTag.png"];
    UIImageView *starTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(154, 374, starTagImage.size.width, starTagImage.size.height)];
    [starTagImageView setImage:starTagImage];
    [markView0 addSubview:starTagImageView];
    [markView0 setTag:100];
    [waterScrollView addSubview:markView0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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

#pragma mark scrollView Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [waterPageControl setAlpha:1.0];
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x-pageWidth/100)/pageWidth)+1;
    [waterPageControl setCurrentPage:page];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(hidePage) withObject:nil afterDelay:0.5];
}

-(void)hidePage
{
    [waterPageControl setAlpha:0.0];
}

@end
