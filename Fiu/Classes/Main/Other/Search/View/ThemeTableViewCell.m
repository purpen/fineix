//
//  ThemeTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import "UILable+Frame.h"

@implementation ThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setthemeListData:(ThemeModelRow *)model {
    self.title.text = model.title;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    self.suTitle.text = model.shortTitle;
    [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self.suTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30)].width + 10));
    }];
    
    [self.banner downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.banner];
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.bannerBg];
    [_bannerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BANNER_HEIGHT));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.top.equalTo(_banner.mas_centerY).with.offset(0);
        make.centerX.equalTo(_banner);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(_banner);
        make.bottom.equalTo(_suTitle.mas_top).with.offset(-3);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.left.right.bottom.equalTo(_title).with.offset(0);
    }];
}

#pragma mark - init
- (UIImageView *)banner {
    if (!_banner) {
        _banner = [[UIImageView alloc] init];
        _banner.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _banner.contentMode = UIViewContentModeScaleAspectFill;
        _banner.clipsToBounds = YES;
    }
    return _banner;
}

- (UIView *)bannerBg {
    if (!_bannerBg) {
        _bannerBg = [[UIView alloc] init];
        _bannerBg.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    }
    return _bannerBg;
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

@end
