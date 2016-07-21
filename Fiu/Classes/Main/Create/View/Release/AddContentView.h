//
//  AddContentView.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol AddContentViewDelegate <NSObject>

@optional
- (void)EditBegin;

@end

@interface AddContentView : UIView <
    UITextViewDelegate, UITextFieldDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
>

@pro_strong UIViewController    *   vc;
@pro_strong UIImage             *   bgImage;
@pro_strong UITextView          *   content;          //    场景描述内容
@pro_strong UITextField         *   title;            //    场景标题
@pro_strong NSString            *   type;             //    创建类型
@pro_strong UIButton            *   chooseText;       //    选择语境
@pro_strong UIView              *   tagsView;
@pro_strong UIButton            *   tagsIcon;
@pro_strong UICollectionView    *   tagsColleciton;
@pro_strong UICollectionView    *   chooseCollection;
@pro_strong NSMutableArray      *   tagS;             //    获取的标签
@pro_strong NSMutableArray      *   chooseTagMarr;

@pro_weak id <AddContentViewDelegate> delegate;

- (void)getUserEditTags:(NSMutableArray *)tagsMarr;

- (void)chooseTagsDone:(NSMutableArray *)chooseTagS;

@end
