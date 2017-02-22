//
//  THNNewSortCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/21.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNNewSortCollectionViewCell.h"
#import "Masonry.h"
#import "CollectionCategoryModel.h"
#import "UIImageView+WebCache.h"

@interface THNNewSortCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation THNNewSortCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
        //        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = 30;
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView).mas_offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(5);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).mas_offset(0);
        }];
        
    }
    return self;
}

-(void)setModel:(Pro_categoryModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.app_cover_url]];
    [self.imageV setImage:[UIImage imageNamed:model.cover_url]];
    self.textLabel.text = model.title;
}

-(void)setPModel:(Pro_categoryModel *)pModel{
    _pModel = pModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:pModel.cover_url]];
    self.textLabel.text = pModel.title;
}

-(void)setUserModel:(UsersModel *)userModel{
    _userModel = userModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:userModel.avatar_url]];
    self.textLabel.text = userModel.nickname;
}


@end
