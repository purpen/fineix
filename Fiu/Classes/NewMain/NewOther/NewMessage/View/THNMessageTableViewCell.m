//
//  THNMessageTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMessageTableViewCell.h"

@interface THNMessageTableViewCell () {
    NSArray *_typeTitleArr;
}

@end

@implementation THNMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _typeTitleArr = @[NSLocalizedString(@"Mes_SystemNotification", nil),
                          NSLocalizedString(@"Mes_Comment", nil),
                          NSLocalizedString(@"Mes_Chat", nil),
                          NSLocalizedString(@"Mes_Remind", nil),
                          NSLocalizedString(@"Mes_Fans", nil)];
        
        [self setCellUI];
    }
    return self;
}

- (void)thn_setMessageData:(NSInteger)index withCount:(THNUserModelCounter *)model {
    self.title.text = _typeTitleArr[index];
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_message_%zi", index]];
    if (index == _typeTitleArr.count - 1) {
        self.botLine.hidden = YES;
    }
    
    switch (index) {
        case 0:
            [self thn_setCountPopText:model.fiuNoticeCount];
            break;
        case 1:
            [self thn_setCountPopText:model.fiuCommentCount];
            break;
        case 2:
            [self thn_setCountPopText:model.messageCount];
            break;
        case 3:
            [self thn_setCountPopText:model.fiuAlertCount];
            break;
        case 4:
            [self thn_setCountPopText:model.fansCount];
            break;
        default:
            break;
    }
}

- (void)thn_setCountPopText:(NSInteger)count {
    if (count <= 0) {
        self.countPop.hidden = YES;
    } else {
        NSString *countStr = [NSString stringWithFormat:@"%zi", count];
        self.countPop.hidden = NO;
        self.countPop.text = countStr;
        CGFloat countWidth = [countStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                                    options:(NSStringDrawingUsesFontLeading)
                                                 attributes:nil
                                                    context:nil].size.width + 1.0f;
        if (countWidth > 20.0f) {
            [self.countPop mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(countWidth));
            }];
        }
    }
}

- (void)thn_hiddenCountPop:(BOOL)isHidden {
    self.countPop.hidden = isHidden;
}

- (void)setCellUI {
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.mas_left).with.offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 44));
        make.left.equalTo(_icon.mas_right).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.next];
    [_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(self.mas_right).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.countPop];
    [_countPop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.equalTo(self.mas_right).with.offset(-35);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 1));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeCenter;
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _title;
}

- (UILabel *)countPop {
    if (!_countPop) {
        _countPop = [[UILabel alloc] init];
        _countPop.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        _countPop.font = [UIFont systemFontOfSize:9];
        _countPop.textColor = [UIColor whiteColor];
        _countPop.textAlignment = NSTextAlignmentCenter;
        _countPop.layer.cornerRadius = 18/2;
        _countPop.layer.masksToBounds = YES;
    }
    return _countPop;
}

- (UIImageView *)next {
    if (!_next) {
        _next = [[UIImageView alloc] init];
        _next.image = [UIImage imageNamed:@"button_right_next"];
        _next.contentMode = UIViewContentModeCenter;
    }
    return _next;
}

- (UILabel *)botLine {
    if (!_botLine) {
        _botLine = [[UILabel alloc] init];
        _botLine.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    }
    return _botLine;
}

@end
