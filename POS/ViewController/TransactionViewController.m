//
//  TransactionViewController.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionTableViewCell.h"

@interface TransactionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray <HistoryModel *> *historyList;

@end

@implementation TransactionViewController

- (instancetype)initWithHistoryList:(NSMutableArray <HistoryModel *> *)historyList {
    self = [super init];
    if (self) {
        self.historyList = historyList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"TransactionTableViewCell"];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionTableViewCell"];
    [cell configurationWithName:self.historyList[indexPath.row].name
                       imageUrl:self.historyList[indexPath.row].imageUrl
                           size:self.historyList[indexPath.row].size
                           item:self.historyList[indexPath.row].item
                          price:self.historyList[indexPath.row].price
                     totalPrice:(double)self.historyList[indexPath.row].totalPrice];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end

