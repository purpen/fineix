//
//  SearchView.h
//  Fiu
//
//  Created by THN-Dong on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTF;

@interface SearchView : UIView

/**  */
@property (nonatomic, strong) SearchTF *searchTF;
/**  */
@property (nonatomic, strong) UIButton *cancelBtn;
/**  */
@property (nonatomic, strong) UIView *topView;

@end
