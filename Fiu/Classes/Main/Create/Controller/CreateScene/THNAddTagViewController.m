//
//  THNAddTagViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAddTagViewController.h"

static NSString *const URLHotTags = @"/scene_sight/stick_active_tags";
static NSString *const URLUsedTags = @"/my/my_recent_tags";
static NSString *const URLSearchTag = @"/search/expanded";

static NSString *const hotTagsCellID = @"HotTagsCellID";
static NSString *const usedTagsCellID = @"UsedTagsCellID";
static NSString *const searchListCellID = @"SearchListCellID";

@interface THNAddTagViewController ()

@pro_strong NSMutableArray *hotTagsMarr;
@pro_strong NSMutableArray *hotTagsIdMarr;
@pro_strong NSMutableArray *usedTagsMarr;
@pro_strong NSMutableArray *usedHotTagsMarr;
@pro_strong NSMutableArray *searchTagsMarr;

@end

@implementation THNAddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavViewUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tagsTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setViewUI];
    
    [self networkHotTagsData];
    [self networkUsedTagsData];
}

#pragma mark - 网络请求
#pragma mark 热门标签
- (void)networkHotTagsData {
    self.hotTagsRequest = [FBAPI getWithUrlString:URLHotTags requestDictionary:@{@"type":@"1"} delegate:self];
    [self.hotTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *hotTags = [[result valueForKey:@"data"] valueForKey:@"items"];
        if (hotTags.count) {
            for (NSArray *arr in hotTags) {
                [self.hotTagsMarr addObject:arr[0]];
                [self.hotTagsIdMarr addObject:[NSString stringWithFormat:@"%zi", [arr[1] integerValue]]];
            }
        }
        
        if (self.hotTagsMarr.count) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.tagsList reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 使用过的标签
- (void)networkUsedTagsData {
    self.usedTagsRequest = [FBAPI getWithUrlString:URLUsedTags requestDictionary:@{@"type":@"1"} delegate:self];
    [self.usedTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *usedTags = [[result valueForKey:@"data"] valueForKey:@"tags"];
        if (usedTags.count) {
            self.usedTagsMarr = [NSMutableArray arrayWithArray:usedTags];
        }
        
        if (self.usedTagsMarr.count > 10) {
            [self.usedTagsMarr removeObjectsInRange:NSMakeRange(10, self.usedTagsMarr.count-10)];
        }
        
        if (self.usedTagsMarr.count) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.tagsList reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 搜索建议
- (void)networkSearchTag:(NSString *)text {
    self.searchRequest = [FBAPI getWithUrlString:URLSearchTag requestDictionary:@{@"q":text, @"size":@"20"} delegate:self];
    [self.searchRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *tagsArr = [[[result valueForKey:@"data"] valueForKey:@"data"] valueForKey:@"swords"];
        self.searchTagsMarr = [NSMutableArray arrayWithArray:tagsArr];
        [self.searchList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.tagsTextField];
    [self.view addSubview:self.tagsList];
    [self.view addSubview:self.searchList];
}

#pragma mark - init
- (UITextField *)tagsTextField {
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 44)];
        _tagsTextField.delegate = self;
        _tagsTextField.backgroundColor = [UIColor whiteColor];
        _tagsTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
        _tagsTextField.leftViewMode = UITextFieldViewModeAlways;
        _tagsTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _tagsTextField.placeholder = NSLocalizedString(@"WriteAddTag", nil);
        _tagsTextField.font = [UIFont systemFontOfSize:12];
        _tagsTextField.textColor = [UIColor blackColor];
        _tagsTextField.returnKeyType = UIReturnKeyDone;
        [_tagsTextField becomeFirstResponder];
        [_tagsTextField addTarget:self action:@selector(beginSearchTag:) forControlEvents:UIControlEventEditingChanged];
    }
    return _tagsTextField;
}

- (void)beginSearchTag:(UITextField *)textField {
    CGRect searchFrame = CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT - 94);
    [UIView animateWithDuration:.3
                          delay:0
         usingSpringWithDamping:10.0
          initialSpringVelocity:5.0
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         self.searchList.frame = searchFrame;
                     } completion:^(BOOL finished) {
                         if ([textField.text isEqualToString:@""]) {
                             self.searchList.hidden = YES;
                         } else {
                             self.searchList.hidden = NO;
                         }
                     }];

    if (![textField.text isEqualToString:@""]) {
         [self networkSearchTag:textField.text];
    }
}

