//
//  THNBrandInfoCollectionReusableView.m
//  Fiu
//
//  Created by FLYang on 16/9/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNBrandInfoCollectionReusableView.h"

@implementation THNBrandInfoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self setCellViewUI];
    }
    return self;
}

- (void)setBrandInfoData:(BrandInfoData *)model {
    [self.brandBgImg downloadImage:model.bannerUrl place:[UIImage imageNamed:@""]];
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#555555" alpha:.2];
    [_brandBgImg addSubview:bgView];
    [self.brandImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self changeContentLabStyle:self.brandIntroduce withText:[NSString stringWithFormat:@"%@", model.des]];
}

//  内容文字的样式
- (void)changeContentLabStyle:(UILabel *)lable withText:(NSString *)str {
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    lable.attributedText = contentText;
    
    CGSize size = [lable boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    
    [lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width , size.height + 20));
    }];
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.brandBgImg];
    [_brandBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , 210));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.brandImg];
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.bottom.equalTo(self.brandBgImg.mas_bottom).with.offset(20);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.brandIntroduce];
    [_brandIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 100));
        make.top.equalTo(self.brandBgImg.mas_bottom).with.offset(25);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
}

#pragma mark - 品牌背景
- (UIImageView *)brandBgImg {
    if (!_brandBgImg) {
        _brandBgImg = [[UIImageView alloc] init];
        _brandBgImg.contentMode = UIViewContentModeScaleAspectFill;
        _brandBgImg.clipsToBounds = YES;
        _brandBgImg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    }
    return _brandBgImg;
}

#pragma mark - 品牌头像
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] init];
        _brandImg.contentMode = UIViewContentModeScaleAspectFill;
        _brandImg.layer.cornerRadius = 75/2;
        _brandImg.layer.masksToBounds = YES;
        _brandImg.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:.5].CGColor;
        _brandImg.layer.borderWidth = 1.0f;
    }
    return _brandImg;
}

#pragma mark - 品牌介绍
- (UILabel *)brandIntroduce {
    if (!_brandIntroduce) {
        _brandIntroduce = [[UILabel alloc] init];
        _brandIntroduce.textColor = [UIColor colorWithHexString:@"#555555"];
        _brandIntroduce.font = [UIFont systemFontOfSize:12];
        _brandIntroduce.numberOfLines = 0;
    }
    return _brandIntroduce;
}

#pragma mark - 切换菜单
- (FBSegmentView *)menuView {
    if (!_menuView) {
        NSArray *titleArr = @[NSLocalizedString(@"brandGoodsList", nil), NSLocalizedString(@"brandSceneList", nil)];
        _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 44)];
        [_menuView set_menuItemTitle:titleArr];
        [_menuView set_showBottomLine:YES];
    }
    return _menuView;
}

@end
