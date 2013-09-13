//
//  Tool.h
//  VPlus
//
//  Created by Donal on 13-5-22.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "VKWebConnect.h"
#import "MLNavigationController.h"

@interface Tool : NSObject

+ (void)playSoundIDwithFileID:(NSString *)FileId inDirectory:(NSString *)Directory withType:(NSString *)type;
+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt;
+(int)getTextViewWitdthWithUIFont:(UIFont *)font andText:(NSString *)txt ;
+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt andTextWidth:(int)width ;
+(CGSize)getTextViewSizeWithUIFont:(UIFont *)font andText:(NSString *)txt andWidth:(int)width andHeight:(int)height;

+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5:(NSString *)str;

+ (NSString*)getTimeStamp;
+ (NSString*)phplong2Data:(NSString*)dateNumber;//将php的时间戳转换为date
+ (NSString *)intervalSinceNow: (NSString *) theDate;//友好时间
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSString*)resolveSinaWeiboDate:(NSString*)date;

+(VKWebConnect *) getTheWebConnect;
+(MLNavigationController *) getNavigationController;
//+(TabBarViewController *) getTabController;

+(NSString*)returnRecordFilePath:(NSString*)fileName;
+(NSString*)returnImageFilePath;

+(void) addRoundedRectToPath:(CGContextRef) context : (CGRect) rect : (float) ovalWidth : (float) ovalHeight;
+(UIImage *)roundCornersOfImage:(UIImage *)source OvalWidth:(float)width OvalHeight:(float)height;

+(NSString *) platformString;
@end
