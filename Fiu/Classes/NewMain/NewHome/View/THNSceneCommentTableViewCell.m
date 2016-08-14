//
//  THNSceneCommentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneCommentTableViewCell.h"

@implementation THNSceneCommentTableViewCell

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
- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel {
//    NSLog(@"－－－－－－－－－－－－－     评论%@", [contentModel.comments valueForKey:@"content"]);
    
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.graybackView];
    [_graybackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
}

#pragma mark - init
- (UIView *)graybackView {
    if (!_graybackView) {
        _graybackView = [[UIView alloc] init];
        _graybackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _graybackView;
}

@end
