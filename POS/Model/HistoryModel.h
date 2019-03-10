//
//  HistoryModel.h
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryModel : NSObject

@property(strong, nonatomic) NSString *code;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) NSString *size;
@property(strong, nonatomic) NSString *color;
@property(assign, nonatomic) double item;
@property(assign, nonatomic) double price;
@property(assign, nonatomic) double totalPrice;

- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
