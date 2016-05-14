
//
//  GoodsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "GoodsImgFlowLayout.h"
#import "GoodsImgCollectionViewCell.h"

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        self.goodsImgMarr = [NSMutableArray array];
        self.goodsId = [NSMutableArray array];
        [self setCellViewUI];
    }
    return self;
}

- (void)setGoodsData:(GoodsRow *)model {
    if (self.goodsImgMarr.count > 0) {
        [self.goodsImgMarr removeAllObjects];
    }
    if (self.goodsId.count > 0) {
        [self.goodsId removeAllObjects];
    }
    
    self.title.text = model.title;
    [self.goodsId addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    
    // 产品来源: 1.官网；2.淘宝；3.天猫；4.京东
    if (model.attrbute == 1) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_thn"];
    } else if (model.attrbute == 2) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_taobao"];
    } else if (model.attrbute == 3) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_tmall"];
    } else if (model.attrbute == 4) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_JD"];
    }
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f", model.marketPrice];
    
    if (model.banner.count > 0) {
        self.goodsImgMarr = [NSMutableArray arrayWithArray:model.banner];
        
    } else if (model.bannerAsset.count > 0) {
        self.goodsImgMarr = [NSMutableArray arrayWithArray:model.bannerAsset];
    }
    
    [self.goodsImgView reloadData];
    
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.goodsImgView];
    
    [self addSubview:self.titleBg];
    [_titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.654, 25));
        make.top.equalTo(self.goodsImgView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(5);
    }];
    
    [self addSubview:self.typeImg];
    [_typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 14));
        make.centerY.equalTo(self.titleBg);
        make.left.equalTo(self.titleBg.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.priceBg];
    [_priceBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * 0.654) - 46, 25));
        make.bottom.equalTo(self.titleBg.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];
}

#pragma mark - 滚动
- (UICollectionView *)goodsImgView {
    if (!_goodsImgView) {
        GoodsImgFlowLayout * flowLayout = [[GoodsImgFlowLayout alloc] init];
        
        _goodsImgView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 150) collectionViewLayout:flowLayout];
        _goodsImgView.delegate = self;
        _goodsImgView.dataSource = self;
        _goodsImgView.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        _goodsImgView.showsHorizontalScrollIndicator = NO;
        [_goodsImgView registerClass:[GoodsImgCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsImgCollectionViewCell"];
        
    }
    return _goodsImgView;
}

#pragma mark UICollectionViewDelegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsImgMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsImgCollectionViewCell" forIndexPath:indexPath];
    [cell.img downloadImage:self.goodsImgMarr[indexPath.row] place:[UIImage imageNamed:@""]];
    if (indexPath.row % 2 != 0) {
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(-11, 0, 4, 150)];
        line.image = [UIImage imageNamed:@"Goods_image_bg"];
        [cell addSubview:line];
    }
    return cell;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 225, 25)];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _title;
}

#pragma mark - 标题背景
- (UIImageView *)titleBg {
    if (!_titleBg) {
        _titleBg = [[UIImageView alloc] init];
        _titleBg.image = [UIImage imageNamed:@"Goods_title_bg"];
        
        [_titleBg addSubview:self.title];
        
    }
    return _titleBg;
}

#pragma mark - 来源
- (UIImageView *)typeImg {
    if (!_typeImg) {
        _typeImg = [[UIImageView alloc] init];
    }
    return _typeImg;
}

#pragma mark - 价格
- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - (SCREEN_WIDTH * 0.654) - 56, 25)];
        _price.textColor = [UIColor whiteColor];
        _price.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        _price.textAlignment = NSTextAlignmentCenter;
    }
    return _price;
}

#pragma mark - 价格背景
- (UIImageView *)priceBg {
    if (!_priceBg) {
        _priceBg = [[UIImageView alloc] init];
        _priceBg.image = [UIImage imageNamed:@"Goods_price_bg"];
        
        [_priceBg addSubview:self.price];
    }
    return _priceBg;
}

@end