//
//  StockTableViewCell.h
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StockTableViewCell : UITableViewCell

- (void)configurationWithName:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                        sizeS:(NSString *)sizeS
                        sizeM:(NSString *)sizeM
                        sizeL:(NSString *)sizeL
                       sizeXL:(NSString *)sizeXL;

@end

NS_ASSUME_NONNULL_END
