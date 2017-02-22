//
//  THNCarServiceTextView.m
//  Fiu
//
//  Created by FLYang on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNCarServiceTextView.h"

@implementation THNCarServiceTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        NSArray *titleArr = @[@"∙ 7天无忧退货", @"∙ 48小时快速退款", @"∙ 满99免邮费"];
        [self thn_creatServiceTextTitle:titleArr];
    }
    return self;
}

- (void)thn_creatServiceTextTitle:(NSArray *)titleArr {
    for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 3) * idx, 0, SCREEN_WIDTH / 3, 40)];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = titleArr[idx];
        [self addSubview:textLabel];
    }
}

@end
