//
//  FocusOnTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;
@class TalentView;

@interface FocusOnTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nickNameLabel;
@property(nonatomic,strong) UILabel *summaryLabel;
@property(nonatomic,strong) UIButton *focusOnBtn;
@property(nonatomic,strong) UIView *lineView;
/** v */
@property (nonatomic, strong) TalentView *talentView;

-(void)setUIWithModel:(UserInfo*)model andType:(NSNumber*)type;

@end
