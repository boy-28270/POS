//
//  SelectItemViewDelegate.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectItemViewDelegate <NSObject>

- (void)totalAmount:(double)amount;

@end

NS_ASSUME_NONNULL_END
