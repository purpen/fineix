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

@interface THNDomianLightViewController ()

@end

@implementation THNDomianLightViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _textView;
}

- (void)thn_setBrightSpotData:(NSArray *)model edit:(BOOL)edit {
    if (edit) {
        //  [self thn_addBarItemLeftBarButton:@"" image:@"icon_back_white"];
    } else {
        [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
    }
    
    NSMutableArray *totalTextMarr = [NSMutableArray array];

    for (NSString *str in model) {
        //  文字内容
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
            [totalTextMarr addObject:textStr];
        }
        
        //  图片内容
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
            [totalTextMarr addObject:imageStr];
        }
    }
    
    NSString *totalText = [totalTextMarr componentsJoinedByString:@"\n"];
    
    if (self.imageMarr.count == 0) {
        [self thn_setLightSporText:totalText];
    
    } else {
        for (NSString *imageUrl in self.imageMarr) {
            NSInteger imageLocation = [totalText rangeOfString:imageUrl].location;
            [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", imageLocation]];
            totalText = [totalText stringByReplacingOccurrencesOfString:imageUrl withString:@""];
        }
        
        [self thn_setLightSporText:totalText];
    }
}

- (void)thn_setLightSporText:(NSString *)text {
    [self getAttributedStringWithString:text];
}

- (void)getAttributedStringWithString:(NSString *)string {
    NSDictionary *attributesDict = [self set_attributesDictionary];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributesDict];
    self.textView.attributedText = attributedString;
    
    [SVProgressHUD showWithStatus:@"图片加载中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
            NSString *imageUrl = self.imageMarr[idx];
            
            THNLightspotTextAttachment *attachment = [[THNLightspotTextAttachment alloc] init];
            attachment.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedString insertAttributedString:imageAttributedString atIndex:[self.imageIndexMarr[idx] integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.attributedText = attributedString;
                [SVProgressHUD dismiss];
            });
        }
    });
}

#pragma mark - 插入图片后换行
- (NSAttributedString *)insertImageDoneAutoReturn:(NSAttributedString *)imageAttributedString {
    NSAttributedString *returnAttributedString = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:imageAttributedString];
    [attributedString appendAttributedString:returnAttributedString];
    [attributedString insertAttributedString:returnAttributedString atIndex:0];
    return attributedString;
}

#pragma mark - 正文样式
- (NSDictionary *)set_attributesDictionary {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 4.0f;
    
    NSDictionary *attributesDict = @{
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                                     };
    return attributesDict;
}

- (CGFloat)getTextFrameHeight:(NSString *)text {
    CGFloat textHeight = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)
                                            options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading |
                          NSStringDrawingUsesDeviceMetrics
                                         attributes:[self set_attributesDictionary]
                                            context:nil].size.height;
    return textHeight;
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

- (NSMutableArray *)imageIndexMarr {
    if (!_imageIndexMarr) {
        _imageIndexMarr = [NSMutableArray array];
    }
    return _imageIndexMarr;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
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
