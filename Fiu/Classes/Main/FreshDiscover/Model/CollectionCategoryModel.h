//
//  CollectionCategoryModel.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *web_url;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *cover_url;

@end

@interface Pro_categoryModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *app_cover_url;
@property (nonatomic, copy) NSString *back_url;
/**  */
@property(nonatomic,copy) NSString *cover_url;
+(instancetype)getPro_categoryModelWithTitle:(NSString*)title andCoverUrl:(NSString*)coverUrl;

@end

@interface SceneModel : NSObject

@property (nonatomic, strong) NSArray *sticks;
@property (nonatomic, strong) NSArray *categorys;

@end

@interface SightModel : NSObject

@property (nonatomic, strong) NSArray *sticks;
@property (nonatomic, strong) NSArray *categorys;

@end

@interface UsersModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *is_follow;

@end

@interface CollectionCategoryModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) StickModel *stickModel;
@property (nonatomic, strong) NSArray *pro_categorys;
@property (nonatomic, strong) SceneModel *sceneModel;
@property (nonatomic, strong) SightModel *sightModel;
@property (nonatomic, strong) NSArray *users;

@end


