//
//  LocationViewController.h
//  BaDuMapTest1
//
//  Created by THN-Dong on 16/3/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationViewControllerProtocol <NSObject>

-(void)getAddress:(NSString*)address;

@end

@interface FBSearchLocationViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *dataAry3;
@property (nonatomic, weak) id <LocationViewControllerProtocol> daleget;
@end
