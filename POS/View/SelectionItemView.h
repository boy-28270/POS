//
//  SelectionItemView.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectItemViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectionItemView : UIView

- (instancetype)initWithDelegate:(id<SelectItemViewDelegate>)delegate;
- (void)show:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
