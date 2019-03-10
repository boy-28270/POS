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

@interface StockViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray <NSDictionary *> *array;

@end

@implementation StockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.array = [NSMutableArray array];
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
        [self.tableView reloadData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockTableViewCell *cell = (StockTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StockTableViewCell"];
    [cell configurationWithName:self.array[indexPath.row][@"name"]
                       imageUrl:self.array[indexPath.row][@"image"]
                          sizeS:self.array[indexPath.row][@"S"]
                          sizeM:self.array[indexPath.row][@"M"]
                          sizeL:self.array[indexPath.row][@"L"]
                         sizeXL:self.array[indexPath.row][@"XL"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end
