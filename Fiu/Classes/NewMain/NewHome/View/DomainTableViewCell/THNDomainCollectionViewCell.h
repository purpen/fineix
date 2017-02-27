//
//  THNDomainCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "NiceDomainRow.h"
#import "HelpUserRow.h"

@interface THNDomainCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *iconImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIView *backView;

- (void)thn_setDomainDataModel:(NiceDomainRow *)model;

- (void)thn_setHelpUserDataModel:(HelpUserRow *)model;

@end
