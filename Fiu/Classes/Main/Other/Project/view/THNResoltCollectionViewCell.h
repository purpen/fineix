//
//  THNResoltCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2016/9/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNResoltCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
/**  */
@property(nonatomic,copy) NSString *prizeStr;

@end
