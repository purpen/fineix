//
//  THNShareCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNShareCollectionViewCell.h"

@implementation THNShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)set_cellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shareIcon];
    [_shareIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.mas_centerY).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.shareTitle];
    [_shareTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@13);
        make.top.equalTo(_shareIcon.mas_bottom).with.offset(7);
        make.left.right.equalTo(self).with.offset(0);
    }];
}

- (UIImageView *)shareIcon {
    if (!_shareIcon) {
        _shareIcon = [[UIImageView alloc] init];
        _shareIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shareIcon;
}

- (UILabel *)shareTitle {
    if (!_shareTitle) {
        _shareTitle = [[UILabel alloc] init];
        _shareTitle.font = [UIFont systemFontOfSize:12];
        _shareTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        _shareTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _shareTitle;
}

@end
