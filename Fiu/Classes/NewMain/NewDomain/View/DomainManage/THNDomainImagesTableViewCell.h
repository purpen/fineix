//
//  THNDomainImagesTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNDomainManageInfoNCover.h"

@interface THNDomainImagesTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UICollectionView *imageCollection;
@property (nonatomic, strong) NSMutableArray *imageUrlMarr;
@property (nonatomic, strong) NSMutableArray *imageIdMarr;
@property (nonatomic, strong) FBRequest *uploadImageRequest;

- (void)thn_setDomainImages:(NSArray *)images withDomainId:(NSString *)domainId;

@end
