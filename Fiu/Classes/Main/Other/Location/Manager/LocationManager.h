//
//  LocationManager.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol locationManagerDelegate <NSObject>

-(void)setLocalCityStr:(NSString*)str;

@end

@interface LocationManager : NSObject

/**  */
@property (nonatomic, weak) id <locationManagerDelegate> locationDelegate;

+ (LocationManager *)shareLocation;
- (void)findMe;

@end
