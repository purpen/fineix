//
//  CommenttwoViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommenttwoViewController.h"
#import "OrderInfoCell.h"
#import "OrderInfoModel.h"
#import "CommentView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"

@interface CommenttwoViewController ()<FBNavigationBarItemsDelegate,CommentViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (nonatomic, strong) NSMutableArray * commentViewAry;
@property (nonatomic, strong) NSMutableArray * commentInfoAry;
@property (weak, nonatomic) IBOutlet UIButton *commiteBtn;
@end

@implementation CommenttwoViewController

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return [textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"发表评价";
    // Do any additional setup after loading the view from its nib.
    NSArray * productAry = self.orderInfoCell.orderInfo.productInfos;
    NSInteger count = productAry.count;
    self.commentViewAry = [NSMutableArray array];
    if (count > 0) {
        self.mainViewHeight.constant = (commentHeight + 10) * count;
        for (NSInteger i = 0; i < count; i++) {
            ProductInfoModel * productInfo = productAry[i];
            CommentView * commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] firstObject];
            commentView.delegate = self;
            commentView.index = i;
            [self.mainView addSubview:commentView];
            WEAKSELF
            [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(commentHeight);
                make.top.equalTo(weakSelf.mainView.mas_top).with.offset((commentHeight + 10) * i);
                make.left.equalTo(weakSelf.mainView.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.mainView.mas_right).with.offset(-0);
            }];
            [commentView.coverImgView sd_setImageWithURL:[NSURL URLWithString:productInfo.coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            [self.commentViewAry addObject:commentView];
        }
    }
}
- (IBAction)commitBtnAction:(UIButton *)sender {
    NSArray * productAry = self.orderInfoCell.orderInfo.productInfos;
    NSInteger count = productAry.count;
    self.commentInfoAry = [NSMutableArray array];
    if (count > 0) {
        for (NSInteger i = 0; i < count; i++) {
            ProductInfoModel * productInfo = productAry[i];
            CommentView * commentView = self.commentViewAry[i];
            commentView.contentTextView.delegate = self;
            
            NSMutableDictionary * productDic = [NSMutableDictionary dictionary];
            productDic[@"target_id"] = [NSNumber numberWithInteger:productInfo.productId];
            productDic[@"sku_id"] = [NSNumber numberWithInteger:productInfo.sku];
            productDic[@"content"] = commentView.contentTextView.text;
            productDic[@"star"] = [NSNumber numberWithInteger:commentView.starInt];
            
            [self.commentInfoAry addObject:productDic];
        }
    }
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.commentInfoAry options:0 error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    FBRequest * request = [FBAPI postWithUrlString:@"/product/ajax_comment" requestDictionary:@{@"rid": self.orderInfoCell.orderInfo.rid, @"array": jsonString} delegate:self];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([self.delegate1 respondsToSelector:@selector(operationActionWithCell:)]) {
            [self.delegate1 operationActionWithCell:self.orderInfoCell];
        }
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"评价成功"];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - CommentViewDelegate
- (void)commentTextViewDidBeginEditing:(CommentView *)commentView
{
    if (commentView.index == self.commentViewAry.count - 1) {
        CGFloat frameHeight = self.mainScrollView.frame.size.height;
        self.mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, frameHeight - commentHeight, 0);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, commentView.index * (commentHeight + 10));
    }];
}

- (void)commentTextViewDidEndEditing:(CommentView *)commentView
{
    if (commentView.index == self.commentViewAry.count - 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
