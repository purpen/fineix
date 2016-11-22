//
//  THNShareCollectionReusableView.m
//  Fiu
//
//  Created by FLYang on 2016/11/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNShareCollectionReusableView.h"

@implementation THNShareCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_viewUI];
    }
    return self;
}

- (void)set_viewUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cancelButton];
    [self addSubview:self.lineLab];
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_cancelButton setTitle:NSLocalizedString(@"cancel", nil) forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
    }
    return _cancelButton;
}

- (UILabel *)lineLab {
    if (!_lineLab) {
        _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
        _lineLab.backgroundColor = [UIColor colorWithHexString:@"#999999" alpha:.8];
    }
    return _lineLab;
}

@end
