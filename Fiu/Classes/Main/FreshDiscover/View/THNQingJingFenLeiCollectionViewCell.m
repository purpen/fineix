//
//  THNQingJingFenLeiCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQingJingFenLeiCollectionViewCell.h"
#import "Masonry.h"
#import "CollectionCategoryModel.h"
#import "UIImageView+WebCache.h"
#import "Fiu.h"

@interface THNQingJingFenLeiCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLabel;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation THNQingJingFenLeiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
//        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        self.imageV.layer.masksToBounds = YES;
        if (SCREEN_HEIGHT == 812) {
            self.imageV.layer.cornerRadius = 30;
        } else {
            self.imageV.layer.cornerRadius = 30*SCREEN_HEIGHT/667.0;
        }
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT == 812) {
                make.center.mas_equalTo(self.contentView).mas_offset(0);
                make.width.height.mas_equalTo(60);
            } else {
                make.center.mas_equalTo(self.contentView).mas_offset(0);
                make.width.height.mas_equalTo(60*SCREEN_HEIGHT/667.0);
            }
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        if (SCREEN_HEIGHT>667.0) {
            if (SCREEN_HEIGHT == 812) {
                self.textLabel.font = [UIFont systemFontOfSize:13];
            }
            self.textLabel.font = [UIFont systemFontOfSize:14];
        }
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT == 812) {
                make.top.mas_equalTo(self.textLabel.mas_bottom).mas_offset(2);
                make.left.right.mas_equalTo(self.textLabel).mas_offset(0);
                make.height.mas_equalTo(1);
            } else {
                make.top.mas_equalTo(self.textLabel.mas_bottom).mas_offset(2*SCREEN_HEIGHT/667.0);
                make.left.right.mas_equalTo(self.textLabel).mas_offset(0);
                make.height.mas_equalTo(1*SCREEN_HEIGHT/667.0);
            }
        }];
        
    }
    return self;
}

-(void)setModel:(Pro_categoryModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.textLabel.text = model.title;
}

-(void)setPModel:(Pro_categoryModel *)pModel{
    _pModel = pModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:pModel.app_cover_url]];
    self.textLabel.text = pModel.title;
}

@end
