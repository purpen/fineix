//
//  MyPageFocusOnViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@protocol MyPageFocusOnViewControllerDelegate <NSObject>

-(void)updateTheFocusQuantity:(NSInteger)num;

@end

@interface MyPageFocusOnViewController : FBViewController

@property(nonatomic,strong) UITableView *mytableView;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,weak) id<MyPageFocusOnViewControllerDelegate>focusQuantityDelegate;

@end
