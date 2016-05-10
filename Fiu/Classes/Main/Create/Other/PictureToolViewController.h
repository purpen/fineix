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

/*
 *  创建的类型
 *  @param  scene   场景
 *  @param  fScene  情景
 */
@pro_strong NSString            *   createType;
@pro_strong NSString            *   fSceneId;
@pro_strong NSString            *   fSceneTitle;

@end
