//
//  InfoRecommendTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoRecommendTableViewCell.h"
#import "RecommendGoodsCollectionViewCell.h"
#import "FBGoodsInfoViewController.h"
#import "FBGoodsInfoViewController.h"

@implementation InfoRecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.goodsData = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark -
- (void)setRecommendGoodsData:(NSMutableArray *)model withType:(NSInteger)type {
    [self setCellUI];
    self.type = type;
    self.goodsData = model;
    self.goodsIds = [model valueForKey:@"idField"];
    
    if (type == 0) {
        [self.flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        [_recommendListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@((self.goodsData.count/2) * (((SCREEN_WIDTH - 40) / 2) * 1.3) + 44));
        }];
    } else if (type == 1) {
        [self.flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    }
    
    [self.recommendListView reloadData];
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    
    [self addSubview:self.recommendListView];
    [_recommendListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, ((SCREEN_WIDTH - 40) / 2) * 1.3));
        make.top.equalTo(self.headerTitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _headerTitle.text = NSLocalizedString(@"recommendGoodsTitle", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        if (IS_iOS9) {
            _headerTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_GoodsTitle];
        } else {
            _headerTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        }
    }
    return _headerTitle;
}

#pragma mark - 推荐商品列表
- (UICollectionView *)recommendListView {
    if (!_recommendListView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 40) / 2, ((SCREEN_WIDTH - 40) / 2) * 1.3);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        self.flowLayout.minimumInteritemSpacing = 5.0;
        [self.flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        
        _recommendListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, ((SCREEN_WIDTH - 40) / 2) * 1.3) collectionViewLayout:self.flowLayout];
        _recommendListView.delegate = self;
        _recommendListView.dataSource = self;
        _recommendListView.scrollEnabled = YES;
        _recommendListView.backgroundColor = [UIColor whiteColor];
        _recommendListView.showsVerticalScrollIndicator = NO;
        _recommendListView.showsHorizontalScrollIndicator = NO;
        [_recommendListView registerClass:[RecommendGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _recommendListView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    RecommendGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    if (self.goodsData.count) {
        [cell setRecommendGoodsData:self.goodsData[indexPath.row]];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = [NSString stringWithFormat:@"%@", self.goodsIds[indexPath.row]];
        [self.nav pushViewController:goodsInfoVC animated:YES];
    
    } else if (self.type == 1) {
        FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = [NSString stringWithFormat:@"%@", self.goodsIds[indexPath.row]];
        [self.nav pushViewController:goodsInfoVC animated:YES];
    }
}
@end
