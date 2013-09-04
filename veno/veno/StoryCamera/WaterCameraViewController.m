//
//  WaterCameraViewController.m
//  wowo
//
//  Created by Donal on 13-8-20.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import "WaterCameraViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WaterCameraViewController () <AVCamCaptureManagerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    UIView *menuView;
    UIView *operateView;
    UIButton *takePhotoButton;
    UIImageView *stillImageView;
    UIButton *retakePhotoButton;
    UIImage *finishedImage;
    
    AVCamCaptureManager *_captureManager;
    UIView *videoPreviewView;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    
    UIScrollView *waterScrollView;
    UIPageControl *waterPageControl;
    
    UIView *touchView;
    
    UIView *waterMarkView2;
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
//- (void)updateButtonStates;

@end

@implementation WaterCameraViewController

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
    CGFloat widthScale = frame.size.width / videoPreviewView.frame.size.width;
    CGFloat heightScale = frame.size.height / videoPreviewView.frame.size.height;
    CGFloat xScale = frame.origin.x / videoPreviewView.frame.size.width;
    CGFloat yScale = frame.origin.y / videoPreviewView.frame.size.height;
    CGRect subFrame = CGRectMake(xScale * superSize.width, yScale * superSize.height, widthScale * superSize.width, heightScale * superSize.height);
    
    UIGraphicsBeginImageContext(superSize);
    [superImage drawInRect:CGRectMake(0, 0, superSize.width, superSize.height)];
    [subImage drawInRect:subFrame];
    __autoreleasing UIImage *finish = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finish;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureStillImage
{
    if (retakePhotoButton.superview == operateView) {
        
//        CGFloat pageWidth = waterScrollView.frame.size.width;
//        int page = floor((waterScrollView.contentOffset.x-pageWidth/100)/pageWidth)+1;
        UIImage *waterMark = [self captureView:self.view];
//        debugLog(@"%i",page);
//        UIImage *composedImage = [self composeImage:waterMarkView toImage:finishedImage atFrame:CGRectMake(0, 0, screenframe.size.width, videoPreviewView.frame.size.height)];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[waterMark CGImage]
                                  orientation:(ALAssetOrientation)[waterMark imageOrientation]
                              completionBlock:^(NSURL *assetURL, NSError *error) {
                                  if (error) {
                                      
                                  }
                                  else {
                                      debugLog(@"dfdf");
                                  }
                              }];
    }
    else {
        // Capture a still image
        [takePhotoButton setEnabled:NO];
        [_captureManager captureStillImage];
        
        // Flash the screen white and fade it out to give UI feedback that a still image was taken
        UIView *flashView = [[UIView alloc] initWithFrame:[videoPreviewView frame]];
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [[self view] addSubview:flashView];
        
        [UIView animateWithDuration:.4f
                         animations:^{
                             [flashView setAlpha:0.f];
                         }
                         completion:^(BOOL finished){
                             [flashView removeFromSuperview];
                         }
         ];
    }
}

