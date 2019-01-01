//
//  AddStockViewController.m
//  POS
//
//  Created by Adisak Phairat on 2/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "AddStockViewController.h"
#import "ScanBarcodeViewController.h"
#import "Utils.h"

@interface AddStockViewController () <ScanBarcodeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *capitalPriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *barcodeButton;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UIStepper *itemStepper;

@end

@implementation AddStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.capitalPriceTextField resignFirstResponder];
}

#pragma mark - ScanBarcodeViewControllerDelegate

- (void)resultBarcode:(NSString *)text {
    NSString *URLString = @"https://ntineloveu.com/api/pos/inquiryStock";
    NSDictionary *parameters = @{
                                 @"code": text
                                 };
    
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        [self.codeTextField setText:response[@"data"][@"code"]];
        [self.nameTextField setText:response[@"data"][@"name"]];
        NSString *price = [NSString stringWithFormat:@"%@", response[@"data"][@"price"]];
        NSString *capitalPrice = [NSString stringWithFormat:@"%@", response[@"data"][@"capitalPrice"]];
        NSString *item = [NSString stringWithFormat:@"%@", response[@"data"][@"item"]];
        
        [self.priceTextField setText:[NSString stringWithFormat:@"%.2f", [price doubleValue]]];
        if (0 == [item doubleValue]) {
            [self.capitalPriceTextField setText:@"0"];
        } else {
            [self.capitalPriceTextField setText:[NSString stringWithFormat:@"%.2f", [capitalPrice doubleValue] / [item doubleValue]]];
        }
        
        NSString *size = response[@"data"][@"size"];
        if ([size isEqualToString:@"S"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 0;
        } else if ([size isEqualToString:@"M"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 1;
        } else if ([size isEqualToString:@"L"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 2;
        } else if ([size isEqualToString:@"XL"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 3;
        }
        NSString *color = response[@"data"][@"color"];
        if ([color isEqualToString:@"ดำ"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 0;
        } else if ([color isEqualToString:@"ขาว"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 1;
        } else if ([color isEqualToString:@"กรม"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 2;
        } else if ([color isEqualToString:@"เขียว"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 3;
        } else if ([color isEqualToString:@"แดง"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 4;
        } else if ([color isEqualToString:@"เทา"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 5;
        }
        NSString *imageUrl = [NSString stringWithFormat:@"https://ntineloveu.com%@", response[@"data"][@"image"]];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageUrl]];
        self.itemImage.image = [UIImage imageWithData:imageData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - Outlets

- (IBAction)clickBarcode:(id)sender {
    ScanBarcodeViewController *vc = [[ScanBarcodeViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickSearch:(id)sender {
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
        [self.codeTextField setText:response[@"data"][@"code"]];
        [self.nameTextField setText:response[@"data"][@"name"]];
        NSString *price = [NSString stringWithFormat:@"%@", response[@"data"][@"price"]];
        NSString *capitalPrice = [NSString stringWithFormat:@"%@", response[@"data"][@"capitalPrice"]];
        NSString *item = [NSString stringWithFormat:@"%@", response[@"data"][@"item"]];
        

        [self.priceTextField setText:[NSString stringWithFormat:@"%.2f", [price doubleValue]]];
        [self.capitalPriceTextField setText:[NSString stringWithFormat:@"%.2f", [capitalPrice doubleValue] / [item doubleValue]]];
        NSString *size = response[@"data"][@"size"];
        if ([size isEqualToString:@"S"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 0;
        } else if ([size isEqualToString:@"M"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 1;
        } else if ([size isEqualToString:@"L"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 2;
        } else if ([size isEqualToString:@"XL"]) {
            self.sizeSegmentedControl.selectedSegmentIndex = 3;
        }
        NSString *color = response[@"data"][@"color"];
        if ([color isEqualToString:@"ดำ"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 0;
        } else if ([color isEqualToString:@"ขาว"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 1;
        } else if ([color isEqualToString:@"กรม"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 2;
        } else if ([color isEqualToString:@"เขียว"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 3;
        } else if ([color isEqualToString:@"แดง"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 4;
        } else if ([color isEqualToString:@"เทา"]) {
            self.colorSegmentedControl.selectedSegmentIndex = 5;
        }
        NSString *imageUrl = [NSString stringWithFormat:@"https://ntineloveu.com%@", response[@"data"][@"image"]];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageUrl]];
        self.itemImage.image = [UIImage imageWithData:imageData];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];

}

- (IBAction)changeItem:(id)sender {
    double item = [(UIStepper *)sender value];
    NSString *text = [NSString stringWithFormat:@"%.0f", item];
    [self.itemLabel setText:text];
}

- (IBAction)save:(id)sender {
    NSString *code = self.codeTextField.text;
    NSString *price = self.priceTextField.text;
    NSString *item = [NSString stringWithFormat:@"%.0f", [self.itemStepper value]];
    double cal = [self.capitalPriceTextField.text doubleValue] * [self.itemStepper value];
    NSString *capitalPrice = [NSString stringWithFormat:@"%.2f", cal];
    
    if ([Utils isEmpty:price] || [Utils isEmpty:capitalPrice]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณากรอกข้อมูลให้ครบถ้วน" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }
    
    NSString *URLString = @"https://ntineloveu.com/api/pos/updateStock";
    NSDictionary *parameters = @{
                                 @"code": code,
                                 @"item": item,
                                 @"price": price,
                                 @"capitalPrice": capitalPrice
                                 };

    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"สำเร็จ" message:@"เพิ่มข้อมูลเรียบร้อย" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        alert.tag = 123;
        [alert show];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        [self.codeTextField setText:@""];
        [self.nameTextField setText:@""];
        [self.priceTextField setText:@""];
        [self.capitalPriceTextField setText:@""];
        [self.itemImage setImage:[UIImage imageNamed:@"placeholder.png"]];
        self.sizeSegmentedControl.selectedSegmentIndex = 0;
        self.colorSegmentedControl.selectedSegmentIndex = 0;
        [self.itemLabel setText:@"1"];
        [self.itemStepper setValue:1];
    }
}

@end
