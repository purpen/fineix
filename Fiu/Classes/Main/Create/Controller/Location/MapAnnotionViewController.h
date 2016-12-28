//
//  MapAnnotionViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/7/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

@protocol MapannotionDelegate <NSObject>

-(void)mapAnnoWithName:(NSString *)name andCity:(NSString *)city andLat:(NSString*)lat andLon:(NSString*)lon;

@end

@interface MapAnnotionViewController : FBPictureViewController

/** 第一个地理位置名字 */
@property(nonatomic,strong) NSMutableArray *nameAry;
/** 纬度 */
@property (nonatomic, strong) NSMutableArray *latAry;
/** 经度 */
@property (nonatomic, strong) NSMutableArray *lonAry;
/**  */
@property(nonatomic,strong) NSMutableArray *cityAry;


@property (nonatomic, weak) id<MapannotionDelegate> map_delegate;

@end