-(void)retakePhoto
{
    [_captureManager.session startRunning];
    [stillImageView setImage:nil];
    [stillImageView setHidden:YES];
    finishedImage = nil;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [retakePhotoButton setAlpha:0.0f];
    [retakePhotoButton.layer addAnimation:animation forKey:@"ApushOut"];
    [retakePhotoButton performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

-(void)setUI
{
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, 44)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, menuView.frame.size.height)];
    [bg setImage:[UIImage imageNamed:@"timelineMenuBackground.png"]];
    [menuView addSubview:bg];
   
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 8, 35, 29)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"menuButtonDefault.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"menuButtonActive.png"] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"spacelistButton.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:leftButton];
    
    operateView = [[UIView alloc] initWithFrame:CGRectMake(0, screenframe.size.height-StatusBarHeight-50, screenframe.size.width, 50)];
    takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [takePhotoButton setFrame:CGRectMake((operateView.frame.size.width-72)/2, 11, 72, 28)];
    [takePhotoButton addTarget:self action:@selector(captureStillImage) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:takePhotoButton];
    
    retakePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retakePhotoButton setFrame:CGRectMake(10, 11, 72, 28)];
    [retakePhotoButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
//    [operateView addSubview:retakePhotoButton];
    
    videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    [videoPreviewView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:videoPreviewView];
    
    stillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    [stillImageView setHidden:YES];
//    [stillImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [stillImageView setClipsToBounds:YES];
    [self.view addSubview:stillImageView];
    
    waterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, screenframe.size.height-StatusBarHeight-44-50)];
    [waterScrollView setBouncesZoom:YES];
    [waterScrollView setScrollEnabled:YES];
    [waterScrollView setPagingEnabled:YES];
    [waterScrollView setDelegate:self];
    [waterScrollView setBackgroundColor:[UIColor clearColor]];
    [waterScrollView setShowsHorizontalScrollIndicator:NO];
    [waterScrollView setContentSize:CGSizeMake(screenframe.size.width*2, screenframe.size.height-StatusBarHeight-44-50)];
    
    waterPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((screenframe.size.width-38)/2, screenframe.size.height-StatusBarHeight-44-18-50, 38, 36)];
    [waterPageControl setNumberOfPages:2];
    [waterPageControl setCurrentPage:0];
    [self.view addSubview:waterPageControl];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 50, 30, 30)];
    [image2 setImage:[UIImage imageNamed:@"MySpaceCoverDefault.png"]];
    [waterScrollView addSubview:image2];
}

-(void)setWaterMarkView
{
    UIView *waterMarkView1 = [[UIView alloc] initWithFrame:CGRectMake(screenframe.size.width*0, 0, screenframe.size.width, waterScrollView.frame.size.height)];
    [waterMarkView1 setBackgroundColor:[UIColor clearColor]];
    [waterMarkView1 setTag:100];
    [waterScrollView addSubview:waterMarkView1];
    
    waterMarkView2 = [[UIView alloc] initWithFrame:CGRectMake(screenframe.size.width*1, 0, screenframe.size.width, waterScrollView.frame.size.height)];
    [waterMarkView2 setBackgroundColor:[UIColor clearColor]];
    [waterMarkView2 setTag:101];
    [waterScrollView addSubview:waterMarkView2];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 30, 30)];
    [image2 setImage:[UIImage imageNamed:@"MySpaceCoverDefault.png"]];
    [waterMarkView2 addSubview:image2];
}

- (void)addHollowOpenToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"cameraIrisHollowOpen";
    [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)addHollowCloseToView:(UIView *)view
{
    CATransition *animation = [CATransition animation];//初始化动画
    animation.duration = 0.5f;//间隔的时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIrisHollowClose";
    
    [view.layer addAnimation:animation forKey:@"HollowClose"];
}

- (void)dealloc
{
	[_captureManager.session stopRunning];
    [_captureManager setDelegate:nil];
    finishedImage = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addHollowOpenToView:videoPreviewView];
    if (menuView.superview != self.view) 
        [self.view addSubview:menuView];
    if (waterScrollView.superview != self.view) 
        [self.view addSubview:waterScrollView];
    if (operateView.superview != self.view) 
        [self.view addSubview:operateView];
}

- (void)viewDidLoad
{
    [self setUI];
	if ( _captureManager == nil) {
		_captureManager = [[AVCamCaptureManager alloc] init];
		[_captureManager setDelegate:self];
        
		if ([_captureManager setupSession]) {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[_captureManager session]];
			UIView *view = videoPreviewView;
			CALayer *viewLayer = [view layer];
//			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
//           if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
//               [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
//           }
			
//			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			captureVideoPreviewLayer = newCaptureVideoPreviewLayer;
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[_captureManager.session startRunning];
			});
			
