//
//  ShareStyleTopView.h
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface ShareStyleTopView : UIView

@pro_strong UIImageView         *   sceneImg;       //  场景图
@pro_strong UIView              *   userView;       //  用户视图
@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UILabel             *   userAbout;      //  用户简介
@pro_strong UILabel             *   address;        //  地址
@pro_strong UIButton            *   addressIcon;    //  地址图标
@pro_strong UILabel             *   title;          //  标题
@pro_strong UIView              *   describeView;   //  内容视图
@pro_strong UILabel             *   describe;       //  描述
@pro_strong UIButton            *   describeIcon;   //  描述尾部
@pro_strong UIButton            *   sloganIcon;
@pro_strong UILabel             *   fiuSlogan;
@pro_strong UIImageView         *   qrCode;         //  二维码
@pro_strong UIButton            *   fiuLogo;        //  logo

- (void)setShareSceneData:(NSDictionary *)model;

- (void)defultTitleFontStyle;
- (void)smallTitleFontStyle;
- (void)changeWithSearchText:(NSString *)title withDes:(NSString *)des;

@end
