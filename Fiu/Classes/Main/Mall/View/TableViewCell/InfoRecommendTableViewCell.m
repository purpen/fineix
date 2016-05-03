//
//  InfoRecommendTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoRecommendTableViewCell.h"
#import "RecommendGoodsCollectionViewCell.h"
#import "GoodsInfoViewController.h"

@implementation InfoRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    
    [self addSubview:self.recommendListView];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _headerTitle.text = NSLocalizedString(@"recommendGoodsTitle", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _headerTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _headerTitle;
}

#pragma mark - 情景滑动列表
- (UICollectionView *)recommendListView {
    if (!_recommendListView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30) / 2, ((SCREEN_WIDTH - 30) / 2) * 1.3);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.minimumInteritemSpacing = 5.0;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _recommendListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 225) collectionViewLayout:flowLayout];
        _recommendListView.delegate = self;
        _recommendListView.dataSource = self;
        _recommendListView.backgroundColor = [UIColor whiteColor];
        _recommendListView.showsVerticalScrollIndicator = NO;
        _recommendListView.showsHorizontalScrollIndicator = NO;
        [_recommendListView registerClass:[RecommendGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _recommendListView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    RecommendGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setUI];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"打开商品 ＝＝＝＝＝＝＝＝ %zi", indexPath.row);
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
    [self.nav pushViewController:goodsInfoVC animated:YES];
}
@end
