//
//  VKWebConnect.h
//  MOMOKA
//
//  Created by Mai kinkee on 13-1-3.
//  Copyright (c) 2013年 Mai kinkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"
@class ASIDownloadCache;
@interface VKWebConnect : NSObject<UIAlertViewDelegate,ASIProgressDelegate>
{
    int loadingViewNum;
}

@property (nonatomic,retain) NSOperationQueue *NetQueue;
@property (nonatomic,retain) ASIDownloadCache *PicDownCache;
@property (retain,nonatomic) NSMutableArray *downLoadImageList;
@property (nonatomic,assign) id downImageDelegate;

-(void)addNetWorkConnect:(NSString*)link data:(NSDictionary*)data delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
-(void)addPicLink:(NSString*)link key:(NSString*)key delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
-(void)addPicLink:(NSString*)link key:(NSString*)key delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel;
-(void)downLoadTheRecord:(NSString*)link path:(NSString*)path delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel cell:(UITableViewCell*)cell;

-(void)updataRecord:(NSString*)link data:(NSDictionary*)data filePath:(NSString*)filePath delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
-(void)updataRecord:(NSString*)link data:(NSDictionary*)data filePath:(NSString*)filePath delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel;

-(void)uploadPhoto:(NSString*)link data:(NSDictionary*)data fileData:(NSData *)fileData delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
-(void)uploadPhoto:(NSString*)link data:(NSDictionary*)data fileData:(NSData *)fileData delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel;

-(void)CancleNetWorkWithDelegate:(id)delegate;

-(void)postComment:(NSString*)link key:(NSString*)key data:(NSDictionary*)data delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
@end
