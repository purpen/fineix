//
//  PersonLabelPickerViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@protocol PersonLabelDelegate <NSObject>

-(void)personLabelStr:(NSString*)str;

@end

@interface PersonLabelPickerViewController : FBViewController
/** 标签 */
@property (nonatomic, strong) NSString *personLabelstr;
/**  */
@property (nonatomic, weak) id<PersonLabelDelegate> personDelegate;
@end
