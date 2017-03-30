//
//  THNDomianLightViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomianLightViewController.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import "THNLightspotTextAttachment.h"

static NSString *const TEXT_TAG = @"[text]:!";
static NSString *const IMAGE_TAG = @"[img]:!";

@interface THNDomianLightViewController ()

@end

@implementation THNDomianLightViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentInputBox];
}

- (UITextView *)contentInputBox {
    if (!_contentInputBox) {
        _contentInputBox = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _contentInputBox.showsVerticalScrollIndicator = NO;
        _contentInputBox.editable = NO;
        _contentInputBox.backgroundColor = [UIColor whiteColor];
        _contentInputBox.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _contentInputBox;
}

//- (void)thn_setBrightSpotData:(NSArray *)model {
//    [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
//    
//    NSMutableArray *totalTextMarr = [NSMutableArray array];
//
//    for (NSString *str in model) {
//        //  文字内容
//        if ([str containsString:@"[text]:!"]) {
//            NSString *textStr;
//            textStr = [str substringFromIndex:8];
//            [self.textMarr addObject:textStr];
//            [totalTextMarr addObject:textStr];
//        }
//        
//        //  图片内容
//        if ([str containsString:@"[img]:!"]) {
//            NSString *imageStr;
//            imageStr = [str substringFromIndex:7];
//            [self.imageMarr addObject:imageStr];
//            [totalTextMarr addObject:imageStr];
//        }
//    }
//    
//    NSString *totalText = [totalTextMarr componentsJoinedByString:@"\n"];
//    
//    if (self.imageMarr.count == 0) {
//        [self thn_setLightSporText:totalText];
//    
//    } else {
//        for (NSString *imageUrl in self.imageMarr) {
//            NSInteger imageLocation = [totalText rangeOfString:imageUrl].location;
//            [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", imageLocation]];
//            totalText = [totalText stringByReplacingOccurrencesOfString:imageUrl withString:@""];
//        }
//        
//        [self thn_setLightSporText:totalText];
//    }
//}
//
//- (void)thn_setLightSporText:(NSString *)text {
//    [self getAttributedStringWithString:text];
//}
//
//- (void)getAttributedStringWithString:(NSString *)string {
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:[self set_attributesDictionary]];
//    self.contentInputBox.attributedText = attributedString;
//    
//    [SVProgressHUD showWithStatus:@"图片加载中..."];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
//            NSString *imageUrl = self.imageMarr[idx];
//            
//            THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
//            attachment.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
//            
//            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
//            [attributedString insertAttributedString:imageAttributedString atIndex:[self.imageIndexMarr[idx] integerValue]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.contentInputBox.attributedText = attributedString;
//            });
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//    });
//}
//
//
//
//#pragma mark - 正文样式
//- (NSDictionary *)set_attributesDictionary {
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.lineSpacing = 5.0f;
//    paragraphStyle.minimumLineHeight = 5.0;
//    
//    NSDictionary *attributesDict = @{
//                                     NSParagraphStyleAttributeName:paragraphStyle,
//                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"],
//                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
//                                     };
//    return attributesDict;
//}

#pragma mark - 初始展示的亮点内容
- (void)thn_setBrightSpotData:(NSArray *)model {
    [self thn_removeAllObjects];
    
    NSMutableArray *totalTextMarr = [NSMutableArray array];
    for (NSString *str in model) {
        //  文字内容
        if ([str containsString:TEXT_TAG]) {
            NSString *textStr;
            textStr = [str substringFromIndex:TEXT_TAG.length];
            [self.textMarr addObject:textStr];
            [totalTextMarr addObject:textStr];
        }
        
        //  图片内容
        if ([str containsString:IMAGE_TAG]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:IMAGE_TAG.length];
            [self.imageMarr addObject:imageStr];
            [totalTextMarr addObject:imageStr];
        }
    }
    
    NSString *totalText = [totalTextMarr componentsJoinedByString:@""];
    
    if (self.imageMarr.count > 0) {
        for (NSString *imageUrl in self.imageMarr) {
            NSInteger imageLocation = [totalText rangeOfString:imageUrl].location;
            [self.imageLocationMarr addObject:[NSString stringWithFormat:@"%zi", imageLocation]];
            totalText = [totalText stringByReplacingOccurrencesOfString:imageUrl withString:@"^"];
        }
    }
    
    [self thn_getAttributedStringWithString:totalText];
}

- (void)thn_getAttributedStringWithString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"^" withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:[self set_attributesDictionary]];
    self.contentInputBox.attributedText = attributedString;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"图片加载中..."];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
            NSString *imageUrl = self.imageMarr[idx];
            
            UIImage *insertImage = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
            THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
            attachment.image = insertImage;
            attachment.imageURL = imageUrl;
            attachment.imageSize = [self scaleImageSize:insertImage];
            
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedString insertAttributedString:imageAttributedString atIndex:[self.imageLocationMarr[idx] integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentInputBox.attributedText = attributedString;
                [self set_initAttributedString];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

/**
 缩放插入的图片尺寸
 
 @param image 图片
 @return 图片尺寸
 */
- (CGSize)scaleImageSize:(UIImage *)image {
    CGFloat imageScale = image.size.width / image.size.height;
    CGFloat imageWidth = SCREEN_WIDTH - 30;
    CGSize imageSize = CGSizeMake(imageWidth, imageWidth / imageScale);
    return imageSize;
}

#pragma mark - 初始化内容文本
- (void)set_initAttributedString {
    self.contentAttributed = nil;
    
    self.contentAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentInputBox.attributedText];
}

/**
 设置文字的样式
 
 @return 设置样式
 */
- (NSDictionary *)set_attributesDictionary {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    
    NSDictionary *attributesDict = @{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                                     };
    return attributesDict;
}

#pragma mark - 清空数据
- (void)thn_removeAllObjects {
    [self.textMarr removeAllObjects];
    [self.imageMarr removeAllObjects];
    [self.imageLocationMarr removeAllObjects];
}


- (NSMutableArray *)textMarr {
    if (!_textMarr) {
        _textMarr = [NSMutableArray array];
    }
    return _textMarr;
}

- (NSMutableArray *)imageMarr {
    if (!_imageMarr) {
        _imageMarr = [NSMutableArray array];
    }
    return _imageMarr;
}

- (NSMutableArray *)imageLocationMarr {
    if (!_imageLocationMarr) {
        _imageLocationMarr = [NSMutableArray array];
    }
    return _imageLocationMarr;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
    self.delegate = self;
}

- (void)thn_leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

@end
