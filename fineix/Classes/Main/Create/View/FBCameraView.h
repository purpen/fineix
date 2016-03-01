//
//  FBCameraView.h
//  fineix
//
//  Created by FLYang on 16/2/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@interface FBCameraView : UIView

@pro_strong UIViewController    *   VC;
@pro_strong UIView      *   cameraNavView;      //  顶部导航
@pro_strong UIButton    *   cameraCancelBtn;    //  取消按钮
@pro_strong UILabel     *   cameraTitlt;        //  页面标题

@end
