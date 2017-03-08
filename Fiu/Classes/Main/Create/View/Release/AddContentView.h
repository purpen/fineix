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

@property (nonatomic, strong) UIViewController    *vc;
@property (nonatomic, strong) UIImageView         *sceneImgView;
@property (nonatomic, strong) UILabel             *title;            //    场景标题
//@property (nonatomic, strong) UILabel             *suTitle;
@property (nonatomic, strong) UIButton            *addText;          //    添加描述
@property (nonatomic, strong) NSMutableArray      *userAddTags;
@property (nonatomic, strong) UIScrollView        *contentRoll;
@property (nonatomic, strong) TTTAttributedLabel  *content;          //    场景描述内容
@property (nonatomic, strong) NSString            *actionId;         //    活动Id

@property (nonatomic, copy) GetEditContentAndTags  getEditContentAndTags;

- (void)thn_setSceneTitle:(NSString *)title;
- (void)getContentWithTags:(NSString *)content;
- (void)thn_getActionDataTitle:(NSString *)title;

@end
