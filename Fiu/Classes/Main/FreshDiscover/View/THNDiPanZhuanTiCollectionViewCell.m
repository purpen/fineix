//
//  THNDiPanZhuanTiCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDiPanZhuanTiCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "CollectionCategoryModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+FSExtension.h"

@interface THNDiPanZhuanTiCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
/**  */
@property (nonatomic, strong) UIView *bgView;

@end

@implementation THNDiPanZhuanTiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = 3*SCREEN_HEIGHT/667.0;
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 3*SCREEN_HEIGHT/667.0;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = NO;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.bgView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.bgView.mas_centerY).mas_offset(0);
            make.width.mas_lessThanOrEqualTo(5*self.contentView.width/6);
        }];
    }
    return self;
}

-(void)setModel:(StickModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.textLabel.text = model.title;
}

@end
