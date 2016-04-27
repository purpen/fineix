//
//  AXModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AXModel : NSObject

typedef enum{
    AXModelTypeMe,
    AXModelTypeOther
}AXModelType;

@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,assign) AXModelType type;

@property(nonatomic,copy) NSString *lastTime;

@end
