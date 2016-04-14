//
//  NumView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumView : UIView
@property (weak, nonatomic) IBOutlet UILabel *currentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;

+(instancetype)getNumView;

@end
