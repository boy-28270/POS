//
//  TransactionViewController.h
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionViewController : UIViewController

- (instancetype)initWithHistoryList:(NSMutableArray <HistoryModel *> *)historyList;

@end

NS_ASSUME_NONNULL_END
