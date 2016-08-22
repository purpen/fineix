//
//  THNMallListCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallListCollectionViewCell.h"
#import "MallListGoodsCollectionViewCell.h"

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

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.banner];
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerX.centerY.equalTo(_banner);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(_banner);
        make.bottom.equalTo(_suTitle.mas_top).with.offset(-3);
    }];
    
    [self addSubview:self.lookAll];
    [_lookAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.centerX.equalTo(_banner);
        make.top.equalTo(_suTitle.mas_bottom).with.offset(5);
    }];
    
    [self addSubview:self.goodsList];
    [_goodsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 155));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(_banner.mas_bottom).with.offset(0);
    }];
}

#pragma mark - init
- (UIImageView *)banner {
    if (!_banner) {
        _banner = [[UIImageView alloc] init];
//        _banner.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _banner.backgroundColor = [UIColor grayColor];
    }
    return _banner;
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
        _suTitle.font = [UIFont systemFontOfSize:17];
        _suTitle.textAlignment = NSTextAlignmentCenter;
        _suTitle.text = @"a date of youth";
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
        _title.text = @"一次骑行的约会";
    }
    return _title;
}

- (UIButton *)lookAll {
    if (!_lookAll) {
        _lookAll = [[UIButton alloc] init];
        _lookAll.layer.borderWidth = 1.0f;
        _lookAll.layer.borderColor = [UIColor whiteColor].CGColor;
        _lookAll.layer.cornerRadius = 4.0f;
        _lookAll.layer.masksToBounds = YES;
        [_lookAll setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _lookAll.titleLabel.font = [UIFont systemFontOfSize:12];
        [_lookAll setTitle:NSLocalizedString(@"lookAllData", nil) forState:(UIControlStateNormal)];
        [_lookAll addTarget:self action:@selector(lookAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookAll;
}

- (void)lookAllClick {
    [SVProgressHUD showSuccessWithStatus:@"查看全部主题商品"];
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 135);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185) collectionViewLayout:flowLayout];
        _goodsList.backgroundColor = [UIColor whiteColor];
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.showsHorizontalScrollIndicator = NO;
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:MallListGoodsCellId];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.goodsMarr.count;
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListGoodsCellId
                                                                                 forIndexPath:indexPath];
//    if (self.goodsMarr.count) {
//        [cell setGoodsData:self.goodsMarr[indexPath.row]];
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:@"打开商品详情"];
}


@end
