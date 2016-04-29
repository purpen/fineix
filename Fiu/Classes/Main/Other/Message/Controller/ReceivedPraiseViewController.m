//
//  ReceivedPraiseViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReceivedPraiseViewController.h"
#import "CommentsTableViewCell.h"

@interface ReceivedPraiseViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@end

@implementation ReceivedPraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"私信";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setUI];
    cell.msgLabel.text = @"赞了你的场景";
    cell.focusBtn.hidden = YES;
    return cell;
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
