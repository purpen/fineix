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
    
}

- (void)thn_setBrightSpotData:(NSArray *)model {
    NSMutableArray *strMarr = [NSMutableArray array];
    
    for (NSString *str in model) {
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
            [strMarr addObject:textStr];
        }
        
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
            [strMarr addObject:imageStr];
        }
    }

    NSString *totalText = [strMarr componentsJoinedByString:@""] ;
    for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
        NSString *str = self.imageMarr[idx];
        NSInteger location = [totalText rangeOfString:str].location;
        totalText = [totalText stringByReplacingOccurrencesOfString:str withString:@"\n\n"];
        [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", location]];
    }
    
    
    [self thn_crearBrightSpotInfoUI:self.textMarr image:self.imageMarr];
}

- (void)thn_crearBrightSpotInfoUI:(NSMutableArray *)textMarr image:(NSMutableArray *)imageMarr {
    NSString *textStr = [textMarr componentsJoinedByString:@"\n"];
    
    [self getAttributedStringWithString:textStr lineSpace:5.0f];
    
    [self.view addSubview:self.textView];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 74, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 74)];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

- (void)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
            // 插入图片
            THNLightspotTextAttachment *attach = [[THNLightspotTextAttachment alloc] init];
            attach.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMarr[idx]]]];
            attach.bounds = CGRectMake(0, 0, 15, 15);
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString insertAttributedString:attachString atIndex:[self.imageIndexMarr[idx] integerValue]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.attributedText = attributedString;
        });
    });

}

- (CGFloat)getTextFrameHeight:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5.0;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    
    CGFloat textHeight = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)
                                            options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading |
                          NSStringDrawingUsesDeviceMetrics
                                         attributes:attribute
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
    [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
}

- (void)thn_leftBarItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
