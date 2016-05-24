//
//  FBLoadPhoto.h
//  fineix
//
//  Created by FLYang on 16/2/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBPhoto.h"

@interface FBLoadPhoto : NSObject

//  加载相片
+ (void)loadAllPhotos:(void (^)(NSArray * photos, NSArray * photoAlbums, NSError * error))completion;

@end
