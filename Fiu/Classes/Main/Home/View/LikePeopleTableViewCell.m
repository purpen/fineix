//
//  LikePeopleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "LikePeopleTableViewCell.h"

@implementation LikePeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
