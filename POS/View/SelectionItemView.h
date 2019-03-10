//
//  SelectionItemView.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectItemViewDelegate <NSObject>

- (void)selectionDidSelected:(HistoryModel *)model;

@end

@interface SelectionItemView : UIView

- (instancetype)initWithDelegate:(id<SelectItemViewDelegate>)delegate;
- (void)configurationWithCode:(NSString *)code
                         name:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                         size:(NSString *)size
                        color:(NSString *)color
                        price:(NSString *)price;
- (void)show:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
