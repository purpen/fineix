//
//  AddTagsView.h
//  Fiu
//
//  Created by FLYang on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>

@protocol AddTagsViewDelegate <NSObject>

@optional
- (void)addTagsDone;

@end

@interface AddTagsView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@pro_strong UILabel             *   vcTitle;
@pro_strong UIImageView         *   bgImgView;
@pro_strong UIImage             *   bgImage;
@pro_strong UIButton            *   doneBtn;

@pro_strong UICollectionView    *   chooseCollection;
@pro_strong NSMutableArray      *   chooseTagMarr;
@pro_strong UITextField         *   addTagWrite;

@pro_weak id <AddTagsViewDelegate>  delegate;

- (void)setDefaultTags:(NSMutableArray *)tags;

@end
