//
//  Utils.m
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "Utils.h"
#import <AFNetworking.h>

@implementation Utils

+ (BOOL)isEmpty:(NSString *)str {
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}


+ (NSString *)formatNumberWithText:(NSString *)number showCurrency:(BOOL)showCurrency {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (showCurrency) {
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencySymbol:@"฿"];
    }
    NSString *groupingSeparator = [[NSLocale localeWithLocaleIdentifier:@"th_TH"] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
}

+ (NSString *)formatNumberWithNumber:(double)number showCurrency:(BOOL)showCurrency {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (showCurrency) {
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setCurrencySymbol:@"฿"];
    }
    NSString *groupingSeparator = [[NSLocale localeWithLocaleIdentifier:@"th_TH"] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

+ (void) callServiceWithURL:(NSString *)url request:(NSDictionary *)request WithSuccessBlock:(void (^)(NSDictionary *response))success andFailureBlock:(void (^)(NSDictionary *error))failure {
    
    NSURLSessionConfiguration * conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    conf.TLSMaximumSupportedProtocol = kTLSProtocol12;
    conf.timeoutIntervalForRequest = 60.0;
    conf.timeoutIntervalForResource = 60.0;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:conf];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"Internetconnection: OK");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                NSLog(@"Internetconnection: NOT OK");
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *URLString = url;
    NSDictionary *parameters = request;
    NSLog(@"Request Body %@", parameters);
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success %@", responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (1 == [dict[@"status"] integerValue]) {
            success(dict);
        } else {
            failure(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure %@", error);
    }];
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController {
    selfController.navigationController.definesPresentationContext = YES;
    presentingController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    presentingController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [selfController presentViewController:presentingController animated:YES completion:nil];
}

+ (void)uploadPhotoWithImage:(UIImage *)image fileName:(NSString *)fileName WithSuccessBlock:(void (^)(NSDictionary *response))success andFailureBlock:(void (^)(NSDictionary *error))failure {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://ntineloveu.com/api/pos/uploadImage?code=%@", fileName]];

    UIImage *myImageObj = image;
    NSData *imageData= UIImageJPEGRepresentation(myImageObj, 0.6);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"imgUploader"
                                fileName:fileName mimeType:@"image/jpeg"];
        
        // etc.
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success %@", responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (1 == [dict[@"status"] integerValue]) {
            success(dict);
        } else {
            failure(dict);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure %@", error);
    }];
}

@end
