//
//  NoHaveSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NoHaveSceneTableViewCell.h"

@implementation NoHaveSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        
    }
    return self;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 30));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
        make.bottom.equalTo(self.content.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.addNew];
    [_addNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 44));
        make.centerX.equalTo(self);
        make.top.equalTo(self.content.mas_bottom).with.offset(20);
    }];
}

#pragma mark -
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:18];
        _title.text = NSLocalizedString(@"creatNewFiuScene", nil);
        _title.textColor = [UIColor colorWithHexString:titleColor];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

#pragma mark -
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize:12];
        _content.text = NSLocalizedString(@"NoScene", nil);
        _content.textColor = [UIColor colorWithHexString:@"#999999"];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.numberOfLines = 0;
    }
    return _content;
}

#pragma mark -
- (UILabel *)addNew {
    if (!_addNew) {
        _addNew = [[UILabel alloc] init];
        _addNew.font = [UIFont systemFontOfSize:16];
        _addNew.text = NSLocalizedString(@"creatFiuSceneBtn", nil);
        _addNew.textColor = [UIColor whiteColor];
        _addNew.backgroundColor = [UIColor colorWithHexString:fineixColor];
        _addNew.layer.cornerRadius = 5;
        _addNew.layer.masksToBounds = YES;
        _addNew.textAlignment = NSTextAlignmentCenter;
    }
    return _addNew;
}

@end
