//
//  THNMallListCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallListCollectionViewCell.h"
#import "MallListGoodsCollectionViewCell.h"
#import "UILable+Frame.h"
#import "THNMallGoodsModelItem.h"
#import "FBGoodsInfoViewController.h"

static NSString *const MallListGoodsCellId = @"mallListGoodsCellId";

@implementation THNMallListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setMallSubjectData:(THNMallSubjectModelRow *)model {
    self.banner.alpha = 0.0f;
    
    [self.goodsIdMarr removeAllObjects];
    self.title.text = model.title;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    self.suTitle.text = model.shortTitle;
    [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.suTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    [self.banner sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.5 animations:^{
            self.banner.alpha = 1.0f;
        }];
    }];

    self.goodsListMarr = [NSMutableArray arrayWithArray:model.products];
    if (self.goodsListMarr.count) {
        [self.goodsList reloadData];
        for (THNMallGoodsModelItem *model in self.goodsListMarr) {
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
    }
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.banner];
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.bannerBg];
    [_bannerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.bannerBot];
    [_bannerBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12.5, 8));
        make.bottom.equalTo(_banner.mas_bottom).with.offset(0);
        make.centerX.equalTo(_banner);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.top.equalTo(_banner.mas_centerY).with.offset(5);
        make.centerX.equalTo(_banner);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(_banner);
        make.bottom.equalTo(_suTitle.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.right.bottom.equalTo(_title).with.offset(0);
    }];
    
    [self addSubview:self.goodsList];
    [_goodsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).with.offset(0);
        make.top.equalTo(_banner.mas_bottom).with.offset(0);
    }];
}

#pragma mark - init
- (UIImageView *)banner {
    if (!_banner) {
        _banner = [[UIImageView alloc] init];
        _banner.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _banner.contentMode = UIViewContentModeScaleAspectFill;
        _banner.clipsToBounds = YES;
    }
    return _banner;
}

- (UIView *)bannerBg {
    if (!_bannerBg) {
        _bannerBg = [[UIView alloc] init];
        _bannerBg.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    }
    return _bannerBg;
}

- (UIButton *)bannerBot {
    if (!_bannerBot) {
        _bannerBot = [[UIButton alloc] init];
        [_bannerBot setImage:[UIImage imageNamed:@"mall_banner_bot"] forState:(UIControlStateNormal)];
    }
    return _bannerBot;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.textColor = [UIColor whiteColor];
        _suTitle.font = [UIFont systemFontOfSize:14];
        _suTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _suTitle;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:1];
        _title.font = [UIFont systemFontOfSize:17];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)botLine {
    if (!_botLine) {
        _botLine = [[UILabel alloc] init];
        _botLine.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
    }
    return _botLine;
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 135);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185) collectionViewLayout:flowLayout];
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.showsHorizontalScrollIndicator = NO;
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:MallListGoodsCellId];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListGoodsCellId
                                                                                 forIndexPath:indexPath];
    if (self.goodsListMarr.count) {
        cell.goodsImageView.backgroundColor = [UIColor whiteColor];
        [cell setMallSubjectGoodsListData:self.goodsListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsIdMarr[indexPath.row]) {
        FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
        goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
        [self.nav pushViewController:goodsVC animated:YES];
    }
}

- (NSMutableArray *)goodsListMarr {
    if (!_goodsListMarr) {
        _goodsListMarr = [NSMutableArray array];
    }
    return _goodsListMarr;
}

- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

@end
