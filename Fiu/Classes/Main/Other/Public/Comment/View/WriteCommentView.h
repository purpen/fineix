//
//  WriteCommentView.h
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface WriteCommentView : UIView <UITextFieldDelegate>

@pro_strong UITextField         *   writeText;  //  填写评论
@pro_strong UIButton            *   sendBtn;    //  发送评论

@end
