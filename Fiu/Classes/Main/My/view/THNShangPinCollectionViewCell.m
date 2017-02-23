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

/**  */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;

@end

@implementation THNShangPinCollectionViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THNSHANGPinCollectionViewCell]) {
        self.tableview = [[UITableView alloc] init];
        self.tableview.scrollEnabled = NO;
        self.tableview.rowHeight = 50;
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
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.tableview.mas_top).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(5);
        }];
        
        self.lineView2 = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView2];
        [self.lineView2 setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableview.mas_bottom).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(5);
        }];
        
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
    if (indexPath.row != self.modelAry.count - 1) {
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).mas_offset(0);
            make.right.mas_equalTo(cell.contentView.mas_right).mas_offset(-15);
            make.left.mas_equalTo(cell.contentView.mas_left).mas_offset(15);
            make.height.mas_equalTo(0.5);
        }];
    }
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

@end

@implementation Cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
            make.width.height.mas_equalTo(30);
        }];
        
        self.extLabel = [[UILabel alloc] init];
        self.extLabel.font = [UIFont systemFontOfSize:13];
//        self.extLabel.textAlignment = NSTextAlignmentCenter;
        self.extLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.extLabel];
        [_extLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        }];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:13];
//        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.textColor = [UIColor colorWithHexString:fineixColor];
        [self.contentView addSubview:self.priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.extLabel.mas_left).mas_offset(-1);
            make.bottom.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(2);
        }];
        
        self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_go_black"]];
        [self.contentView addSubview:self.goImageView];
        [_goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        }];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(0.5);
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
