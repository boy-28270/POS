//
//  TransactionTableViewCell.h
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionTableViewCell : UITableViewCell

- (void)configurationWithName:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                         size:(NSString *)size
                         item:(double)item
                        price:(double)price
                   totalPrice:(double)totalPrice;

@end

NS_ASSUME_NONNULL_END
