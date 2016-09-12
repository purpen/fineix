//
//  THNCuXiaoDetalTopView.h
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCuXiaoDetalModel;

@interface THNCuXiaoDetalTopView : UIView

/**  */
@property (nonatomic, strong) THNCuXiaoDetalModel *model;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
