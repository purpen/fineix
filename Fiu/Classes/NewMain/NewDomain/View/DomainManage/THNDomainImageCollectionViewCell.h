//
//  THNDomainImageCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNDomainImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *domainImageView;


/**
 设置地盘图片

 @param imageUrl 图片链接
 */
- (void)thn_setDomainImage:(NSString *)imageUrl;

- (void)thn_setAddImage:(NSString *)addImage;

@end
