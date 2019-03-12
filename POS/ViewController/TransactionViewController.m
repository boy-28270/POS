//
//  TransactionViewController.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionTableViewCell.h"
#import "SelectionItemView.h"

@interface TransactionViewController () <UITableViewDelegate, UITableViewDataSource, SelectItemViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SelectionItemView *selectionView;
@property (strong, nonatomic) NSMutableArray <HistoryModel *> *historyList;

@end

@implementation TransactionViewController

- (instancetype)initWithHistoryList:(NSMutableArray <HistoryModel *> *)historyList {
    self = [super init];
    if (self) {
        self.historyList = historyList;
        self.selectable = YES;
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

#pragma mark - SelectItemViewDelegate

- (void)selectionDidSelected:(HistoryModel *)model index:(long)index {
    [self.historyList replaceObjectAtIndex:index withObject:model];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectable) {
        self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
        [self.selectionView configurationWithModel:self.historyList[indexPath.row] index:indexPath.row];
        [self.selectionView show:YES];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete && self.selectable) {
        // Delete the row from the data source
        [self.historyList removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [tableView endUpdates];
        
    }
}

@end

