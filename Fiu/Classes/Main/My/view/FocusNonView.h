//
//  FocusNonView.h
//  Fiu
//
//  Created by THN-Dong on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusNonView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

+(instancetype)getFocusNonView;

@end