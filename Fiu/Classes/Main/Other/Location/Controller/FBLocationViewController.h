//
//  FBLocationViewController.h
//  BaDuMapTest1
//
//  Created by THN-Dong on 16/3/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FBLocationViewControllerProtocol <NSObject>

-(void)getAddress:(NSString*)address;

@end
@interface FBLocationViewController : UIViewController
@property (nonatomic, weak) id <FBLocationViewControllerProtocol> daleget;
@end
