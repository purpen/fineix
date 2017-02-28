//
//  THNQingJingOneCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/28.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQingJingOneCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "THNOneModel.h"
#import "UIImageView+WebCache.h"

@interface THNQingJingOneCell()

/**  */
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *texLabel;
/**  */
@property (nonatomic, strong) UILabel *subTextLabel;
/**  */
@property (nonatomic, strong) UIView *yellowLineView;
/**  */
@property (nonatomic, strong) UIView *labelView;
/**  */
@property (nonatomic, strong) UIView *bottomLabelView;
/**  */
@property (nonatomic, strong) UILabel *bottomLabel;
/**  */
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation THNQingJingOneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(422/2*SCREEN_HEIGHT/667.0);
        }];
        
        self.shadowView = [[UIView alloc] init];
        [self.bgImageView addSubview:self.shadowView];
        self.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.bgImageView).mas_offset(0);
        }];
        
        self.labelView = [[UIView alloc] init];
        self.labelView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.labelView];
        [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(157/2*SCREEN_HEIGHT/667.0);
            make.height.mas_equalTo(58/2);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
        }];
        
        self.yellowLineView = [[UIView alloc] init];
        self.yellowLineView.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [self.labelView addSubview:self.yellowLineView];
        [_yellowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.labelView).mas_offset(0);
            make.height.mas_equalTo(1);
        }];
        
        self.texLabel = [[UILabel alloc] init];
        self.texLabel.font = [UIFont systemFontOfSize:13];
        self.texLabel.textAlignment = NSTextAlignmentCenter;
        self.texLabel.textColor = [UIColor whiteColor];
        [self.labelView addSubview:self.texLabel];
        [_texLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelView.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.labelView.mas_top).mas_offset(5);
            make.right.mas_equalTo(self.labelView.mas_right).mas_offset(-15);
            make.bottom.mas_equalTo(self.labelView.mas_bottom).mas_offset(-5);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        self.subTextLabel = [[UILabel alloc] init];
        self.subTextLabel.font = [UIFont systemFontOfSize:13];
        self.subTextLabel.textAlignment = NSTextAlignmentCenter;
        self.subTextLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.subTextLabel];
        [_subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labelView.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        self.bottomLabelView = [[UIView alloc] init];
        self.bottomLabelView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bottomLabelView];
        [_bottomLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImageView.mas_bottom).mas_offset(0);
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(186/2);
        }];
        
        self.bottomLabel = [[UILabel alloc] init];
        [self.bottomLabelView addSubview:self.bottomLabel];
        [_bottomLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomLabelView.mas_left).mas_offset(15);
            make.right.mas_equalTo(self.bottomLabelView.mas_right).mas_offset(-15);
            make.top.mas_equalTo(self.bottomLabelView.mas_top).mas_offset(15);
            make.bottom.mas_equalTo(self.bottomLabelView.mas_bottom).mas_offset(-15);
        }];
    }
    return self;
}

-(void)setModel:(THNOneModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.banner_url]];
    self.texLabel.text = model.title;
    self.subTextLabel.text = model.short_title;
    self.bottomLabel.text = model.summary;
}

@end
