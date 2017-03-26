//
//  MyFansViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@protocol MyFansViewControllerDelegate <NSObject>

-(void)updateTheFansQuantity:(NSInteger)num;

@end

@interface MyFansViewController : FBViewController

@property(nonatomic,strong) UITableView *mytableView;
@property(nonatomic,copy) NSString *userId;
/**有几条新通知  */
@property (nonatomic, assign) NSInteger num;
/**
 *  是否清除提醒
 *  0:不清除／1:清除
 */
@property (nonatomic, strong) NSString *cleanRemind;
@property(nonatomic,weak) id<MyFansViewControllerDelegate>fansQuantityDelegate;

@end
