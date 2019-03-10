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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SelectItemViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveAmountTextField;

@property (assign, nonatomic) double totalAmount;

@property (strong, nonatomic) SelectionItemView *selectionView;
@property (strong, nonatomic) SummaryView *summaryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    self.circleView.layer.cornerRadius = self.circleView.frame.size.height/2;
    self.totalAmount = 0.0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
    self.selectionView = [[SelectionItemView alloc] initWithDelegate:self];
    [self.selectionView show:YES];
}

#pragma mark - Outlets

- (void)refresh:(id)sender {
    self.totalAmount = 0;
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
}

- (IBAction)summary:(id)sender {
    self.summaryView = [[SummaryView alloc] initWithTotalAmount:self.totalAmount discountAmount:[self.discountTextField.text doubleValue] amount:[self.receiveAmountTextField.text doubleValue]];
    [self.summaryView show:YES];
}

#pragma mark - SelectItemViewDelegate

- (void)totalAmount:(double)amount {
    self.totalAmount += amount;
    NSLog(@"%f", self.totalAmount);
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
}

@end
