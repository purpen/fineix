//
//  THNRemindTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemindTableViewCell.h"

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
    self.content.text = [NSString stringWithFormat:@"%@ %@ %@", model.sendUser.nickname, model.info, model.kindStr];
    self.time.text = model.createdAt;
    [self.sceneImg downloadImage:model.targetObj.coverUrl place:[UIImage imageNamed:@""]];
}

- (void)setCellUI {
    [self addSubview:self.headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
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
        make.height.equalTo(@15);
        make.left.equalTo(_headerImg.mas_right).with.offset(10);
        make.right.equalTo(_sceneImg.mas_left).with.offset(-10);
        make.top.equalTo(_headerImg.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.left.equalTo(_headerImg.mas_right).with.offset(10);
        make.right.equalTo(_sceneImg.mas_left).with.offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
}

- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] init];
        _headerImg.contentMode = UIViewContentModeScaleAspectFill;
        _headerImg.clipsToBounds = YES;
        _headerImg.layer.cornerRadius = 50/2;
        _headerImg.layer.masksToBounds = YES;
        _headerImg.layer.borderColor = [UIColor colorWithHexString:@"#F8F8F8"].CGColor;
        _headerImg.layer.borderWidth = 0.5f;
        _headerImg.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _headerImg;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor colorWithHexString:@"#666666"];
        _content.font = [UIFont systemFontOfSize:12];
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

@end
