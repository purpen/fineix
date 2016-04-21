//
//  MyQrCodeView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQrCodeView : UIView

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *sexLabel;
@property(nonatomic,strong) UIImageView *mapImageView;
@property(nonatomic,strong) UILabel *adressLabel;
@property(nonatomic,strong) UIImageView *qrCodeImageView;

-(void)setUI;

@end
