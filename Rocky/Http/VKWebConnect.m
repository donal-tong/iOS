//
//  VKWebConnect.m
//  MOMOKA
//
//  Created by Mai kinkee on 13-1-3.
//  Copyright (c) 2013年 Mai kinkee. All rights reserved.
//

#import "VKWebConnect.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "VKConnectObj.h"
#import "ASIDownloadCache.h"
#import "Tool.h"

#define webLinkType 1
#define updataRecordType 2

@implementation VKWebConnect
{
    NSMutableDictionary *reConnectData;
    int wrongNum;
}

@synthesize PicDownCache;
@synthesize downLoadImageList;
@synthesize downImageDelegate;
@synthesize NetQueue;

-(void)dealloc
{
    [downLoadImageList release];
    [PicDownCache release];
    [reConnectData release];
    [super dealloc];
}


-(id)init
{
    self=[super init];
    if(self)
    {
        loadingViewNum=0;
        NSOperationQueue *qe=[[NSOperationQueue alloc] init];
        self.NetQueue=qe;
        [qe release];
        self.NetQueue.maxConcurrentOperationCount=5;
        
        NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:0];
        self.downLoadImageList=array;
        [array release];
        
        wrongNum=0;
        reConnectData=[[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(void)addNetWorkConnect:(NSString*)link data:(NSDictionary*)data delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    //暂存数据用以重新连接
    
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    
    if(data==nil)
    {
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nsurl];
        [request setDelegate:self];        
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
        request.userInfo= dic;
        request.useSessionPersistence = YES;
        [self.NetQueue addOperation:request];
        [dic release];
    }
    else{        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];        
        [request setDelegate:self];
        for (id key in data) {            
            [request setPostValue:[data objectForKey:key] forKey:key];
        }
        NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
        request.userInfo= dic;
        request.useSessionPersistence = YES;
        [self.NetQueue addOperation:request];
        [dic release];
    }
    [obj release];
    [nsurl release];
}


-(void)requestStarted:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate != nil)
    {
        if([dic.delegate respondsToSelector:dic.sel])
        {
            [dic.delegate performSelector:dic.sel withObject:request.responseData];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.wsel])
        {
            [dic.delegate performSelector:dic.wsel] ;
        }
    }
}

-(void)requestFailedUploadPhoto:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.wsel])
        {
            [dic.delegate performSelector:dic.wsel];
        }
    }
}

-(void)requestFailedUploadVoice:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.wsel])
        {
            [dic.delegate performSelector:dic.wsel];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ASIHTTPRequest *re=[reConnectData objectForKey:[NSString stringWithFormat:@"%i",alertView.tag]];
    if(buttonIndex!=[alertView cancelButtonIndex])
    {
        NSDictionary *userinfo=re.userInfo;
        VKConnectObj *dic=[userinfo objectForKey:@"infoObj"];
        NSString *link=[NSString stringWithFormat:@"%@",re.url];
        int type=[[userinfo objectForKey:@"type"] intValue];
        if(type==webLinkType)
        {
            [self addNetWorkConnect:link data:[userinfo objectForKey:@"data"] delegate:dic.delegate sel:dic.sel wsel:dic.wsel];
        }
        else
        {
            [self updataRecord:link data:[userinfo objectForKey:@"data"] filePath:[userinfo objectForKey:@"filePath"] delegate:dic.delegate sel:dic.sel wsel:dic.wsel];
        }        
    }    
    [reConnectData removeObjectForKey:[NSString stringWithFormat:@"%i",alertView.tag]];
}


