//
//  THNShareCollectionView.h
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

typedef void(^ChooseShareAddress)(NSInteger index);

@interface THNShareCollectionView : UICollectionView <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) NSArray *shareTitleArr;
@property (nonatomic, strong) NSArray *shareIconArr;
@property (nonatomic, copy) ChooseShareAddress chooseShareAddress;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

@end
