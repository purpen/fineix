//
//  THNDomainImageCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainImageCollectionViewCell.h"

@implementation THNDomainImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self addSubview:self.domainImageView];
    }
    return self;
}

- (void)thn_setAddImage:(NSString *)addImage {
    self.domainImageView.image = [UIImage imageNamed:addImage];
}

- (void)thn_setDomainImage:(NSString *)imageUrl {
    [self.domainImageView downloadImage:imageUrl place:[UIImage imageNamed:@""]];
}

- (UIImageView *)domainImageView {
    if (!_domainImageView) {
        _domainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _domainImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _domainImageView;
}

@end
