//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Donal on 13-6-15.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MLNavigationController : UINavigationController

@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL canDragBack;

-(void)setCanDragBack:(BOOL)canDragBack;

- (UIPanGestureRecognizer*)panGestureRecognizer;

@property (strong, nonatomic) NSString *devToken;

@end
