//
//  SceneCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneCollectionViewCell.h"

@implementation SceneCollectionViewCell

-(void)setAllFiuSceneListData:(FiuSceneInfoData *)model{
    [super setAllFiuSceneListData:model];
    [self titleTextStyle:model.title];
}

- (void)titleTextStyle:(NSString *)title {
    if (title.length > 11) {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
        }];
    } else if (title.length <= 11) {
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@15);
        }];
    }
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]] ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.titleLab.attributedText = titleText;
}


@end
