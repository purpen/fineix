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
#import "Fiu.h"

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
        if (SCREEN_HEIGHT == 812) {
            self.imageV.layer.cornerRadius = 30;
        } else {
            self.imageV.layer.cornerRadius = 30*SCREEN_HEIGHT/667.0;
        }
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView).mas_offset(0);
            if (SCREEN_HEIGHT == 812) {
                make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-20);
            }else{
                make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-20*SCREEN_HEIGHT/667.0);
            }
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:11];
        if (SCREEN_HEIGHT<667.0) {
            self.textLabel.font = [UIFont systemFontOfSize:10];
        } else if (SCREEN_HEIGHT > 667.0) {
            if (SCREEN_HEIGHT == 812) {
                self.textLabel.font = [UIFont systemFontOfSize:11];
            } else {
                self.textLabel.font = [UIFont systemFontOfSize:12];
            }
        }
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.imageV addSubview:self.textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (SCREEN_HEIGHT == 812) {
                make.top.mas_equalTo(self.imageV.mas_top).mas_offset(37);
            } else {
                make.top.mas_equalTo(self.imageV.mas_top).mas_offset(37*SCREEN_HEIGHT/667.0);
            }
            make.centerX.mas_equalTo(self.imageV.mas_centerX).mas_offset(0);
        }];
        
    }
    return self;
}

-(void)setModel:(Pro_categoryModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.back_url]];
//    [self.imageV setImage:[UIImage imageNamed:model.cover_url]];
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
