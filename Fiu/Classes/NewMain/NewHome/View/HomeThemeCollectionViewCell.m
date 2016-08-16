//
//  HomeThemeCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeThemeCollectionViewCell.h"

@implementation HomeThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel
- (void)setThemeDataModel:(FBSubjectModelRow *)model {
    self.image.hidden = NO;
    self.peopleNum.hidden = NO;
    self.title.hidden = NO;
    self.typeImage.hidden = NO;
    self.more.hidden = YES;
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    [self.peopleNum setTitle:[NSString stringWithFormat:@"%zi人参加", model.attendCount] forState:(UIControlStateNormal)];
    
    NSArray *typeImageArr = @[@"icon_theme_paper", @"icon_theme_action", @"icon_theme_cuxiao", @"icon_theme_newgoods"];
    self.typeImage.image = [UIImage imageNamed:typeImageArr[model.type - 1]];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self).with.offset(0);
    }];
    
    UIView *blackView = [[UIView alloc] initWithFrame:self.bounds];
    blackView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3f];
    [self addSubview:blackView];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.right.equalTo(self).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(20);
    }];
    
    [self addSubview:self.peopleNum];
    [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.right.equalTo(self).with.offset(0);
        make.top.equalTo(_title.mas_bottom).with.offset(8);
    }];
    
    [self addSubview:self.typeImage];
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.top.equalTo(_image).with.offset(0);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    return _image;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UIButton *)peopleNum {
    if (!_peopleNum) {
        _peopleNum = [[UIButton alloc] init];
        [_peopleNum setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.8f] forState:(UIControlStateNormal)];
        _peopleNum.titleLabel.font = [UIFont systemFontOfSize:10];
        [_peopleNum setImage:[UIImage imageNamed:@"icon_theme_people"] forState:(UIControlStateNormal)];
        [_peopleNum setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _peopleNum.userInteractionEnabled = NO;
    }
    return _peopleNum;
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [[UIImageView alloc] init];
    }
    return _typeImage;
}

-(void)setMoreTheme {
    self.image.hidden = YES;
    self.peopleNum.hidden = YES;
    self.title.hidden = YES;
    self.typeImage.hidden = YES;
    self.more.hidden = NO;
    [self addSubview:self.more];
}

- (UILabel *)more {
    if (!_more) {
        _more = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _more.textColor = [UIColor whiteColor];
        _more.font = [UIFont systemFontOfSize:12];
        _more.textAlignment = NSTextAlignmentCenter;
        _more.text = @"查看更多";
    }
    return _more;
}

@end
