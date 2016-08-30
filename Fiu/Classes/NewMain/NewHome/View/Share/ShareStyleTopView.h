//
//  ShareStyleTopView.h
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "HomeSceneListRow.h"

@interface ShareStyleTopView : UIView

@pro_strong UIImageView         *   sceneImg;       //  场景图
@pro_strong UIView              *   userView;       //  用户视图
@pro_strong UIImageView         *   userVimg;       //  加V
@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UIView              *   describeView;   //  内容视图
@pro_strong UILabel             *   describe;       //  描述
@pro_strong UIButton            *   describeIcon;   //  描述尾部
@pro_strong UIImageView         *   qrCode;         //  二维码
@pro_strong UIButton            *   fiuLogo;        //  logo
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UIButton *time;
@pro_strong UIButton *address;
@pro_strong UIImageView *grayView;
@pro_strong UIButton *slogan;
@pro_strong UIButton *fiuSlogan;

- (void)setShareSceneData:(HomeSceneListRow *)sceneModel;
- (void)changeWithSearchText:(NSString *)title withDes:(NSString *)des;

@end
