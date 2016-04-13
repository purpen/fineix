//
//  MallMenuCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface MallMenuCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView         *   menuImg;    //  导航图
@pro_strong UILabel             *   menuTitle;  //  导航标题

- (void)setUI:(NSString *)title;

@end