#pragma mark - 完成输入标签返回
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            self.getAddTagsDataBlock([NSString stringWithFormat:@"%@ ", textField.text], @"");
        }];
    }
    return YES;
}

- (UITableView *)searchList {
    if (!_searchList) {
        _searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 94) style:(UITableViewStylePlain)];
        _searchList.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _searchList.delegate = self;
        _searchList.dataSource = self;
        _searchList.showsVerticalScrollIndicator = NO;
    }
    return _searchList;
}

- (UITableView *)tagsList {
    if (!_tagsList) {
        _tagsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT - 94) style:(UITableViewStyleGrouped)];
        _tagsList.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _tagsList.delegate = self;
        _tagsList.dataSource = self;
        _tagsList.showsVerticalScrollIndicator = NO;
    }
    return _tagsList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tagsList) {
        return 2;
    } else if (tableView == self.searchList) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        if (section == 0) {
            return self.hotTagsMarr.count;
        } else if (section == 1) {
            return self.usedTagsMarr.count;
        }
    } else if (tableView == self.searchList) {
        return self.searchTagsMarr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tagsList) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotTagsCellID];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hotTagsCellID];
            if (self.hotTagsMarr.count) {
                cell.textLabel.text = [NSString stringWithFormat:@"#%@ ", self.hotTagsMarr[indexPath.row]];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:usedTagsCellID];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:usedTagsCellID];
            if (self.usedTagsMarr.count) {
                cell.textLabel.text = [NSString stringWithFormat:@"#%@ ", self.usedTagsMarr[indexPath.row]];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    
    } else if (tableView == self.searchList) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchListCellID];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:searchListCellID];
        if (self.searchTagsMarr.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"#%@ ", self.searchTagsMarr[indexPath.row]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        headerLab.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        headerLab.font = [UIFont systemFontOfSize:12];
        headerLab.textColor = [UIColor colorWithHexString:@"#999999"];
        if (section == 0) {
            headerLab.text = NSLocalizedString(@"recommendTag", nil);
        } else {
            headerLab.text = NSLocalizedString(@"userdTag", nil);
        }
        [headerView addSubview:headerLab];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        if (section == 0) {
            if (self.hotTagsMarr.count) {
                return 44;
            } else {
                return 0.01;
            }
            
        } else if (section == 1) {
            if (self.usedTagsMarr.count) {
                return 44;
            } else {
                return 0.01;
            }
        }
        
    } else if (tableView == self.searchList) {
        return 0.01;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (tableView == self.tagsList) {
            if (indexPath.section == 0) {
                self.getAddTagsDataBlock([NSString stringWithFormat:@"%@ ", self.hotTagsMarr[indexPath.row]], self.hotTagsIdMarr[indexPath.row]);
                
            } else if (indexPath.section == 1) {
                self.getAddTagsDataBlock([NSString stringWithFormat:@"%@ ", self.usedTagsMarr[indexPath.row]], @"");
            }
            
        } else if (tableView == self.searchList) {
            self.getAddTagsDataBlock([NSString stringWithFormat:@"%@ ", self.searchTagsMarr[indexPath.row]], @"");
        }
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tagsTextField resignFirstResponder];
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.delegate = self;
    [self addNavViewTitle:NSLocalizedString(@"addTagVcTitle", nil)];
    [self addCloseBtn:@"icon_cancel"];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)hotTagsMarr {
    if (!_hotTagsMarr) {
        _hotTagsMarr = [NSMutableArray array];
    }
    return _hotTagsMarr;
}

- (NSMutableArray *)hotTagsIdMarr {
    if (!_hotTagsIdMarr) {
        _hotTagsIdMarr = [NSMutableArray array];
    }
    return _hotTagsIdMarr;
}

- (NSMutableArray *)usedTagsMarr {
    if (!_usedTagsMarr) {
        _usedTagsMarr = [NSMutableArray array];
    }
    return _usedTagsMarr;
}

- (NSMutableArray *)usedHotTagsMarr {
    if (!_usedHotTagsMarr) {
        _usedHotTagsMarr = [NSMutableArray array];
    }
    return _usedHotTagsMarr;
}

- (NSMutableArray *)searchTagsMarr {
    if (!_searchTagsMarr) {
        _searchTagsMarr = [NSMutableArray array];
    }
    return _searchTagsMarr;
}

@end
