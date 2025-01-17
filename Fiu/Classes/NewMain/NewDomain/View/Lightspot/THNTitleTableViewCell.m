//
//  THNTitleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNTitleTableViewCell.h"

@implementation THNTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.title];
        [self addSubview:self.line];
    }
    return self;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    }
    return _line;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 30)];
        _title.textColor = [UIColor colorWithHexString:@"#666666"];
        _title.font = [UIFont boldSystemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text = @"地盘特色";
    }
    return _title;
}

@end
