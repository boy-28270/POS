//
//  AddStockFirstViewController.m
//  POS
//
//  Created by Adisak Phairat on 8/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "AddStockFirstViewController.h"
#import "ScanBarcodeViewController.h"
#import "Utils.h"

@interface AddStockFirstViewController () <ScanBarcodeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *barcodeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegmentedControl;

@end

@implementation AddStockFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.codeTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}


#pragma mark - ScanBarcodeViewControllerDelegate

- (void)resultBarcode:(NSString *)text {
    [self.codeTextField setText:text];
}

#pragma mark - Outlets

- (IBAction)clickBarcode:(id)sender {
    ScanBarcodeViewController *vc = [[ScanBarcodeViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)save:(id)sender {
    NSString *code = self.codeTextField.text;
    NSString *name = self.nameTextField.text;
    if ([Utils isEmpty:code] || [Utils isEmpty:name] || self.sizeSegmentedControl.selectedSegmentIndex == -1 || self.colorSegmentedControl.selectedSegmentIndex == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณากรอกข้อมูลให้ครบถ้วน" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }
    NSString *color = [self.colorSegmentedControl titleForSegmentAtIndex:self.colorSegmentedControl.selectedSegmentIndex];
    NSString *size = [self.sizeSegmentedControl titleForSegmentAtIndex:self.sizeSegmentedControl.selectedSegmentIndex];

    
    NSString *URLString = @"https://ntineloveu.com/api/pos/createStock";
    NSDictionary *parameters = @{
                                 @"code": code,
                                 @"name": name,
                                 @"color": color,
                                 @"size": size,
                                 @"image": @"Test",
                                 @"item": @"0",
                                 @"price": @"0",
                                 @"capitalPrice": @"0"
                                 };

    if ([Utils isEmpty:code] || [Utils isEmpty:name]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณากรอกข้อมูลให้ครบถ้วน" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
        return;
    }

    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"สำเร็จ" message:@"เพิ่มข้อมูลเรียบร้อย" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
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
        [self.itemImage setImage:nil];
        [self.sizeSegmentedControl setSelectedSegmentIndex:-1];
        [self.colorSegmentedControl setSelectedSegmentIndex:-1];
    }
}

@end
