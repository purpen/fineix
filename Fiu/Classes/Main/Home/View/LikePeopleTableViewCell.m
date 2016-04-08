//
//  LikePeopleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "LikePeopleTableViewCell.h"

const static NSInteger  peopleBtnTag = 64;

@implementation LikePeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    NSArray * arr = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    [self addLikePeopleHeader:arr];
    
    [_morePeopel setTitle:@"300" forState:(UIControlStateNormal)];
}

#pragma mark - 加载用户的头像
- (void)addLikePeopleHeader:(NSArray *)people {
    CGFloat btnW = 0;
    CGFloat btnH = 15;
    
    for (NSInteger idx = 0; idx < people.count; ++idx) {
        UIButton * peopleBtn = [[UIButton alloc] init];
        
        peopleBtn.frame = CGRectMake(15 + btnW, btnH, 30, 30);
        //  超出屏幕宽度折行
        if (15 + btnW > SCREEN_WIDTH - 30) {
            btnW = 0;
            btnH = btnH + peopleBtn.frame.size.height + 10;
            peopleBtn.frame = CGRectMake(15 + btnW, btnH, 30, 30);
        }
        btnW = peopleBtn.frame.size.width + peopleBtn.frame.origin.x;
        
        //  超过两行
        if (idx * 45 > (SCREEN_WIDTH - 30) * 2 - 80) {
            [self addSubview:self.morePeopel];
            [_morePeopel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(72, 28.5));
                make.right.equalTo(self.mas_right).with.offset(-15);
                make.top.equalTo(self.mas_top).with.offset(55);
            }];
            
            break;
        }
        
        peopleBtn.layer.cornerRadius = 30/2;
        [peopleBtn setBackgroundImage:[UIImage imageNamed:@"user"] forState:(UIControlStateNormal)];
        peopleBtn.tag = peopleBtnTag + idx;
        [peopleBtn addTarget:self action:@selector(peopleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:peopleBtn];
    }
}

//  查看用户的资料
- (void)peopleBtnClick:(UIButton *)button {
    NSLog(@"＝＝＝＝＝＝＝＝＝＝查看第 %zi 个用户", button.tag - peopleBtnTag);
}

#pragma mark - 查看更多用户
- (UIButton *)morePeopel {
    if (!_morePeopel) {
        _morePeopel = [[UIButton alloc] init];
        [_morePeopel setBackgroundImage:[UIImage imageNamed:@"peopleNum"] forState:(UIControlStateNormal)];
        _morePeopel.titleLabel.font = [UIFont systemFontOfSize:Font_Tag];
    }
    return _morePeopel;
}

#pragma mark - 获取高度
- (void)getCellHeight:(NSArray *)people {
    if (people.count * 45 < SCREEN_WIDTH) {
        self.cellHeight = 60;
    } else if (people.count * 45 > SCREEN_WIDTH) {
        self.cellHeight = 100;
    }
}

@end
