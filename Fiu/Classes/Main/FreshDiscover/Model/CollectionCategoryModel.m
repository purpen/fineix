//
//  CollectionCategoryModel.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "CollectionCategoryModel.h"

@implementation StickModel


@end


@implementation Pro_categoryModel

+(instancetype)getPro_categoryModelWithTitle:(NSString *)title andCoverUrl:(NSString *)coverUrl{
    Pro_categoryModel *instance = [[Pro_categoryModel alloc] init];
    instance.title = title;
    instance.app_cover_url = coverUrl;
    return instance;
}

@end

@implementation SceneModel


@end

@implementation SightModel


@end

@implementation UsersModel


@end

@implementation CollectionCategoryModel


@end


