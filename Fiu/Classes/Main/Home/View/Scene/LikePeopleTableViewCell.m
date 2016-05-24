//
//  LikePeopleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "LikePeopleTableViewCell.h"
#import "HomePageViewController.h"

const static NSInteger  peopleBtnTag = 64;

@implementation LikePeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgMarr = [NSMutableArray array];
        self.userIdMarr = [NSMutableArray array];
    }
    return self;
}

- (void)setLikeOrSuPeopleData:(NSMutableArray *)model {
    if (model.count > 0) {
        for (LikeOrSuPeopleRow * row in model) {
            [self.imgMarr addObject:row.user.avatarUrl];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", row.user.userId]];
        }
        
        [self addLikePeopleHeader:model image:self.imgMarr];
        
        CGFloat num = model.count;
        if (num/100 > 1) {
            [_morePeopel setTitle:[NSString stringWithFormat:@"%.0f00＋", num/100] forState:(UIControlStateNormal)];
        }
        if (num/10 > 1) {
            [_morePeopel setTitle:[NSString stringWithFormat:@"%.0f0＋", num/10] forState:(UIControlStateNormal)];
        }
        if (num/1000 > 1) {
            [_morePeopel setTitle:[NSString stringWithFormat:@"%.0fk＋", num/1000] forState:(UIControlStateNormal)];
        }
    }

}

#pragma mark - 加载用户的头像
- (void)addLikePeopleHeader:(NSArray *)people image:(NSMutableArray *)imgUrl {
    if (people.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    CGFloat btnW = 0;
    CGFloat btnH = 15;
    
    for (NSInteger idx = 0; idx < people.count; ++idx) {
        UIButton * peopleBtn = [[UIButton alloc] init];
        
        peopleBtn.frame = CGRectMake(15 + btnW, btnH, 30, 30);
        peopleBtn.layer.cornerRadius = 15;
        peopleBtn.layer.masksToBounds = YES;
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
        
        [peopleBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl[idx]] forState:(UIControlStateNormal)];
        peopleBtn.tag = peopleBtnTag + idx;
        [peopleBtn addTarget:self action:@selector(peopleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:peopleBtn];
    }
}

//  查看用户的资料
- (void)peopleBtnClick:(UIButton *)button {
    HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
    peopleHomeVC.isMySelf = NO;
    peopleHomeVC.type = @2;
    peopleHomeVC.userId = self.userIdMarr[button.tag - peopleBtnTag];
    [self.nav pushViewController:peopleHomeVC animated:YES];
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
    if (people.count == 0) {
        self.cellHeight = 0.01f;
        
    } else if (people.count * 45 < SCREEN_WIDTH) {
        self.cellHeight = 60;
    } else if (people.count * 45 > SCREEN_WIDTH) {
        self.cellHeight = 100;
    }
}

@end
