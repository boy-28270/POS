//
//  ViewController.m
//  POS
//
//  Created by Adisak Phairat on 23/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import "SelectionItemView.h"
#import "SummaryView.h"
#import "Utils.h"
#import "ScanBarcodeViewController.h"
#import "TransactionViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SelectItemViewDelegate, SummaryViewDelegate, ScanBarcodeViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveAmountTextField;

@property (assign, nonatomic) double totalAmount;

@property (strong, nonatomic) SelectionItemView *selectionView;
@property (strong, nonatomic) SummaryView *summaryView;

@property (strong, nonatomic) NSMutableArray <HistoryModel *> *historyList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    self.circleView.layer.cornerRadius = self.circleView.frame.size.height/2;
    self.historyList = [NSMutableArray array];
    self.totalAmount = 0.0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
    
    [self.discountTextField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.historyList != nil) {
        self.totalAmount = 0;
        for (HistoryModel *model in self.historyList) {
            self.totalAmount += model.totalPrice;
        }
        [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeTextField resignFirstResponder];
    [self.receiveAmountTextField resignFirstResponder];
    [self.discountTextField resignFirstResponder];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    
//    NSString *imageName = indexPath.row % 2 ? @"test.jpg" : @"test.jpg";
//   
//    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
    [self.selectionView show:YES];
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

- (void)refresh:(id)sender {
    [self.view endEditing:YES];

    self.historyList = [NSMutableArray array];
    self.totalAmount = 0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
    [self.discountTextField setText:@""];
    [self.receiveAmountTextField setText:@""];
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
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
    [self.discountTextField setText:@""];
    [self.receiveAmountTextField setText:@""];
    [self.codeTextField setText:@""];
}

#pragma mark - SelectItemViewDelegate

- (void)selectionDidSelected:(HistoryModel *)model index:(long)index{
    self.totalAmount += model.totalPrice;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
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
