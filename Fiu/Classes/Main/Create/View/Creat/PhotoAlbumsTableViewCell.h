//
//  PhotoAlbumsTableViewCell.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface PhotoAlbumsTableViewCell : UITableViewCell

@pro_strong UIImageView     *   coverImage;       //    相册封面
@pro_strong UILabel         *   titleLab;         //    相册名称
@pro_strong UILabel         *   photoCount;       //    相片数量

- (void)setPhotoAlbumsData:(NSDictionary *)photoAlbum;

@end
