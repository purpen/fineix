//
//  MyHomePageView.h
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomePageView : UIView
+(instancetype)getMyHomePageView;
@property(nonatomic,strong) UIImageView                 *   sceneImage;     //  情景图片
@property(nonatomic,strong) UILabel                     *   titleLab;       //  情景标题
@property(nonatomic,strong) UIImageView                 *   locationIcon;   //  地理位置图标
@property(nonatomic,strong) UILabel                     *   locationLab;    //  地理位置

- (void)setUI;

@end
