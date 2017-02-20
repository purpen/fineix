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

@interface THNDiPanZhuanTiCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation THNDiPanZhuanTiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
//        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = 3;
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.contentView).mas_offset(0);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(0);
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
