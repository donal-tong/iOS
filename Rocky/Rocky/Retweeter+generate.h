//
//  Retweeter+generate.h
//  Rocky
//
//  Created by Donal on 13-8-8.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "Retweeter.h"

@interface Retweeter (generate)

+(Retweeter *)saveRetweeter:(NSDictionary *)dataDic andTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context;

+(NSArray *)getRetweetersOfTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context;

+(Retweeter *)editRetweeter:(NSString *)retweeterID andTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
