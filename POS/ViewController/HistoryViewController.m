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
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (assign, nonatomic) double profit;
@property (assign, nonatomic) double summary;
@property (assign, nonatomic) double total;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toolbar setHidden:YES];
    [self.datePicker setHidden:YES];
    self.datePicker.maximumDate = [NSDate new];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.profit = 0;
    self.summary = 0;
    self.total = 0;

    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryTransaction";
    NSDictionary *parameters = @{};
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        self.transactionList = [NSMutableArray array];
        NSArray *array = response[@"data"];
        
        for (NSDictionary *dict in array) {
            [self.transactionList addObject:dict];
            self.profit += [dict[@"profit"] doubleValue];
            self.summary += [dict[@"summary"] doubleValue];
            self.total += [dict[@"totalItem"] doubleValue];
        }
        
        [self.tableView reloadData];
        [self.profitLabel setText:[NSString stringWithFormat:@"จำนวน %.0f ตัว  |  ยอดขาย %@  |  กำไร %@", self.total, [Utils formatNumberWithNumber:self.summary showCurrency:NO], [Utils formatNumberWithNumber:self.profit showCurrency:NO]]];
        [self.hud hideAnimated:YES];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        [self.hud hideAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - Outlets

- (IBAction)clickStatement:(id)sender {
    self.datePicker.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.datePicker.isHidden) {
            self.datePicker.alpha = 1;
            self.toolbar.alpha = 1;
            [self.datePicker setHidden:NO];
            [self.toolbar setHidden:NO];
        } else {
            self.datePicker.alpha = 0;
            self.toolbar.alpha = 0;
            [self.datePicker setHidden:YES];
            [self.toolbar setHidden:YES];
        }
    }];
}

- (IBAction)confirm:(id)sender {
    self.datePicker.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 0;
        self.toolbar.alpha = 0;
        [self.datePicker setHidden:YES];
        [self.toolbar setHidden:YES];
    }];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.profit = 0;
    self.summary = 0;
    self.total = 0;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *date  = [dateFormatter stringFromDate:self.datePicker.date];
    
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryTransaction";
    NSDictionary *parameters = @{
        @"date": date
    };
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        self.transactionList = [NSMutableArray array];
        NSArray *array = response[@"data"];
        
        for (NSDictionary *dict in array) {
            [self.transactionList addObject:dict];
            self.profit += [dict[@"profit"] doubleValue];
            self.summary += [dict[@"summary"] doubleValue];
            self.total += [dict[@"totalItem"] doubleValue];
        }
        
        [self.tableView reloadData];
        [self.profitLabel setText:[NSString stringWithFormat:@"จำนวน %.0f ตัว  |  ยอดขาย %@  |  กำไร %@", self.total, [Utils formatNumberWithNumber:self.summary showCurrency:NO], [Utils formatNumberWithNumber:self.profit showCurrency:NO]]];
        [self.hud hideAnimated:YES];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        [self.hud hideAnimated:YES];
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
    if ([self.transactionList count] != 0) {
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
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

@end
