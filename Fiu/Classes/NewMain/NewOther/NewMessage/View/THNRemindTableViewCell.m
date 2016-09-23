//
//  THNRemindTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemindTableViewCell.h"
#import "HomePageViewController.h"

@interface THNRemindTableViewCell () {
    NSString *_userID;
}

@end

@implementation THNRemindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

- (void)thn_setRemindData:(THNRemindModelRow *)model {
    [self.headerImg downloadImage:model.sendUser.avatarUrl place:[UIImage imageNamed:@""]];
    self.content.text = [NSString stringWithFormat:@"%@ %@%@\n%@", model.sendUser.nickname, model.info, model.kindStr, model.targetObj.content];
    self.time.text = model.createdAt;
    if (model.kind == 3) {
        [self.sceneImg downloadImage:model.commentTargetObj.coverUrl place:[UIImage imageNamed:@""]];
    } else {
        [self.sceneImg downloadImage:model.targetObj.coverUrl place:[UIImage imageNamed:@""]];
    }
    _userID = [NSString stringWithFormat:@"%zi", model.sUserId];
    if (model.readed == 1) {
        self.tips.hidden = YES;
    }
}

- (void)setCellUI {
    [self addSubview:self.headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.sceneImg];
    [_sceneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImg.mas_right).with.offset(10);
        make.right.equalTo(_sceneImg.mas_left).with.offset(-50);
        make.top.equalTo(_headerImg.mas_top).with.offset(0);
        make.height.equalTo(@35);
    }];
    
    [self addSubview:self.time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.right.equalTo(_sceneImg.mas_left).with.offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.left.equalTo(_headerImg.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.tips];
    [_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.right.equalTo(_sceneImg.mas_left).with.offset(-10);
        make.top.equalTo(_content.mas_top).with.offset(0);
    }];
}

- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] init];
        _headerImg.contentMode = UIViewContentModeScaleAspectFill;
        _headerImg.clipsToBounds = YES;
        _headerImg.layer.cornerRadius = 40/2;
        _headerImg.layer.masksToBounds = YES;
        _headerImg.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _headerImg.layer.borderWidth = 0.5f;
        _headerImg.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _headerImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *lookUserInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLookUserInfoTap:)];
        [_headerImg addGestureRecognizer:lookUserInfoTap];
    }
    return _headerImg;
}

- (void)goLookUserInfoTap:(UITapGestureRecognizer *)tap {
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.type = @2;
    vc.isMySelf = NO;
    vc.userId = _userID;
    [self.nav pushViewController:vc animated:YES];
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor colorWithHexString:@"#666666"];
        _content.font = [UIFont systemFontOfSize:12];
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor colorWithHexString:@"#999999"];
        _time.font = [UIFont systemFontOfSize:11];
    }
    return _time;
}

- (UIImageView *)sceneImg {
    if (!_sceneImg) {
        _sceneImg = [[UIImageView alloc] init];
        _sceneImg.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImg.clipsToBounds = YES;
        _headerImg.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _sceneImg;
}

- (UILabel *)tips {
    if (!_tips) {
        _tips = [[UILabel alloc] init];
        _tips.backgroundColor = [UIColor colorWithHexString:fineixColor];
        _tips.layer.cornerRadius = 6/2;
        _tips.layer.masksToBounds = YES;
    }
    return _tips;
}
@end
