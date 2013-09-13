//
//  Retweeter+generate.m
//  Rocky
//
//  Created by Donal on 13-8-8.
//  Copyright (c) 2013年 vikaa. All rights reserved.
//

#import "Retweeter+generate.h"
#import "Tool.h"

@implementation Retweeter (generate)

+(Retweeter *)saveRetweeter:(NSDictionary *)dataDic andTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Retweeter *data = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retweeter"];
    request.predicate = [NSPredicate predicateWithFormat:@"retweeterID = %@ and twitterID = %@", [NSString stringWithFormat:@"%lld", [[[dataDic objectForKey:@"user"] objectForKey:@"id"] longLongValue]], twitterID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || matches.count > 1) {
        //handle error
        data = [matches lastObject];
    }
    else if (matches.count == 0) {
        data = [NSEntityDescription insertNewObjectForEntityForName:@"Retweeter" inManagedObjectContext:context];
        data.twitterID = twitterID;
        data.isAt = @"0";
        data.retweeterID = [NSString stringWithFormat:@"%lld", [[[dataDic objectForKey:@"user"] objectForKey:@"id"] longLongValue]];
        data.screen_name = [NSString stringWithFormat:@"@%@",[[dataDic objectForKey:@"user"] objectForKey:@"screen_name"]];
        data.created_at = [Tool resolveSinaWeiboDate:[dataDic objectForKey:@"created_at"]];
    }
    else {
        data = [matches lastObject];
    }
    return data;
}

+(NSArray *)getRetweetersOfTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retweeter"];
    request.predicate = [NSPredicate predicateWithFormat:@"twitterID = %@ and isAt = %@", twitterID, @"0"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if ([matches count] > 0)
        return matches;
    else
        return nil;
}

+(Retweeter *)editRetweeter:(NSString *)retweeterID andTwitterID:(NSString *)twitterID inManagedObjectContext:(NSManagedObjectContext *)context
{
    Retweeter *data = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retweeter"];
    request.predicate = [NSPredicate predicateWithFormat:@"retweeterID = %@ and twitterID = %@", retweeterID, twitterID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || matches.count > 1) {
        //handle error
        data = [matches lastObject];
        data.isAt = @"1";
        debugLog(@"%@",retweeterID);
    }
    else {
        data = [matches lastObject];
        data.isAt = @"1";
        debugLog(@"%@",retweeterID);
    }
    return data;
}

@end
