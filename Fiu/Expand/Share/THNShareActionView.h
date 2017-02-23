//
//  THNShareActionView.h
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNShareActionView : UIView

@property (nonatomic, strong) UILabel *headerlable;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *goldImage;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UIButton *lookButton;
@property (nonatomic, strong) UIControl *overlayView;

+ (void)showShareTitle;

- (void)thn_creatShareButton:(NSArray *)title iconImage:(NSArray *)iconImage;

@end
