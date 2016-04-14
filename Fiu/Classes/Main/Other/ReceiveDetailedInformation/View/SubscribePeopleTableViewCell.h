//
//  SubscribePeopleTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribePeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *focusOnImageView;
@property (weak, nonatomic) IBOutlet UIImageView *focusedImageView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn;

+(instancetype)getSubscribePeopleTableViewCell;
+(NSString*)getId;

@end
