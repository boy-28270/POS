//
//  SummaryView.m
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "SummaryView.h"
#import "Utils.h"

@interface SummaryView()

@property (weak, nonatomic) IBOutlet UILabel *summaryAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@end

@implementation SummaryView

- (instancetype)initWithTotalAmount:(double)totalAmount discountAmount:(double)discountAmount amount:(double)amount {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SummaryView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        
        [self.summaryAmountLabel setText:[Utils formatNumberWithNumber:totalAmount-discountAmount]];
        [self.totalAmountLabel setText:[Utils formatNumberWithNumber:totalAmount]];
        [self.receiveAmountLabel setText:[Utils formatNumberWithNumber:amount]];
        [self.discountAmountLabel setText:[Utils formatNumberWithNumber:discountAmount]];
        [self.changeAmountLabel setText:[Utils formatNumberWithNumber:amount-totalAmount-discountAmount]];
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

- (IBAction)calculate:(id)sender {
    [self show:NO];
}

@end
