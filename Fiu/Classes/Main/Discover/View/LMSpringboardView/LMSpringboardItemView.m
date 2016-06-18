//
//  LMSpringboardItemView.m
//  WatchSpringboard
//
//  Created by Lucas Menge on 10/24/14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//

#import "LMSpringboardItemView.h"
#import "UIImageView+CornerRadius.h"

@interface LMSpringboardItemView ()

@end

@implementation LMSpringboardItemView

- (instancetype)init {
  self = [super init];
  if(self) {
      _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
      [_icon zy_cornerRadiusRoundingRect];
      [self addSubview:_icon];
  }
  return self;
}

@end
