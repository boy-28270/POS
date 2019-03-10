//
//  Utils.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (BOOL)isEmpty:(NSString *)str;
+ (NSString *)formatNumberWithText:(NSString *)number;
+ (NSString *)formatNumberWithNumber:(double)number;
+ (void)callServiceWithURL:(NSString *)url request:(NSDictionary *)request WithSuccessBlock:(void (^)(NSDictionary *response))success andFailureBlock:(void (^)(NSDictionary *error))failure;

@end

NS_ASSUME_NONNULL_END
