//
//  THNSortCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNSortCollectionViewCell.h"
#import "Masonry.h"
#import "CollectionCategoryModel.h"
#import "UIImageView+WebCache.h"
#import "Fiu.h"

@interface THNSortCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation THNSortCollectionViewCell

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
        self.imageV.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        self.imageV.layer.borderWidth = 0.5;
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView).mas_offset(0);
            if (SCREEN_HEIGHT == 812) {
                 make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40);
            } else {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-40*SCREEN_HEIGHT/667.0);
            }
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor colorWithHexString:@"#727272"];
        [self.contentView addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT == 812) {
                make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(5);
            } else {
                make.top.mas_equalTo(self.imageV.mas_bottom).mas_offset(5*SCREEN_HEIGHT/667.0);
            }
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
