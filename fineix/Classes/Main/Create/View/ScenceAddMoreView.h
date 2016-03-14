//
//  ScenceAddMoreView.h
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@interface ScenceAddMoreView : UIView

@pro_strong UINavigationController  *   nav;

@pro_strong UIView      *   addLoacation;       //  添加地点
@pro_strong UIButton    *   addLoacationBtn;

@pro_strong UIView      *   addTag;             //  添加标签
@pro_strong UIButton    *   addTagBtn;

@pro_strong UIView      *   addScene;           //  所属情景
@pro_strong UIButton    *   addSceneBtn;

@end
