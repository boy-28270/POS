//
//  SelectionItemView.m
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "SelectionItemView.h"
#import "Utils.h"

@interface SelectionItemView()

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIStepper *itemStepper;

@property (strong, nonatomic) id<SelectItemViewDelegate> delegate;
@property (assign, nonatomic) double amountPerItem;
@property (assign, nonatomic) double totalAmount;

@property (strong, nonatomic) HistoryModel *model;

@end

@implementation SelectionItemView

- (instancetype)initWithDelegate:(id<SelectItemViewDelegate>)delegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SelectionItemView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.delegate = delegate;
        self.amountPerItem = 250;
        self.totalAmount = 250;
        [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.amountPerItem]];
        self.model = [[HistoryModel alloc] init];
    }
    return self;
}

- (void)show:(BOOL)isShow {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    if (isShow) {
        [currentWindow addSubview:self];
        [self.popupView setAlpha:0];
        self.popupView.transform = CGAffineTransformMakeTranslation(0, 1000);
        [UIView animateWithDuration:0.4 animations:^{
            [self.popupView setAlpha:1];
            self.popupView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            [self.popupView setAlpha:0];
            self.popupView.transform = CGAffineTransformMakeTranslation(0, 1000);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)configurationWithCode:(NSString *)code
                         name:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                         size:(NSString *)size
                        color:(NSString *)color
                        price:(NSString *)price {
    [self.nameLabel setText:name];
    NSString *image = [NSString stringWithFormat:@"https://ntineloveu.com%@", imageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:image]];
    self.profileImageView.image = [UIImage imageWithData:imageData];
    if ([size isEqualToString:@"S"]) {
        self.sizeSegmentedControl.selectedSegmentIndex = 0;
    } else if ([size isEqualToString:@"M"]) {
        self.sizeSegmentedControl.selectedSegmentIndex = 1;
    } else if ([size isEqualToString:@"L"]) {
        self.sizeSegmentedControl.selectedSegmentIndex = 2;
    } else if ([size isEqualToString:@"XL"]) {
        self.sizeSegmentedControl.selectedSegmentIndex = 3;
    }
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
    self.amountPerItem = [price doubleValue];
    self.totalAmount = [price doubleValue];
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
    
    self.model.code = code;
    self.model.name = name;
    self.model.imageUrl = imageUrl;
    self.model.size = size;
    self.model.color = color;
}

#pragma mark - Outlets

- (IBAction)cancel:(id)sender {
    [self show:NO];
}

- (IBAction)changeItem:(id)sender {
    double item = [(UIStepper *)sender value];
    self.totalAmount = self.amountPerItem * item;
    NSString *text = [NSString stringWithFormat:@"%.0f", item];
    [self.itemLabel setText:text];
    [self.totalAmountLabel setText:[Utils formatNumberWithNumber:self.totalAmount]];
}

- (IBAction)addItem:(id)sender {
    self.model.item = [self.itemStepper value];
    self.model.price = self.amountPerItem;
    self.model.totalPrice = self.totalAmount;
    
    [self.delegate selectionDidSelected:self.model];
    [self show:NO];
}

@end