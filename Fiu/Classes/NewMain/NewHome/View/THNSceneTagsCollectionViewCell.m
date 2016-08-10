//
//  THNSceneTagsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneTagsCollectionViewCell.h"

@implementation THNSceneTagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellUI];
    }
    return self;
}

- (void)thn_setSceneTagsData:(NSString *)tagText {
    self.sceneTag.text = tagText;
}

- (void)setCellUI {
    [self addSubview:self.sceneTag];
    [_sceneTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
}

- (UILabel *)sceneTag {
    if (!_sceneTag) {
        _sceneTag = [[UILabel alloc] init];
        _sceneTag.backgroundColor = [UIColor colorWithHexString:@"#666666"];
        _sceneTag.textColor = [UIColor whiteColor];
        _sceneTag.font = [UIFont systemFontOfSize:12];
        _sceneTag.textAlignment = NSTextAlignmentCenter;
        _sceneTag.layer.cornerRadius = 2.0f;
        _sceneTag.layer.masksToBounds = YES;
    }
    return _sceneTag;
}

@end
