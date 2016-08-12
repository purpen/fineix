//
//  THNTopicView.h
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNTopicsModel;

@interface THNTopicView : UIView

/**  */
@property (nonatomic, strong) THNTopicsModel *model;
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UIView *layerView;

@end
