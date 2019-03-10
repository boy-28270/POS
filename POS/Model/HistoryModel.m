//
//  HistoryModel.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

- (NSDictionary *)getDictionary {
    NSDictionary *dict = @{
                           @"code" : self.code,
                           @"name" : self.name,
                           @"image" : self.imageUrl,
                           @"size" : self.size,
                           @"color" : self.color,
                           @"item" : [NSString stringWithFormat:@"%.0f", self.item],
                           @"price" : [NSString stringWithFormat:@"%.2f", self.price],
                           @"totalPrice" : [NSString stringWithFormat:@"%.2f", self.totalPrice],
                           };
    return dict;
}

@end
