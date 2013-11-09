//
//  VKConnectObj.h
//  MOMOKA
//
//  Created by Mai kinkee on 13-1-3.
//  Copyright (c) 2013年 Mai kinkee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKConnectObj : NSObject

@property  (assign) SEL sel;
@property  (assign) SEL wsel;
@property  (nonatomic,assign) id delegate;
@property  (nonatomic,assign) id ChildDelegate;
@property  (nonatomic,retain) NSString *key;
@property  BOOL needLoading;
@end
