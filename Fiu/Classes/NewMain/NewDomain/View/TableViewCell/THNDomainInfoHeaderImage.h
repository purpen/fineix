//
//  THNDomainInfoHeaderImage.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "DominInfoData.h"
#import "SDCycleScrollView.h"

@interface THNDomainInfoHeaderImage : UIView <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *rollImageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *locImage;
@property (nonatomic, strong) UILabel *locLabel;

- (void)thn_setRollimageView:(DominInfoData *)model;

@end
