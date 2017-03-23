//
//  THNMabeLikeTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.



#import "THNMabeLikeTableViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "UIImageView+WebCache.h"
#import "THNProductDongModel.h"
#import "FBGoodsInfoViewController.h"

@interface THNMabeLikeTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) UILabel *biaoTiLabel;

@end

@implementation THNMabeLikeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THNMABLELikeTableViewCell]) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowlayout.minimumLineSpacing = 15.0f;
        flowlayout.sectionInset = UIEdgeInsetsMake(0, 15, 15, 15);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
        self.collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(40);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        }];
        [self.collectionView registerClass:[THNMabeLikeTableViewCellcell class] forCellWithReuseIdentifier:THNMABLELikeTableViewCellcell];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.collectionView.mas_top).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(40);
        }];

        self.biaoTiLabel = [[UILabel alloc] init];
        self.biaoTiLabel.font = [UIFont systemFontOfSize:13];
        self.biaoTiLabel.text = @"你可能会喜欢";
        self.biaoTiLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.biaoTiLabel];
        [_biaoTiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(17);
        }];
    }
    return self;
}

-(void)setString:(NSString *)string{
    _string = string;
    FBRequest *request = [FBAPI postWithUrlString:@"/product/getlist" requestDictionary:@{
                                                                                           @"page" : @(1),
                                                                                           @"size" : @(4),
                                                                                           @"category_id" : string,
                                                                                           @"stick" : @(1)
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rows = result[@"data"][@"rows"];
        if (rows.count == 4) {
            self.modelAry = [THNProductDongModel mj_objectArrayWithKeyValuesArray:rows];
            [self.collectionView reloadData];
        }
    } failure:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    THNMabeLikeTableViewCellcell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:THNMABLELikeTableViewCellcell forIndexPath:indexPath];
    THNProductDongModel *model = self.modelAry[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    THNProductDongModel *model = self.modelAry[indexPath.row];
    goodsVC.goodsID = model._id;
    [self.nav pushViewController:goodsVC animated:YES];
}

@end



@interface THNMabeLikeTableViewCellcell ()

/**  */
@property (nonatomic, strong) UIImageView *iconImageView;
/**  */
@property (nonatomic, strong) UIView *blackView;
/**  */
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *price;

@end

@implementation THNMabeLikeTableViewCellcell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
            make.left.top.equalTo(self).with.offset(0);
        }];
        
        _blackView = [[UIView alloc] init];
        [self addSubview:self.blackView];
        _blackView.backgroundColor = [UIColor blackColor];
        [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.bounds.size.width));
            make.bottom.left.equalTo(self).with.offset(0);
            make.top.equalTo(self.iconImageView.mas_bottom).with.offset(0);
        }];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:10];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 6, 15));
            make.top.left.equalTo(_blackView).with.offset(3);
            make.centerX.equalTo(_blackView);
        }];
        
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:10];
        _price.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _price.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.price];
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 15));
            if (SCREEN_HEIGHT<667.0) {
                make.bottom.equalTo(_blackView).with.offset(0);
            } else {
                make.bottom.equalTo(_blackView).with.offset(-3);
            }
            make.centerX.equalTo(_blackView);
        }];
    }
    return self;
}

-(void)setModel:(THNProductDongModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"￥%ld",(long)[model.sale_price integerValue]];
}

@end
