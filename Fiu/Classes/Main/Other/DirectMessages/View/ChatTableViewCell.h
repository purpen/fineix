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
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *otherHeadImg;
@property (weak, nonatomic) IBOutlet UIButton *oterhMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *meMsgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *meHeadImg;

-(void)setUIWithModel:(AXModel*)model;

@end
