//
//  RecommendedScenarioView.m
//  test5
//
//  Created by THN-Dong on 16/4/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "RecommendedScenarioView.h"

@implementation RecommendedScenarioView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getRecommendedScenarioView{
    return [[NSBundle mainBundle] loadNibNamed:@"RecommendedScenarioView" owner:nil options:nil][0];
}


@end
