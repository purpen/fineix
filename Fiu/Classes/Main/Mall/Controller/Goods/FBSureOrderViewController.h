//
//  FBSureOrderViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBSureOrderViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong NSDictionary    *   orderDict;
@pro_strong FBRequest       *   buyingRequest;
@pro_strong FBRequest       *   addressRequest;
@pro_strong FBRequest       *   orderRrquest;

@pro_strong UITableView     *   orderTable;
@pro_strong UIView          *   sureView;
@pro_strong NSString        *   payPrice;
@pro_strong UILabel         *   sumPrice;
@pro_strong NSString        *   sendTime;
@pro_strong UIView          *   footerView;
@pro_strong UITextField     *   summaryText;

@end
