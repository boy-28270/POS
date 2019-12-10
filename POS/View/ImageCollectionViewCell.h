//
//  ImageCollectionViewCell.h
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : UICollectionViewCell

- (void)configuration:(NSString *)imagePath label:(NSString *)label;

@end

NS_ASSUME_NONNULL_END
