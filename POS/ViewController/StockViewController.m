//
//  StockViewController.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "StockViewController.h"
#import "StockTableViewCell.h"
#import "StockImageViewController.h"
#import "Utils.h"

@interface StockViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeSLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeMLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeLLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeXLLabel;


@property (strong, nonatomic) NSMutableArray <NSDictionary *> *array;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *searchResults;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation StockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.array = [NSMutableArray array];
    self.searchResults = [NSMutableArray array];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryListStock";
    NSDictionary *parameters = @{};
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        NSArray *temp = response[@"data"];
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = @[nameDescriptor];
        NSArray *ordered = [temp sortedArrayUsingDescriptors:sortDescriptors];
        
        for (NSDictionary *dict in ordered) {
            [self.array addObject:dict];
        }
        self.searchResults = [self.array mutableCopy];
        
        self.totalSizeSLabel.text = [NSString stringWithFormat:@"S = %@", response[@"totalSizeS"]];
        self.totalSizeMLabel.text = [NSString stringWithFormat:@"M = %@", response[@"totalSizeM"]];
        self.totalSizeLLabel.text = [NSString stringWithFormat:@"L = %@", response[@"totalSizeL"]];
        self.totalSizeXLLabel.text = [NSString stringWithFormat:@"XL = %@", response[@"totalSizeXL"]];
        
        [self.tableView reloadData];
        
        [self.hud hideAnimated:YES];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    StockImageViewController *popup = [[StockImageViewController alloc] initWithImageUrl:self.searchResults[indexPath.row][@"image"]];
    [Utils setPresentationStyleForSelfController:self presentingController:popup];
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
