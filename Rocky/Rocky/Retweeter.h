//
//  Retweeter.h
//  Rocky
//
//  Created by Donal on 13-8-8.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Retweeter : NSManagedObject

@property (nonatomic, retain) NSString * twitterID;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * isAt;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * retweeterID;

@end
