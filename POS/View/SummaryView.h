//
//  SummaryView.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SummaryView : UIView

- (instancetype)initWithTotalAmount:(double)totalAmount discountAmount:(double)discountAmount amount:(double)amount ;
- (void)show:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
