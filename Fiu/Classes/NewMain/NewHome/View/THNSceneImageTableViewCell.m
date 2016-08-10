//
//  THNSceneImageTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageTableViewCell.h"

@interface THNSceneImageTableViewCell () {
    NSString *_titleStr;
    NSString *_suTitleStr;
}

@end

@implementation THNSceneImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel
- (void)thn_setSceneImageData:(HomeSceneListRow *)sceneModel {
    [self.sceneImage sd_setImageWithURL:[NSURL URLWithString:sceneModel.coverUrl]
                               forState:(UIControlStateNormal)
                       placeholderImage:[UIImage imageNamed:@""]];
    
    if (sceneModel.title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        
    } else if (sceneModel.title.length > 10) {
        NSString * title = [sceneModel.title substringToIndex:10];
        _titleStr = [NSString stringWithFormat:@"    %@  ", title];
        self.title.text = _titleStr;
        
        NSString * suTitle = [sceneModel.title substringFromIndex:10];
        _suTitleStr = [NSString stringWithFormat:@"    %@  ", suTitle];
        self.suTitle.text = _suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:_suTitleStr].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:_titleStr].width));
            make.bottom.equalTo(self.mas_bottom).with.offset(-48);
        }];
        
    } else {
        NSString * title = [NSString stringWithFormat:@"    %@  ", sceneModel.title];
        self.title.text = title;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTextSizeWidth:title].width));
        }];
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.sceneImage];
    [_sceneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
}

#pragma mark - init
- (UIButton *)sceneImage {
    if (!_sceneImage) {
        _sceneImage = [[UIButton alloc] init];
        _sceneImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImage.imageView.clipsToBounds = YES;
        [_sceneImage addTarget:self action:@selector(sceneImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sceneImage;
}

- (void)sceneImageClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"全屏查看大图"];
}

- (void)goodsBtn:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"打开商品"];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _title.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _suTitle.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _suTitle.font = [UIFont systemFontOfSize:17];
    }
    return _suTitle;
}

@end
