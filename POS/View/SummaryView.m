//
//  SummaryView.m
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "SummaryView.h"
#import "Utils.h"

@interface SummaryView() <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *summaryAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) id<SummaryViewDelegate> delegate;
@property (strong, nonatomic) NSString *summaryAmount;
@property (strong, nonatomic) NSString *totalAmount;
@property (strong, nonatomic) NSString *receiveAmount;
@property (strong, nonatomic) NSString *discountAmount;
@property (strong, nonatomic) NSString *changeAmount;
@property (strong, nonatomic) NSMutableArray <HistoryModel *> *historyList;

@property (strong, nonatomic) UIAlertView *alert;

@end

@implementation SummaryView

- (instancetype)initWithTotalAmount:(double)totalAmount discountAmount:(double)discountAmount amount:(double)amount historyList:(NSMutableArray <HistoryModel *> *)historyList delegate:(id<SummaryViewDelegate>)delegate {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SummaryView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        
        self.delegate = delegate;
        
        self.historyList = historyList;
        
        self.summaryAmount = [NSString stringWithFormat:@"%.2f", totalAmount-discountAmount];
        self.totalAmount = [NSString stringWithFormat:@"%.2f", totalAmount];
        self.receiveAmount = [NSString stringWithFormat:@"%.2f", amount];
        self.discountAmount = [NSString stringWithFormat:@"%.2f", discountAmount];
        self.changeAmount = [NSString stringWithFormat:@"%.2f", amount-totalAmount+discountAmount];

        [self.summaryAmountLabel setText:[Utils formatNumberWithNumber:totalAmount-discountAmount showCurrency:YES]];
        [self.totalAmountLabel setText:[Utils formatNumberWithNumber:totalAmount showCurrency:YES]];
        [self.receiveAmountLabel setText:[Utils formatNumberWithNumber:amount showCurrency:YES]];
        [self.discountAmountLabel setText:[Utils formatNumberWithNumber:discountAmount showCurrency:YES]];
        [self.changeAmountLabel setText:[Utils formatNumberWithNumber:amount-totalAmount+discountAmount showCurrency:YES]];
        
        for (HistoryModel *model in self.historyList) {
            NSLog(@"%@", [model getDictionary]);
        }
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
    NSMutableArray <NSDictionary *> *array = [NSMutableArray array];
    
    double item = 0;
    for (HistoryModel *model in self.historyList) {
        item += model.item;
        [array addObject:[model getDictionary]];
    }
    
    NSString *URLString = @"https://ntineloveu.com/api/pos/buyItem";
    NSDictionary *parameters = @{
                               @"totalItem" : [NSString stringWithFormat:@"%.0f", item],
                               @"totalPrice" : self.totalAmount,
                               @"discount" : self.discountAmount,
                               @"summary" : self.summaryAmount,
                               @"receive" : self.receiveAmount,
                               @"change" : self.changeAmount,
                               @"items" : array
                               };
    
    [Utils callServiceWithURL:URLString request:parameters WithSuccessBlock:^(NSDictionary *response) {
        self.alert = [[UIAlertView alloc] initWithTitle:@"สำเร็จ" message:response[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [self.alert show];
    } andFailureBlock:^(NSDictionary * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:error[@"errorMsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alert == alertView) {
        if (buttonIndex == 0){
            [self show:NO];
            [self.delegate summaryComplete];
        }
    }
}

@end
