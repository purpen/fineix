//
//  ExpressInfoModel.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/25.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressInfoModel : NSObject

@property (nonatomic, strong) NSString * address;       //详细地址
//@property (nonatomic, strong) NSObject * area;
@property (nonatomic, strong) NSString * city;          //城市
//@property (nonatomic, strong) NSObject * email;
@property (nonatomic, strong) NSString * name;          //姓名
@property (nonatomic, strong) NSString * phone;         //手机
@property (nonatomic, strong) NSString * province;      //省
@property (nonatomic, assign) NSInteger zip;            //邮编

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
