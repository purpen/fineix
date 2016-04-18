//
//  MyFansActionSheetView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyFansActionSheetView.h"
#import "Fiu.h"

@implementation MyFansActionSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 489/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 178/667.0*SCREEN_HEIGHT);
    }
    return self;
}

-(void)show:(UIView *)view{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
