//
//  THNXiangGuanQingJingTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THNXIANGGuanQingJingTableViewCell @"THNXiangGuanQingJingTableViewCell"

@interface THNXiangGuanQingJingTableViewCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) UINavigationController *nav;
/**  */
@property(nonatomic,copy) NSString *string;
/**  */
@property (nonatomic, strong) UIViewController *vc;
/**  */
@property (nonatomic, strong) UILabel *biaoTiLabel;
/**  */
@property (nonatomic, assign) CGFloat cellHeight;

-(void)haModelAry:(NSMutableArray*)ary;

@end
