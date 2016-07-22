//
//  AddContentView.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

typedef void(^GetEditContentAndTags)(NSString * title, NSString * des, NSMutableArray * tagS);

@interface AddContentView : UIView <
    UITextViewDelegate, UITextFieldDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
>

@pro_strong UIViewController    *   vc;
@pro_strong UIImageView         *   bgImgView;
@pro_strong UIImage             *   bgImage;
@pro_strong UIButton            *   topBtn;
@pro_strong UIButton            *   botBtn;
@pro_strong UITextView          *   content;          //    场景描述内容
@pro_strong UITextField         *   title;            //    场景标题
@pro_strong NSString            *   type;             //    创建类型
@pro_strong UIButton            *   chooseText;       //    选择语境
@pro_strong UIView              *   tagsView;
@pro_strong UIButton            *   tagsIcon;
@pro_strong UICollectionView    *   tagsColleciton;
@pro_strong NSMutableArray      *   tagS;             //    获取的标签
@pro_strong NSMutableArray      *   chooseTagMarr;

@pro_copy GetEditContentAndTags  getEditContentAndTags;

- (void)getUserEditTags:(NSMutableArray *)tagsMarr;

@end
