//
//  StockViewController.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "StockViewController.h"
#import "StockTableViewCell.h"
#import "Utils.h"

@interface StockViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray <NSDictionary *> *array;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *searchResults;

@end

@implementation StockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.array = [NSMutableArray array];
    self.searchResults = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryListStock";
    NSDictionary *parameters = @{};
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        NSArray *temp = response[@"data"];
        for (NSDictionary *dict in temp) {
            [self.array addObject:dict];
        }
        self.searchResults = [self.array mutableCopy];
        [self.tableView reloadData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockTableViewCell" forIndexPath:indexPath];
    [cell configurationWithName:self.searchResults[indexPath.row][@"name"]
                       imageUrl:self.searchResults[indexPath.row][@"image"]
                          sizeS:self.searchResults[indexPath.row][@"S"]
                          sizeM:self.searchResults[indexPath.row][@"M"]
                          sizeL:self.searchResults[indexPath.row][@"L"]
                         sizeXL:self.searchResults[indexPath.row][@"XL"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([Utils isEmpty:searchText]) {
        self.searchResults = [self.array mutableCopy];
    } else {
        [self.searchResults removeAllObjects];
        NSMutableArray <NSDictionary *> *searchArray = [[NSMutableArray alloc] init];
        
        [searchArray addObjectsFromArray:self.array];
        
        for (NSDictionary *dict in searchArray) {
            NSString *objectName = dict[@"name"];
            NSRange resultsRange = [objectName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (resultsRange.length > 0)
                [self.searchResults addObject:dict];
        }
        searchArray = nil;
    }
    [self.tableView reloadData];
}

@end