//            [self updateButtonStates];
            
            // Add a single tap gesture to focus on the point tapped, then lock focus
			UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
			[singleTap setDelegate:self];
			[singleTap setNumberOfTapsRequired:1];
			[waterScrollView addGestureRecognizer:singleTap];
			
            // Add a double tap gesture to reset the focus mode to continuous auto focus
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
			[doubleTap setDelegate:self];
			[doubleTap setNumberOfTapsRequired:2];
			[singleTap requireGestureRecognizerToFail:doubleTap];
			[waterScrollView addGestureRecognizer:doubleTap];
            
            touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            CALayer * layer = [touchView layer];
            layer.borderColor = [[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1] CGColor];
            layer.borderWidth = 1.0f;
            touchView.clipsToBounds=TRUE;
            [touchView setHidden:YES];
            [view addSubview:touchView];
		}
	}
    
    [super viewDidLoad];
}

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = videoPreviewView.frame.size;
    
    //    if ([captureVideoPreviewLayer isMirrored]) {
    //        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    //    }
    
    if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[_captureManager videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

-(void)hideTouchView
{
    touchView.hidden = YES;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:videoPreviewView];
    
    [touchView setFrame:CGRectMake(tapPoint.x-40, tapPoint.y-40, 80, 80)];
    [touchView setHidden:NO];
    [self performSelector:@selector(hideTouchView) withObject:nil afterDelay:1];

    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [_captureManager autoFocusAtPoint:convertedFocusPoint];
    }
    if ([[[_captureManager videoInput] device] isExposurePointOfInterestSupported]) {
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [_captureManager autoExposureAtPoint:convertedFocusPoint];
    }
    
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[_captureManager videoInput] device] isFocusPointOfInterestSupported])
        [_captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
    
    if ([[[_captureManager videoInput] device] isExposurePointOfInterestSupported])
        [_captureManager continuousExposureAtPoint:CGPointMake(.5f, .5f)];
    
}

#pragma mark AvCamManagerDelegate
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        
    });
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager StillImage:(UIImage *)image
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [takePhotoButton setEnabled:YES];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [retakePhotoButton setAlpha:1.0f];
        [retakePhotoButton.layer addAnimation:animation forKey:@"ApushIn"];
        [operateView addSubview:retakePhotoButton];
        [stillImageView setImage:image];
        [stillImageView setHidden:NO];
        finishedImage = image;
        [_captureManager.session stopRunning];
        debugLog(@"%f,%f",image.size.width,image.size.height);
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
    
}

- (void) captureManagerDeviceOrientationChange:(AVCamCaptureManager *)captureManager withOrientation:(UIDeviceOrientation)orientation
{
//    if (orientation == UIDeviceOrientationPortrait) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        recordButton.transform=CGAffineTransformIdentity;
//        recordButton.transform=CGAffineTransformMakeRotation(2*M_PI);
//        [UIView commitAnimations];
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        changeCameraButton.transform=CGAffineTransformIdentity;
//        changeCameraButton.transform=CGAffineTransformMakeRotation(2*M_PI);
//        [UIView commitAnimations];
//    }
//	else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        recordButton.transform=CGAffineTransformIdentity;
//        recordButton.transform=CGAffineTransformMakeRotation(-M_PI);
//        [UIView commitAnimations];
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        changeCameraButton.transform=CGAffineTransformIdentity;
//        changeCameraButton.transform=CGAffineTransformMakeRotation(-M_PI);
//        [UIView commitAnimations];
//    }
//	else if (orientation == UIDeviceOrientationLandscapeLeft) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        recordButton.transform=CGAffineTransformIdentity;
//        recordButton.transform=CGAffineTransformMakeRotation(M_PI/2.0);
//        [UIView commitAnimations];
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        changeCameraButton.transform=CGAffineTransformIdentity;
//        changeCameraButton.transform=CGAffineTransformMakeRotation(M_PI/2.0);
//        [UIView commitAnimations];
//        
//    }
//	else if (orientation == UIDeviceOrientationLandscapeRight) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        recordButton.transform=CGAffineTransformIdentity;
//        recordButton.transform=CGAffineTransformMakeRotation(-M_PI/2.0);
//        [UIView commitAnimations];
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:ViewRotationDuration];
//        [UIView setAnimationDelegate:self];
//        changeCameraButton.transform=CGAffineTransformIdentity;
//        changeCameraButton.transform=CGAffineTransformMakeRotation(-M_PI/2.0);
//        [UIView commitAnimations];
//        
//    }
}

#pragma mark scrollView Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x-pageWidth/100)/pageWidth)+1;
    [waterPageControl setCurrentPage:page];
}

@end
