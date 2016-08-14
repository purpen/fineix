//
//  THNFucosPeopleView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNFucosPeopleView.h"
#import "UIView+FSExtension.h"
#import "THNPeopleView.h"
#import "UIColor+Extension.h"

@implementation THNFucosPeopleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


-(void)setModelAry:(NSArray *)modelAry{
    _modelAry = modelAry;
    for (int i = 0; i < modelAry.count; i ++) {
        
        float w = (self.width - 10 * 2 - 5 * 2) / 3;
        float h = (self.height - 5) * 0.5;
        float x = 10 + (i % 3) * (5 + w);
        float y = 0 + (i % 2) * (h + 5);
        
        THNPeopleView *view = [THNPeopleView viewFromXib];
        view.model = modelAry[i];
        view.frame = CGRectMake(x, y, w, h);
        view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:view];
        
    }
}

@end
