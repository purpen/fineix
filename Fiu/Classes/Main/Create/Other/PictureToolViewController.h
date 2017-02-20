//
//  PictureToolViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface PictureToolViewController : UINavigationController

/**
 所属地盘id
 */
@property (nonatomic, strong) NSString *domainId;

/** 活动ID */
@pro_strong NSString *actionId;
/** 活动标题 */
@pro_strong NSString *activeTitle;

@end
