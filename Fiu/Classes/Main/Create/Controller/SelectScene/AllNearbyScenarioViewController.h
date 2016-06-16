//
//  AllNearbyScenarioViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "Fiu.h"
typedef void(^DismissVC)();

@interface AllNearbyScenarioViewController : FBPictureViewController

/**
 *  选择类型
 *  edit    ：编辑
 *  release ：发布
 */
@pro_strong NSString    *   type;
@pro_strong UIButton    *   sureBtn;    //  确定按钮
@pro_copy   DismissVC       dismissVC;

@end
