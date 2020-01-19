//
//  ViewController.m
//  POS
//
//  Created by Adisak Phairat on 23/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "MainViewController.h"
#import "ImageCollectionViewCell.h"
#import "SelectionItemView.h"
#import "SummaryView.h"
#import "Utils.h"
#import "ScanBarcodeViewController.h"
#import "TransactionViewController.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SelectItemViewDelegate, SummaryViewDelegate, ScanBarcodeViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveAmountTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) double totalAmount;

@property (strong, nonatomic) SelectionItemView *selectionView;
@property (strong, nonatomic) SummaryView *summaryView;

@property (strong, nonatomic) NSMutableArray <HistoryModel *> *historyList;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *buyItemList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleView.layer.cornerRadius = self.circleView.frame.size.height/2;
    self.historyList = [NSMutableArray array];
    self.totalAmount = 0.0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount showCurrency:YES]];
    
    [self.discountTextField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryList";
    NSDictionary *parameters = @{};
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary * _Nonnull response) {
        self.buyItemList = response[@"data"];
        [self.collectionView reloadData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        
    }];
    
    if (self.historyList != nil) {
        self.totalAmount = 0;
        for (HistoryModel *model in self.historyList) {
            self.totalAmount += model.totalPrice;
        }
        [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount showCurrency:YES]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeTextField resignFirstResponder];
    [self.receiveAmountTextField resignFirstResponder];
    [self.discountTextField resignFirstResponder];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    NSString *text = [NSString stringWithFormat:@" %@ %@ %@ ", self.buyItemList[indexPath.row][@"name"], self.buyItemList[indexPath.row][@"color"], self.buyItemList[indexPath.row][@"size"]];
    [cell configuration:self.buyItemList[indexPath.row][@"image"]
                  label:text];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.buyItemList count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryStock";
    NSDictionary *parameters = @{
                                    @"code": self.buyItemList[indexPath.row][@"code"]
                                 };
    
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@", response[@"data"][@"item"]]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"สินค้าหมด" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
            [alert show];
        } else {
            self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
            [self.selectionView configurationWithCode:response[@"data"][@"code"]
                                                 name:response[@"data"][@"name"]
                                             imageUrl:response[@"data"][@"image"]
                                                 item:response[@"data"][@"item"]
                                                 size:response[@"data"][@"size"]
                                                color:response[@"data"][@"color"]
                                                price:response[@"data"][@"price"]
                                                index:0];
            [self.selectionView show:YES];
        }

    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

- (void)textFieldDidChange {
    if (![Utils isEmpty:self.discountTextField.text]) {
        double total = self.totalAmount - [self.discountTextField.text doubleValue];
        [self.totalAmountLabel setText:[NSString stringWithFormat:@"%.2f", total]];
    } else {
        [self.totalAmountLabel setText:[NSString stringWithFormat:@"%.2f", self.totalAmount]];
    }
}

#pragma mark - Outlets

- (IBAction)clickLogout:(id)sender {
    NSString *state = @"appState";
    [[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:state];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"backToLogin" sender:self];
}

- (IBAction)clickSearch:(id)sender {
    [self.view endEditing:YES];

    NSString *code = self.codeTextField.text;
    if ([Utils isEmpty:code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณากรอกข้อมูลให้ครบถ้วน" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }

    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryStock";
    NSDictionary *parameters = @{
                                 @"code": code
                                 };
    
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@", response[@"data"][@"item"]]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"สินค้าหมด" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
            [alert show];
        } else {
            self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
            [self.selectionView configurationWithCode:response[@"data"][@"code"]
                                                 name:response[@"data"][@"name"]
                                             imageUrl:response[@"data"][@"image"]
                                                 item:response[@"data"][@"item"]
                                                 size:response[@"data"][@"size"]
                                                color:response[@"data"][@"color"]
                                                price:response[@"data"][@"price"]
                                                index:0];
            [self.selectionView show:YES];
        }

    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];

}

- (IBAction)summary:(id)sender {
    [self.view endEditing:YES];
    
    if (self.historyList == nil || [self.historyList count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาเลือกสินค้า" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }
    
    if ([Utils isEmpty:self.receiveAmountTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณากรอกข้อมูลให้ครบถ้วน" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }
    
    self.summaryView = [[SummaryView alloc] initWithTotalAmount:self.totalAmount discountAmount:[self.discountTextField.text doubleValue] amount:[self.receiveAmountTextField.text doubleValue] historyList:self.historyList delegate:self];
    [self.summaryView show:YES];
}

- (IBAction)clickBarcode:(id)sender {
    [self.view endEditing:YES];

    ScanBarcodeViewController *vc = [[ScanBarcodeViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickTransaction:(id)sender {
    [self.view endEditing:YES];

    TransactionViewController *vc = [[TransactionViewController alloc] initWithHistoryList:self.historyList];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SummaryViewDelegate

- (void)summaryComplete {
    self.historyList = [NSMutableArray array];
    self.totalAmount = 0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount showCurrency:YES]];
    [self.discountTextField setText:@""];
    [self.receiveAmountTextField setText:@""];
    [self.codeTextField setText:@""];
}

#pragma mark - SelectItemViewDelegate

- (void)selectionDidSelected:(HistoryModel *)model index:(long)index{
    self.totalAmount += model.totalPrice;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount showCurrency:YES]];
    [self.historyList addObject:model];
}

#pragma mark - ScanBarcodeViewControllerDelegate

- (void)resultBarcode:(NSString *)text {
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryStock";
    NSDictionary *parameters = @{
                                 @"code": text
                                 };
    
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@", response[@"data"][@"item"]]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"สินค้าหมด" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
            [alert show];
        } else {
            self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
            [self.selectionView configurationWithCode:response[@"data"][@"code"]
                                                 name:response[@"data"][@"name"]
                                             imageUrl:response[@"data"][@"image"]
                                                 item:response[@"data"][@"item"]
                                                 size:response[@"data"][@"size"]
                                                color:response[@"data"][@"color"]
                                                price:response[@"data"][@"price"]
                                                index:0];
            [self performSelector:@selector(showPopup) withObject:text afterDelay:0.1];
        }
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

- (void)showPopup {
    [self.selectionView show:YES];
}

@end
