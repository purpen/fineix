//
//  THNCityCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/14.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNCityCollectionViewCell.h"
#import "CityModel.h"
#import "Masonry.h"

@interface THNCityCollectionViewCell ()

@property (nonatomic, strong) UILabel *name;
/**  */
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation THNCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_boder"]];
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.contentView).offset(0);
        }];
        [self.contentView addSubview:self.name];
    }
    return self;
}

- (void)setModel:(CityModel *)model
{
    self.name.text = model.name;
}

@end
