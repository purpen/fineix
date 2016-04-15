//
//  MyHomeV.h
//  Fiu
//
//  Created by THN-Dong on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeV : UIView
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *talentLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

+(instancetype)geMyHomeV;

@end
