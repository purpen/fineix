//
//  ChatTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AXModel;

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) AXModel *message;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *myTextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *otherIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *otherTextBtn;
/** 导航控制器 */
@property (nonatomic, strong) UINavigationController *cellNavi;

@end
