//
//  CatagoryFiuSceneModel.h
//  Fiu
//
//  Created by FLYang on 16/7/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatagoryFiuSceneModel : NSObject

@property (nonatomic, strong) NSString * categoryTitle;
@property (nonatomic, assign) NSInteger  categoryId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
