//
//  AllSceneCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllSceneCollectionViewCell.h"
#import "UIView+FSExtension.h"

@implementation AllSceneCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setAllFiuSceneListData:(FiuSceneInfoData *)model {
    [self.sceneImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self titleTextStyle:model.title];
    self.locationLab.text = model.address;
    [self setCollectionCellViewUI];
}

#pragma mark -
- (void)setCollectionCellViewUI {
    [self addSubview:self.sceneImage];
}

#pragma mark - 情景图片
- (UIImageView *)sceneImage {
    if (!_sceneImage) {
        _sceneImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _sceneImage.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImage.clipsToBounds  = YES;
        _sceneImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaul_Bg_180"]];
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.5f)];
        shadow.frame = _sceneImage.bounds;
        [_sceneImage.layer addSublayer:shadow];
        
        [_sceneImage addSubview:self.locationIcon];
        [_locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 10.5));
            make.bottom.equalTo(_sceneImage.mas_bottom).with.offset(-15);
            make.left.equalTo(_sceneImage.mas_left).with.offset(10);
        }];
        
        [_sceneImage addSubview:self.locationLab];
        [_locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_locationIcon);
            make.left.equalTo(_locationIcon.mas_right).with.offset(5);
            make.right.equalTo(_sceneImage.mas_right).with.offset(-10);
        }];
        
        [_sceneImage addSubview:self.titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@15);
            make.bottom.equalTo(_locationIcon.mas_top).with.offset(-10);
            make.left.equalTo(_sceneImage.mas_left).with.offset(10);
            make.right.equalTo(_sceneImage.mas_right).with.offset(-10);
        }];
    }
    return _sceneImage;
}

#pragma mark - 情景标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _titleLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_SceneTitle];
        } else {
            _titleLab.font = [UIFont systemFontOfSize:Font_SceneTitle];
        }
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    if (title.length > 12) {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
        }];
    } else if (title.length <= 12) {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@15);
        }];
    }
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:[UIColor blackColor] ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.titleLab.attributedText = titleText;
}

#pragma mark - 地理位置图标
- (UIImageView *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] init];
        _locationIcon.image = [UIImage imageNamed:@"icon_map_white"];
    }
    return _locationIcon;
}

#pragma mark - 地理位置
- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _locationLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_Place];
        } else {
            _locationLab.font = [UIFont systemFontOfSize:Font_Place];
        }
        _locationLab.textColor = [UIColor whiteColor];
    }
    return _locationLab;
}


@end
