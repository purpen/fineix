//
//  MapAnnotionViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/7/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

@interface MapAnnotionViewController : FBPictureViewController

/** 第一个地理位置名字 */
@property(nonatomic,copy) NSString *firstName;
/** 纬度 */
@property (nonatomic, assign) double lat;
/** 经度 */
@property (nonatomic, assign) double lon;

@end
