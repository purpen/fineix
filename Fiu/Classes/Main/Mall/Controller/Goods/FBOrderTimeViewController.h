//
//  FBOrderTimeViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

typedef void(^GetSendGoodsTimeBlock)(NSString * time, NSString * type);

@interface FBOrderTimeViewController : FBViewController

@pro_strong GetSendGoodsTimeBlock   getSendTimeBlock;

@end
