//
//  AppDelegate.h
//  fineix
//
//  Created by xiaoyi on 16/2/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FBViewController.h"
#import "WXApi.h"

@protocol AlipayDelegate <NSObject>

- (void)standbyCallbackWithResultDic:(NSDictionary *)resultDic;

@end

@protocol NotificationDelege <NSObject>

@optional
- (void)resetNotificationState;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, weak) id<NotificationDelege> notiDelegate;
@property (nonatomic, weak) id<WXApiDelegate> wxDelegate;
@property (nonatomic, weak) id<AlipayDelegate> aliDelegate;

@end

