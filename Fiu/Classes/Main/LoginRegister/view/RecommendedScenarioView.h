//
//  RecommendedScenarioView.h
//  test5
//
//  Created by THN-Dong on 16/4/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedScenarioView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coversImageView;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;//订阅按钮
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberScenariosLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribeNumberLabel;

+(instancetype)getRecommendedScenarioView;

@end
