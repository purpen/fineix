//
//  MyFansActionSheetViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNUserData;
@class FindFriendModel;

@interface MyFansActionSheetViewController : UIViewController

@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIView *firstView;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *sheetLabel;
@property(nonatomic,strong) UIButton *stopBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *otherBtn;

-(void)setUIWithModel:(THNUserData*)model;

/**  */
@property (nonatomic, strong) FindFriendModel *findFriendModel;

@end
