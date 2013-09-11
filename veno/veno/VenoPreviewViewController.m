//
//  VinoPreviewViewController.m
//  veno
//
//  Created by Donal on 13-9-7.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "VenoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>

/* PlayerItem keys */
NSString * const kStatusKey         = @"status";

/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";

@interface VenoPreviewViewController () <UIActionSheetDelegate>
{
    UIView *preView;
    AVPlayer *player;
    AVPlayerItem *playerItem;
}
@end

static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@implementation VenoPreviewViewController

-(void)back
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete post" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(void)setUI
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenframe.size.width, 44)];
    [menuView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:menuView];
    
    UIButton *actionCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionCancelButton setFrame:CGRectMake(0, 0, 44, 44)];
    [actionCancelButton setBackgroundImage:[UIImage imageNamed:@"ActionCancelDefault.png"] forState:UIControlStateNormal];
    [actionCancelButton setBackgroundImage:[UIImage imageNamed:@"ActionCancelPressed.png"] forState:UIControlStateHighlighted];
    [actionCancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:actionCancelButton];
    
    preView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenframe.size.width, 322)];
    [preView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:preView];
    
}

-(void)preparePlay
{
    if (player) {
        [player removeObserver:self forKeyPath:kRateKey];
        [player removeObserver:self forKeyPath:kCurrentItemKey];
        player = nil;
    }
    if (playerItem) {
        [playerItem removeObserver:self forKeyPath:kStatusKey];
        playerItem = nil;
    }
    playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.videoFilePath]];
    
    [playerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
	
    
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = preView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [preView.layer addSublayer:playerLayer];
    [player play];
    [player addObserver:self
                  forKeyPath:kCurrentItemKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
    
    [player addObserver:self
                  forKeyPath:kRateKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self preparePlay];
}

-(void)dealloc
{
    if (player) {
        [player removeObserver:self forKeyPath:kRateKey];
        [player removeObserver:self forKeyPath:kCurrentItemKey];
        player = nil;
    }
    if (playerItem) {
        [playerItem removeObserver:self forKeyPath:kStatusKey];
        playerItem = nil;
    }
    self.videoFilePath = nil;
}

#pragma mark action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.delegate cancelPublishAndDeleteVideo];
    }
}

//#pragma mark Key Value Observer for player rate, currentItem, player item status
//
///* ---------------------------------------------------------
// **  Called when the value at the specified key path relative
// **  to the given object has changed.
// **  Adjust the movie play and pause button controls when the
// **  player item "status" value changes. Update the movie
// **  scrubber control when the player item is ready to play.
// **  Adjust the movie scrubber control when the player item
// **  "rate" value changes. For updates of the player
// **  "currentItem" property, set the AVPlayer for which the
// **  player layer displays visual output.
// **  NOTE: this method is invoked on the main queue.
// ** ------------------------------------------------------- */
//
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    /* AVPlayerItem "status" property value observer. */
	if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
	{
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
            }
                break;
                
            case AVPlayerStatusFailed:
            {
            }
                break;
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
	{
        [self syncPlayPause];
	}
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
	{
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            [player pause];
        }
        else /* Replacement of player currentItem has occurred */
        {
            [self syncPlayPause];
        }
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}

- (void)syncPlayPause
{
	if ([self isPlaying])
	{
	}
    else {
        [self preparePlay];
    }
}

- (BOOL)isPlaying
{
	return [player rate] != 0.f;
}



@end
