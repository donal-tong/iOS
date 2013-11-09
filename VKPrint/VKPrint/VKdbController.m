//
//  VKdbController.m
//  MOMOKA
//
//  Created by Mai kinkee on 12-12-27.
//  Copyright (c) 2012年 Mai kinkee. All rights reserved.
//

#import "VKdbController.h"
//#import "FMDatabase.h"
#define BaseSQLiteName @"baseSql.sqlite"
@implementation VKdbController



+(NSString*)getDataFilePathWithName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
    return path;
}


+(void)AppBeginCreat
{
    
    NSString *filePath=[VKdbController getDataFilePathWithName:BaseSQLiteName];    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath] == NO) {
        [fileManager createDirectoryAtPath:[VKdbController getDataFilePathWithName:@"record"] withIntermediateDirectories:YES attributes:nil error:nil];
//        FMDatabase * db = [FMDatabase databaseWithPath:filePath];
//        if ([db open]) {
//            NSString * sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
//            BOOL res = [db executeUpdate:sql];
//            if (!res) {
//                NSLog(@"error when creating db table");
//            } else {
//                NSLog(@"succ to creating db table");
//            }
//            [db close];
//        } else {
//            NSLog(@"error when open db");
//        }
    }
    else
    {
         NSLog(@"db Exists");
    }
}


@end
