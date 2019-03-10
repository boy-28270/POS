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

@property (strong, nonatomic) id<SelectItemViewDelegate> delegate;
@property (assign, nonatomic) double amountPerItem;
@property (assign, nonatomic) double totalAmount;

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
    [self.delegate totalAmount:self.totalAmount];
    [self show:NO];
}

@end
