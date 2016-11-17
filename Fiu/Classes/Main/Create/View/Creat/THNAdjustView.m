//
//  THNAdjustView.m
//  Fiu
//
//  Created by FLYang on 2016/11/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAdjustView.h"
#import "THNAdjustCollectionViewCell.h"

static NSString *const adjustCellId = @"AdjustCellId";

@implementation THNAdjustView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.adjustView];
    }
    return self;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[NSLocalizedString(@"adjust00", nil),
                      NSLocalizedString(@"adjust01", nil),
                      NSLocalizedString(@"adjust02", nil),
                      NSLocalizedString(@"adjust03", nil),
                      NSLocalizedString(@"adjust04", nil)
//                      NSLocalizedString(@"adjust05", nil),
//                      NSLocalizedString(@"adjust06", nil),
//                      NSLocalizedString(@"adjust07", nil)
                      ];
    }
    return _titleArr;
}

- (UICollectionView *)adjustView {
    if (!_adjustView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/5, 120);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _adjustView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) collectionViewLayout:flowLayout];
        _adjustView.delegate = self;
        _adjustView.dataSource = self;
        _adjustView.showsHorizontalScrollIndicator = NO;
        _adjustView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        [_adjustView registerClass:[THNAdjustCollectionViewCell class] forCellWithReuseIdentifier:adjustCellId];
    }
    return _adjustView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNAdjustCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:adjustCellId
                                                                                   forIndexPath:indexPath];
    [cell thn_getAdjustTitle:self.titleArr[indexPath.row]];
    [cell thn_getAdjustIconImage:[NSString stringWithFormat:@"icon_adjust_0%zi", indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_adjustFilterValue:index:)]) {
        [self.delegate thn_adjustFilterValue:self.titleArr[indexPath.row] index:indexPath.row];
    }
}


@end
