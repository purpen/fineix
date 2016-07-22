//
//  ShowContentView.h
//  Fiu
//
//  Created by FLYang on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol ShowContentViewDelegate <NSObject>

@optional
- (void)EditContentData;
- (void)BeginAddTag;

@end

@interface ShowContentView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@pro_strong UILabel             *   titleText;      //  标题文字
@pro_strong UITextView          *   desText;        //  描述文字
@pro_strong UIButton            *   tagsIcon;
@pro_strong UICollectionView    *   chooseCollection;
@pro_strong NSMutableArray      *   chooseTagMarr;
@pro_strong UIButton            *   addTagBtn;
@pro_weak id <ShowContentViewDelegate> delegate;

- (void)setEditContentData:(NSString *)title withDes:(NSString *)des withTags:(NSMutableArray *)tags;

- (void)setAddTags:(NSMutableArray *)addTags;

@end
