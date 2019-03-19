//
//  HistoryViewController.m
//  POS
//
//  Created by Adisak Phairat on 13/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "Utils.h"
#import "TransactionViewController.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *transactionList;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.transactionList = [NSMutableArray array];

    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryTransaction";
    NSDictionary *parameters = @{};
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        NSArray *array = response[@"data"];
        
        for (NSDictionary *dict in array) {
            [self.transactionList addObject:dict];
        }
        
        [self.tableView reloadData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.transactionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    [cell configurationWithDate:self.transactionList[indexPath.row][@"created"]
                      totalItem:self.transactionList[indexPath.row][@"totalItem"]
                     totalPrice:self.transactionList[indexPath.row][@"summary"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray <HistoryModel *> *historyList = [NSMutableArray array];
    
    NSArray *array = self.transactionList[indexPath.row][@"items"];
    for (NSDictionary *dict in array) {
        HistoryModel *model = [[HistoryModel alloc] init];
        model.code = dict[@"code"];
        model.name = dict[@"name"];
        model.size = dict[@"size"];
        model.color = dict[@"color"];
        model.imageUrl = dict[@"image"];
        model.item = [dict[@"item"] doubleValue];
        model.price = [dict[@"price"] doubleValue];
        model.totalPrice = [dict[@"totalPrice"] doubleValue];
        [historyList addObject:model];
    }
    
    TransactionViewController *vc = [[TransactionViewController alloc] initWithHistoryList:historyList];
    vc.selectable = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end
