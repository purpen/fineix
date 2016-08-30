//
//  THNHotActionCollectionReusableView.m
//  Fiu
//
//  Created by FLYang on 16/8/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHotActionCollectionReusableView.h"
#import "UILable+Frame.h"

#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"

@interface THNHotActionCollectionReusableView () {
    NSInteger _type;
    NSInteger _idx;
}

@end

@implementation THNHotActionCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setViewUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSubjectView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)openSubjectView:(UITapGestureRecognizer *)tap {
    [SVProgressHUD showSuccessWithStatus:@"打开专题详情"];
    
    if (_type == 1) {
        THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
        articleVC.articleDetalid = [NSString stringWithFormat:@"%zi", _idx];
        [self.nav pushViewController:articleVC animated:YES];
        
    } else if (_type == 2) {
        THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
        activity.activeDetalId = [NSString stringWithFormat:@"%zi", _idx];
        [self.nav pushViewController:activity animated:YES];
        
    }
}

- (void)thn_setSubjectModel:(THNMallSubjectModelRow *)model {
    _type = model.type;
    _idx = model.idField;
    
    [self.bannerImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    self.suTitle.text = model.shortTitle;
    [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.suTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    self.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_theme_big_%zi",model.type - 1]];
}

- (void)setViewUI {
    [self addSubview:self.bannerImage];
    [_bannerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *0.56));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(15);
    }];
    
    [self addSubview:self.bannerBg];
    [_bannerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.bannerBot];
    [_bannerBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12.5, 8));
        make.bottom.equalTo(_bannerImage.mas_bottom).with.offset(0);
        make.centerX.equalTo(_bannerImage);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.top.equalTo(_bannerImage.mas_centerY).with.offset(0);
        make.centerX.equalTo(_bannerImage);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(_bannerImage);
        make.bottom.equalTo(_suTitle.mas_top).with.offset(-3);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.right.bottom.equalTo(_title).with.offset(0);
    }];
    
    [self addSubview:self.typeImage];
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.top.equalTo(_bannerImage).with.offset(0);
    }];

}

- (UIImageView *)bannerImage {
    if (!_bannerImage) {
        _bannerImage = [[UIImageView alloc] init];
        _bannerImage.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImage.clipsToBounds = YES;
        _bannerImage.backgroundColor = [UIColor grayColor];
    }
    return _bannerImage;
}

- (UIView *)bannerBg {
    if (!_bannerBg) {
        _bannerBg = [[UIView alloc] init];
        _bannerBg.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    }
    return _bannerBg;
}

- (UIButton *)bannerBot {
    if (!_bannerBot) {
        _bannerBot = [[UIButton alloc] init];
        [_bannerBot setImage:[UIImage imageNamed:@"mall_banner_bot"] forState:(UIControlStateNormal)];
    }
    return _bannerBot;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.textColor = [UIColor whiteColor];
        _suTitle.font = [UIFont systemFontOfSize:17];
        _suTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _suTitle;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR alpha:1];
        _title.font = [UIFont systemFontOfSize:17];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)botLine {
    if (!_botLine) {
        _botLine = [[UILabel alloc] init];
        _botLine.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
    }
    return _botLine;
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [[UIImageView alloc] init];
    }
    return _typeImage;
}


@end
