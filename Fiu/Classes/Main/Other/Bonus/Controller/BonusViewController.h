//
//  BonusViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@protocol BounsDelegate <NSObject>

-(void)getBounsCode:(NSString *)code andBounsNum:(NSNumber*)amount;

@end

@interface BonusViewController : FBViewController

@property(nonatomic,strong) NSString *rid;
@property(nonatomic,weak) id<BounsDelegate>bounsDelegate;

@end
