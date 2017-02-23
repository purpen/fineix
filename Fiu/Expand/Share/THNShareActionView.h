//
//  THNShareActionView.h
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface THNShareActionView : UIView

@property (nonatomic, strong) UILabel *headerlable;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *goldImage;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UIButton *lookButton;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UMSocialMessageObject *shareMessageObject;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) NSString *linkUrl;

/**
 调用分享功能

 @param controller 当前所在控制器
 @param object 分享的数据内容
 @param linkUrl 分享的链接（可为nil）
 */
+ (void)showShare:(UIViewController *)controller shareMessageObject:(UMSocialMessageObject *)object linkUrl:(NSString *)linkUrl;

- (void)thn_creatShareButton:(NSArray *)title iconImage:(NSArray *)iconImage;

@end
