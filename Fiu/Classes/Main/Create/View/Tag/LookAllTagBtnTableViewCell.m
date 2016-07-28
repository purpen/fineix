//
//  LookAllTagBtnTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "LookAllTagBtnTableViewCell.h"

@implementation LookAllTagBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lookAll];
        
    }
    return self;
}

- (UIButton *)lookAll {
    if (!_lookAll) {
        _lookAll = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 30)];
        [_lookAll setTitle:NSLocalizedString(@"lookAll", nil) forState:(UIControlStateNormal)];
        [_lookAll setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _lookAll.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        } else {
            _lookAll.titleLabel.font = [UIFont systemFontOfSize:11];
        }
        [_lookAll setImage:[UIImage imageNamed:@"icon_upward_down"] forState:(UIControlStateNormal)];
        [_lookAll setTitleEdgeInsets:(UIEdgeInsetsMake(-10, -10, 0, 0))];
        [_lookAll setImageEdgeInsets:(UIEdgeInsetsMake(20, 20, 0, 0))];
        
        for (NSInteger idx = 0; idx < 2; ++ idx) {
            UILabel * li = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 + 20) * idx, 10, (SCREEN_WIDTH - 40) / 2, 1)];
            li.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            [_lookAll addSubview:li];
        }
    
        _lookAll.userInteractionEnabled = NO;
        
    }
    return _lookAll;
}

@end
