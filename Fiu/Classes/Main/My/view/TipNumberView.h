//
//  TipNumberView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipNumberView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipNumLabel;

+(instancetype)getTipNumView;

@end
