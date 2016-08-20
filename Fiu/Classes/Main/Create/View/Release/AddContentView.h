//
//  AddContentView.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "TTTAttributedLabel.h"

typedef void(^GetEditContentAndTags)(NSString * title, NSString * des, NSMutableArray * tagS);

@interface AddContentView : UIView <
    UITextViewDelegate,
    TTTAttributedLabelDelegate
>

@pro_strong UIViewController    *   vc;
@pro_strong UIImageView         *   sceneImgView;
@pro_strong UIImage             *   bgImage;
@pro_strong UILabel             *   title;            //    场景标题
@pro_strong UILabel             *   suTitle;
@pro_strong UIButton            *   addText;          //    添加描述
@pro_strong NSMutableArray      *   userAddTags;
@pro_strong UIScrollView        *   contentRoll;
@pro_strong TTTAttributedLabel  *   content;          //    场景描述内容

@pro_copy GetEditContentAndTags  getEditContentAndTags;

@end
