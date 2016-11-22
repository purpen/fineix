//
//  THNShareCollectionView.m
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNShareCollectionView.h"
#import "THNShareCollectionViewCell.h"
#import "THNShareCollectionReusableView.h"

static NSString *const CellId         = @"THNShareCollectionViewCellId";
static NSString *const ReusableViewID = @"THNShareCollectionReusableView";

@implementation THNShareCollectionView

- (NSArray *)shareIconArr {
    if (!_shareIconArr) {
        _shareIconArr = @[@"icon_wechat", @"icon_friends", @"icon_qq", @"icon_weibo"];
    }
    return _shareIconArr;
}

- (NSArray *)shareTitleArr {
    if (!_shareTitleArr) {
        _shareTitleArr = @[@"微信好友" ,@"微信朋友圈" ,@"QQ好友" ,@"新浪微博"];
    }
    return _shareTitleArr;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (layout) {
        self = [super initWithFrame:frame collectionViewLayout:layout];
        
    } else {
        UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc] init];
        flayout.minimumLineSpacing = 0;
        flayout.minimumInteritemSpacing = 0;
        flayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        self = [super initWithFrame:frame collectionViewLayout:flayout];
    }
    
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass:[THNShareCollectionViewCell class] forCellWithReuseIdentifier:CellId];
        [self registerClass:[THNShareCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewID];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareTitleArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/self.shareTitleArr.count, SCREEN_WIDTH/self.shareTitleArr.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.shareIcon.image = [UIImage imageNamed:self.shareIconArr[indexPath.row]];
    cell.shareTitle.text = self.shareTitleArr[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    THNShareCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:ReusableViewID
                                                                                           forIndexPath:indexPath];
    [footerView.cancelButton addTarget:self action:@selector(cancelShare:) forControlEvents:(UIControlEventTouchUpInside)];
    return footerView;
}

- (void)cancelShare:(UIButton *)button {
    [UIView animateWithDuration:.3 animations:^{
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.chooseShareAddress(indexPath.row);
}


@end
