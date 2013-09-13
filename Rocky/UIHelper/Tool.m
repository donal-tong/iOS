//
//  Tool.m
//  VPlus
//
//  Created by Donal on 13-5-22.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>

#define TextWidth 290
#define ImageFilePathName @"WOWOFile"

@implementation Tool

#pragma mark ——————————声音播放——————————

+ (BOOL)CreateSoundFileID:(NSString *)name withType:(NSString *)type SoundID:(SystemSoundID *)soundID inDirectory:(NSString *)directory
{
    BOOL bret = NO;
    id sndpath = [[NSBundle mainBundle]
                  pathForResource:name
                  ofType:type
                  inDirectory:directory];
    CFURLRef baseURL = (CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:sndpath]);
    
    if( AudioServicesCreateSystemSoundID (baseURL, soundID) )
    {
        bret = YES;
    }
    return bret;
}

+ (void)playSoundIDwithFileID:(NSString *)FileId inDirectory:(NSString *)Directory withType:(NSString *)type
{
    SystemSoundID soundID;
    if (![self CreateSoundFileID:FileId withType:type SoundID:&(soundID) inDirectory:Directory]) {
        NSLog(@"读取声音失败" );
    }
    AudioServicesPlaySystemSound(soundID);
}

+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt {
    CGSize constraint = CGSizeMake(TextWidth, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height;
    return fHeight;
}

+(int)getTextViewHeightWithUIFont:(UIFont *)font andText:(NSString *)txt andTextWidth:(int)width {
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height ;
    return fHeight;
}

+(int)getTextViewWitdthWithUIFont:(UIFont *)font andText:(NSString *)txt {
    CGSize constraint = CGSizeMake(100, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float width = size.width;
    return width;
}

+(CGSize)getTextViewSizeWithUIFont:(UIFont *)font andText:(NSString *)txt andWidth:(int)width andHeight:(int)height {
    CGSize constraint = CGSizeMake(width, height);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size;
}

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString*)getTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

+(NSString*)phplong2Data:(NSString *)dateNumber
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[dateNumber intValue]];
    NSString *dateString=[DateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else
    {
        timeString = theDate;
    }
    return timeString;
}

//解析新浪微博中的日期
+ (NSString*)resolveSinaWeiboDate:(NSString*)date{
	NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date1 = [iosDateFormater dateFromString:date];
    return [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
}

/*
 *日期转化为日期格式的字符串
 */
+(NSString*)NSDateToNSString:(NSDate*)date withFormatter:(NSDateFormatter*)formatter{
	NSString	*dateString=[formatter stringFromDate:date];
	return dateString;
}

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


+(VKWebConnect *) getTheWebConnect
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.webConnect;
}

+(MLNavigationController *) getNavigationController
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app.navigation;
}


+(NSString*)returnRecordFilePath:(NSString*)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc=[paths objectAtIndex:0];
    NSString *filePath=[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"record%@",fileName]];
    return filePath;
}

+(NSString*)returnImageFilePath
{
    NSString *homePath=[[NSBundle mainBundle] executablePath];
    NSArray *strings=[homePath componentsSeparatedByString:@"/"];
    NSString *executableName=[strings objectAtIndex:[strings count]-1];
    NSString *baseDir=[homePath substringToIndex:[homePath length]-[executableName length]-1];
    NSString *resourePath=[NSString stringWithFormat:@"%@/%@",baseDir,ImageFilePathName];
    return resourePath;
}

//image corner
+(void) addRoundedRectToPath:(CGContextRef) context : (CGRect) rect : (float) ovalWidth : (float) ovalHeight{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)roundCornersOfImage:(UIImage *)source OvalWidth:(float)width OvalHeight:(float)height
{
    int w = source.size.width;
    int h = source.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    [self addRoundedRectToPath:context :rect :width :height];
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}

+(NSString *) platformString {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    else if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    else if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    else if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    else if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    else if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    else if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    else if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    else if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    else if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    else if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    else if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    else if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    else if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    else if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    else if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    else if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    else if ([platform isEqualToString:@"i386"])         return @"Simulator";
    else if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

@end

