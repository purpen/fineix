//
//  THNRecommendCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRommendCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "CollectionCategoryModel.h"
#import "UIImageView+WebCache.h"

@interface THNRommendCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLabel;
/**  */
@property (nonatomic, strong) UILabel *subTextLabel;
/**  */
@property (nonatomic, strong) UIView *yellowLineView;
/**  */
@property (nonatomic, strong) UIView *labelView;

@end

@implementation THNRommendCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
//        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.labelView = [[UIView alloc] init];
        self.labelView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.labelView];
        [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT == 812) {
                make.top.mas_equalTo(self.contentView.mas_top).mas_offset(96/2);
                make.height.mas_equalTo(58/2);
                make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            }else {
                make.top.mas_equalTo(self.contentView.mas_top).mas_offset(96/2*SCREEN_HEIGHT/667.0);
                make.height.mas_equalTo(58/2*SCREEN_HEIGHT/667.0);
                make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            }
        }];
        
        self.yellowLineView = [[UIView alloc] init];
        self.yellowLineView.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [self.labelView addSubview:self.yellowLineView];
        [_yellowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.labelView).mas_offset(0);
            make.height.mas_equalTo(1);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.labelView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    }
    return self;
}

-(void)setModel:(StickModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.textLabel.text = model.title;
    self.subTextLabel.text = model.sub_title;
}


@end
