//
//  AppDelegate.h
//  wowo
//
//  Created by Donal on 13-7-16.
//  Copyright (c) 2013年 Donal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLNavigationController;
@class LookAroundViewController;
@class VKWebConnect;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MLNavigationController *navigation;
    LookAroundViewController *oauthVC;
    VKWebConnect *webConnect;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly,nonatomic) MLNavigationController *navigation;
@property (strong,nonatomic) LookAroundViewController *oauthVC;
@property (readonly,nonatomic) VKWebConnect *webConnect;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
