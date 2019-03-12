//
//  HistoryTableViewCell.h
//  POS
//
//  Created by Adisak Phairat on 13/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewCell : UITableViewCell

- (void)configurationWithDate:(NSString *)date
                    totalItem:(NSString *)totalItem
                   totalPrice:(NSString *)totalPrice;

@end

NS_ASSUME_NONNULL_END
