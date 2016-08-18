//
//  THNSenceTopicView.h
//  Fiu
//
//  Created by dys on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNTopicsModel;

@interface THNSenceTopicView : UIView

@property (nonatomic, strong) THNTopicsModel *model;
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UIView *layerView;

@end