-(void)addPicLink:(NSString*)link key:(NSString*)key delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    if(![link hasPrefix:@"http://"])
    {
        link=[VKWebSite stringByAppendingString:link];
    }
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    if (nsurl == nil) {
        return;
    }
    [self.downLoadImageList addObject:nsurl];
    
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=key;
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nsurl];
    request.delegate=self;
    [request setDidFinishSelector:@selector(picLoadFinish:)];
    [request setDidFailSelector:@selector(picLoadFail:)];
    request.useSessionPersistence = YES;
    if(!self.PicDownCache)
    {
        [self creatDownloadCache];
    }
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadCache:self.PicDownCache];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)addPicLink:(NSString*)link key:(NSString*)key delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel
{
    if(![link hasPrefix:@"http://"])
    {
        link=[VKWebSite stringByAppendingString:link];
    }
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    
    [self.downLoadImageList addObject:nsurl];
    
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=key;
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:nsurl];
    request.delegate=self;
    request.downloadProgressDelegate = progressDelegate;
    request.showAccurateProgress = YES;
    request.useSessionPersistence = YES;
    [request setDidFinishSelector:@selector(picLoadFinish:)];
    [request setDidFailSelector:@selector(picLoadFail:)];
    if(!self.PicDownCache)
    {
        [self creatDownloadCache];
    }
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDownloadCache:self.PicDownCache];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)creatDownloadCache
{
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.PicDownCache = cache;
    [cache release];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.PicDownCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"CachePic"]];
    [self.PicDownCache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
}

/*读取图片*/
-(void)picLoadFinish:(ASIHTTPRequest *)request
{
    [self.downLoadImageList removeObject:request.url];
    
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([request responseStatusCode] == 200 || [request responseStatusCode] == 304){
        if([dic.delegate respondsToSelector:dic.sel] && request.responseData.length>0)
        {
            [dic.delegate performSelector:dic.sel withObject:request.responseData withObject:dic.key];
        }
        else
        {
            [request setSecondsToCache:0];
        }
    }
}

-(void)picLoadFail:(ASIHTTPRequest *)request
{
    [self.downLoadImageList removeObject:request.url];
    
    if([request.error code]!=4 &&  [request.error code]!=2)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];       
//        UIAlertView *ac=[[UIAlertView alloc] initWithTitle:@"出错" message:[NSString stringWithFormat:@"%@",request.error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [ac show];
//        [ac release];
    }
}

-(void)downLoadTheRecord:(NSString*)link path:(NSString*)path delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel cell:(UITableViewCell*)cell;
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    if([self.downLoadImageList containsObject:nsurl])
    {
        [nsurl release];
        return;
    }
    else
        [self.downLoadImageList addObject:nsurl];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=path;
    obj.ChildDelegate=cell;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL :nsurl];
    request.delegate=self;
    [request setDidFinishSelector:@selector(downLoadRecordComplete:)];
    [request setDidFailSelector:@selector(RecordrequestFailed:)];
    [request setDownloadDestinationPath :[Tool returnRecordFilePath:path]];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];

    [obj release];
    [nsurl release];
}

-(void)downLoadTheRecord:(NSString*)link path:(NSString*)path delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel;
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    if([self.downLoadImageList containsObject:nsurl])
    {
        [nsurl release];
        return;
    }
    else
        [self.downLoadImageList addObject:nsurl];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=path;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL :nsurl];
    request.delegate=self;
    [request setDidFinishSelector:@selector(downLoadRecordComplete:)];
    [request setDidFailSelector:@selector(RecordrequestFailed:)];
    [request setDownloadDestinationPath :[Tool returnRecordFilePath:path]];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    
    [obj release];
    [nsurl release];
}

-(void)RecordrequestFailed:(ASIHTTPRequest *)request
{
    [self.downLoadImageList removeObject:request.url];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.sel])
        {
            [dic.delegate performSelector:dic.sel withObject:dic.key withObject:dic.ChildDelegate];
        }
    }
}

