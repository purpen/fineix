//
//  RecommendedScenarioModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendedScenarioModel : NSObject

@property (nonatomic ,strong) NSString *covers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int subscription_count;
@property (nonatomic, assign) int id;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
