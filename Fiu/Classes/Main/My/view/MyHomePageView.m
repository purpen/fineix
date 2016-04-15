//
//  MyHomePageView.m
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomePageView.h"
#import "View+MASAdditions.h"
#import "Fiu.h"

@implementation MyHomePageView

+(instancetype)getMyHomePageView{
    //return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][0];
    MyHomePageView *my = [[MyHomePageView alloc] initWithFrame:CGRectMake(0, 0, 180/667.0*SCREEN_HEIGHT, 320/667.0*SCREEN_HEIGHT)];
    my.backgroundColor = [UIColor redColor];
    [my setCollectionCellViewUI];
    return my;
}

- (void)setUI {
    
    _sceneImage.image = [UIImage imageNamed:@"Bitmap-3"];
    
    NSString * str = @"长城脚下的手工匠人";
    [self titleTextStyle:str];
    
    _locationLab.text = @"北京市 朝阳区";
}

#pragma mark -
- (void)setCollectionCellViewUI {
    [self addSubview:self.sceneImage];
    
}

#pragma mark - 情景图片
- (UIImageView *)sceneImage {
    if (!_sceneImage) {
        _sceneImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [_sceneImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            UIView *superView = [MyHomePageView getMyHomePageView];
//            make.top.equalTo(superView.mas_top).with.offset(0);
//            make.right.equalTo(superView.mas_right).with.offset(0);
//            make.bottom.equalTo(superView.mas_bottom).with.offset(0);
//            make.left.equalTo(superView.mas_left).with.offset(0);
//        }];
        
        [_sceneImage addSubview:self.locationIcon];
        [_locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 10.5));
            make.bottom.equalTo(_sceneImage.mas_bottom).with.offset(-15);
            make.left.equalTo(_sceneImage.mas_left).with.offset(10);
        }];
        
        [_sceneImage addSubview:self.locationLab];
        [_locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_locationIcon);
            make.left.equalTo(_locationIcon.mas_right).with.offset(10);
            make.right.equalTo(_sceneImage.mas_right).with.offset(-10);
        }];
        
        [_sceneImage addSubview:self.titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(105, 42));
            make.bottom.equalTo(_locationIcon.mas_top).with.offset(-5);
            make.left.equalTo(_locationIcon.mas_left).with.offset(0);
        }];
    }
    return _sceneImage;
}

#pragma mark - 情景标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:Font_SceneTitle];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    if ([title length] < 7) {
        _titleLab.font = [UIFont systemFontOfSize:28];
    } else if ([title length] > 7 ) {
        _titleLab.font = [UIFont systemFontOfSize:Font_SceneTitle];
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
        _locationLab.font = [UIFont systemFontOfSize:Font_Place];
        _locationLab.textColor = [UIColor whiteColor];
    }
    return _locationLab;
}

@end
