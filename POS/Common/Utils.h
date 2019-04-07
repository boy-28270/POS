//
//  Utils.h
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (BOOL)isEmpty:(NSString *)str;
+ (NSString *)formatNumberWithText:(NSString *)number;
+ (NSString *)formatNumberWithNumber:(double)number;
+ (void)callServiceWithURL:(NSString *)url request:(NSDictionary *)request WithSuccessBlock:(void (^)(NSDictionary *response))success andFailureBlock:(void (^)(NSDictionary *error))failure;
+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController;
+ (void)uploadPhotoWithImage:(UIImage *)image fileName:(NSString *)fileName WithSuccessBlock:(void (^)(NSDictionary *response))success andFailureBlock:(void (^)(NSDictionary *error))failure;

@end

NS_ASSUME_NONNULL_END
