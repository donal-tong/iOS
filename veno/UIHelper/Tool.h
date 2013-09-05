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

@interface Tool : NSObject

+ (void)playSoundIDwithFileID:(NSString *)FileId inDirectory:(NSString *)Directory withType:(NSString *)type;
+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt;
+(int)getTextViewWitdthWithUIFont:(UIFont *)font andText:(NSString *)txt ;
+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt andTextWidth:(int)width ;
+(CGSize)getTextViewSizeWithUIFont:(UIFont *)font andText:(NSString *)txt andWidth:(int)width andHeight:(int)height;

+ (NSString *)sha1:(NSString *)str;
//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;
//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (NSString *)md5:(NSString *)str;

+ (NSString*)getTimeStamp;//获取当前时间戳
+ (NSString*)phplong2Data:(NSString*)dateNumber;//将php的时间戳转换为date
+(NSString*)phplong2Data:(NSString *)dateNumber with:(NSString *)dateFormat;
+ (NSString *)intervalSinceNow: (NSString *) theDate;//友好时间
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSString*)resolveSinaWeiboDate:(NSString*)date;


+(NSString*)returnDataFilePath:(NSString*)fileName;
+(BOOL)saveDataIntoFile:(NSObject*)obj key:(NSString*)key fileName:(NSString*)fileName;
+(NSObject*)readDataFromFile:(NSString*)fileName key:(NSString*)key;

+(NSString*)returnVideoFileDocument;
+(NSString*)returnVideoFilePath:(NSString*)fileName;
+(BOOL)deleteVideoFile:(NSString *)Path;

+(NSString*)returnCompressedPhotoFilePath:(NSString*)fileName;
    
+(NSString*)returnRecordFilePath:(NSString*)fileName;
+(NSString*)returnImageFilePath;

+(BOOL)deleteRecordFile:(NSString *)Path;

//image corner
+(void) addRoundedRectToPath:(CGContextRef) context : (CGRect) rect : (float) ovalWidth : (float) ovalHeight;
+(UIImage *)roundCornersOfImage:(UIImage *)source OvalWidth:(float)width OvalHeight:(float)height;

+(void)saveImageInAlbum:(UIImage*)image;

+(NSString *) platformString;
@end
