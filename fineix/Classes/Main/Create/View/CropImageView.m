//
//  CropImageView.m
//  fineix
//
//  Created by FLYang on 16/3/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CropImageView.h"

@implementation CropImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.image.userInteractionEnabled = YES;
//        self.image.contentMode = UIViewContentModeScaleAspectFill;
//        self.image.clipsToBounds  = YES;
//        [self.image setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        [self addSubview:self.image];
    }
    return self;
}

@end