-(void)downLoadRecordComplete:(ASIHTTPRequest *)request
{
    [self.downLoadImageList removeObject:request.url];
    
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.sel])
        {
            [dic.delegate performSelector:dic.sel withObject:dic.key withObject:dic.ChildDelegate];
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)updataRecord:(NSString*)link data:(NSDictionary*)data filePath:(NSString*)filePath delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    request.delegate=self;
    request.uploadProgressDelegate=self;
    request.showAccurateProgress=YES;
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailedUploadVoice:)];
    for (id key in data) {
        [request setPostValue:[data objectForKey:key] forKey:key];
    }
    [request addFile:filePath forKey:@"Filedata"];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",filePath,@"filePath",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)updataRecord:(NSString*)link data:(NSDictionary*)data filePath:(NSString*)filePath delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    request.delegate=self;
    request.uploadProgressDelegate=progressDelegate;
    request.showAccurateProgress=YES;
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailedUploadVoice:)];
    for (id key in data) {
        [request setPostValue:[data objectForKey:key] forKey:key];
    }
    [request addFile:filePath forKey:@"Filedata"];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",filePath,@"filePath",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)uploadPhoto:(NSString*)link data:(NSDictionary*)data fileData:(NSData *)fileData delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    request.delegate=self;
    request.uploadProgressDelegate=self;
    request.showAccurateProgress=YES;
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailedUploadPhoto:)];
    for (id key in data) {
        [request setPostValue:[data objectForKey:key] forKey:key];
    }
    [request addData:fileData forKey:@"Filedata"];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",fileData,@"Filedata",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)uploadPhoto:(NSString*)link data:(NSDictionary*)data fileData:(NSData *)fileData delegate:(id)delegate progressDelegate:(id)progressDelegate sel:(SEL)select wsel:(SEL)wsel
{
    [self CancleNetWorkWithDelegate:delegate];
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    request.delegate=self;
    request.uploadProgressDelegate=progressDelegate;
    request.showAccurateProgress=YES;
    [request setShouldAttemptPersistentConnection:NO];
    [request setPersistentConnectionTimeoutSeconds:180];
    [request setTimeOutSeconds:180];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailedUploadPhoto:)];
    for (id key in data) {
        [request setPostValue:[data objectForKey:key] forKey:key];
    }
    [request addData:fileData forKey:@"Filedata"];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",fileData,@"Filedata",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
    request.userInfo= dic;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)CancleNetWorkWithDelegate:(id)delegate
{
    debugLog(@"return");
    for (ASIHTTPRequest *rq in [self.NetQueue operations]) {
        if([(VKConnectObj*)[rq.userInfo objectForKey:@"infoObj"] delegate]==delegate)
        {
            [rq clearDelegatesAndCancel];
        }
    }
}

#pragma mark comment weibo 
-(void)postComment:(NSString*)link key:(NSString*)key data:(NSDictionary*)data delegate:(id)delegate sel:(SEL)select wsel:(SEL)wsel
{
    NSURL *nsurl=[[NSURL alloc] initWithString:link];
    if (nsurl == nil) {
        return;
    }
    VKConnectObj *obj=[[VKConnectObj alloc] init];
    obj.delegate=delegate;
    obj.sel=select;
    obj.wsel=wsel;
    obj.key=key;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:nsurl];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(postCommentFinished:)];
    [request setDidFailSelector:@selector(postCommentFailed:)];
    for (id key in data) {
        [request setPostValue:[data objectForKey:key] forKey:key];
    }
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:obj,@"infoObj",data,@"data",[NSString stringWithFormat:@"%i",webLinkType],@"type",nil];
    request.userInfo= dic;
    request.useSessionPersistence = YES;
    [self.NetQueue addOperation:request];
    [dic release];
    [obj release];
    [nsurl release];
}

-(void)postCommentFinished:(ASIHTTPRequest *)request
{
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate != nil)
    {
        if([dic.delegate respondsToSelector:dic.sel])
        {
            [dic.delegate performSelector:dic.sel withObject:request.responseData withObject:dic.key];
        }
    }
}

-(void)postCommentFailed:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VKConnectObj *dic=[request.userInfo objectForKey:@"infoObj"];
    if(dic.delegate!=nil)
    {
        if([dic.delegate respondsToSelector:dic.wsel])
        {
            [dic.delegate performSelector:dic.wsel withObject:dic.key] ;
        }
    }
}

@end
