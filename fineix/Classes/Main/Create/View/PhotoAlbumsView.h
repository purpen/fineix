//
//  PhotoAlbumsView.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@interface PhotoAlbumsView : UIView <UITableViewDataSource, UITableViewDelegate>

@pro_strong UITableView     *   photoAlbumsTableView;    //     相册列表
@pro_strong NSMutableArray  *   photoAlbums;             //     相薄

@end
