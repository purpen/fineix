//
//  THNShangPinCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNShangPinCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "UIImageView+WebCache.h"
#import "THNProductDongModel.h"
#import "FBGoodsInfoViewController.h"

@interface THNShangPinCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation THNShangPinCollectionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THNSHANGPinCollectionViewCell]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        
        self.tableview = [[UITableView alloc] init];
        self.tableview.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.tableview.scrollEnabled = NO;
        self.tableview.rowHeight = 65;
        self.tableview.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableview];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        }];
        [self.tableview registerClass:[Cell class] forCellReuseIdentifier:CELL];
        
    }
    return self;
}

-(void)setModelAry:(NSArray *)modelAry{
    _modelAry = modelAry;
    [self.tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell *cell = [self.tableview dequeueReusableCellWithIdentifier:CELL];
    THNProductDongModel *model = self.modelAry[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    THNProductDongModel *model = self.modelAry[indexPath.row];
    goodsVC.goodsID = model._id;
    [self.nav pushViewController:goodsVC animated:YES];
}

@end



@interface Cell ()

/**  */
@property (nonatomic, strong) UIImageView *iconImageView;
/**  */
@property (nonatomic, strong) UILabel *extLabel;
/**  */
@property (nonatomic, strong) UILabel *priceLabel;
/**  */
@property (nonatomic, strong) UIImageView *goImageView;
/**  */
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangPinBg"]];
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        }];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.bgImageView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgImageView.mas_left).mas_offset(0);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
        }];
        
        self.extLabel = [[UILabel alloc] init];
        self.extLabel.font = [UIFont systemFontOfSize:13];
//        self.extLabel.textAlignment = NSTextAlignmentCenter;
        self.extLabel.textColor = [UIColor blackColor];
        [self.bgImageView addSubview:self.extLabel];
        [_extLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.bgImageView.mas_top).mas_offset(12);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:13];
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.textColor = [UIColor colorWithHexString:fineixColor];
        [self.contentView addSubview:self.priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.extLabel.mas_left).mas_offset(-1);
            make.bottom.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(-7);
        }];
        
        self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_go_black"]];
        [self.contentView addSubview:self.goImageView];
        [_goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-23);
        }];
    }
    return self;
}


-(void)setModel:(THNProductDongModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.extLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",(long)[model.sale_price integerValue]];
}

@end
