//
//  ScanBarcodeViewController.h
//  POS
//
//  Created by Adisak Phairat on 2/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScanBarcodeViewControllerDelegate <NSObject>

- (void)resultBarcode:(NSString *)text;

@end

@interface ScanBarcodeViewController : UIViewController<ZXCaptureDelegate>

- (instancetype)initWithDelegate:(id<ScanBarcodeViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
