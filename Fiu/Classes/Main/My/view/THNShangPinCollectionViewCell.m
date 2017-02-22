//
//  THNShangPinCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNShangPinCollectionViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "UIImageView+WebCache.h"

@interface THNShangPinCollectionViewCell ()

/**  */
@property (nonatomic, strong) UIImageView *iconImageView;
/**  */
@property (nonatomic, strong) UILabel *textLabel;
/**  */
@property (nonatomic, strong) UILabel *priceLabel;
/**  */
@property (nonatomic, strong) UIImageView *goImageView;

@end

@implementation THNShangPinCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

@end
