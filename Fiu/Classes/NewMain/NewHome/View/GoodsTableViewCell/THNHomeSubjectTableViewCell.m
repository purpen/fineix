//
//  THNHomeSubjectTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNHomeSubjectTableViewCell.h"
#import "UILable+Frame.h"

@implementation THNHomeSubjectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setSubjectModel:(HomeSubjectRow *)model {
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
        make.centerX.centerY.equalTo(_bannerImage);
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
