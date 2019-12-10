//
//  ImageCollectionViewCell.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface ImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ImageCollectionViewCell

- (void)configuration:(NSString *)imagePath label:(NSString *)label {
    [self.label setText:label];
    NSString *image = [NSString stringWithFormat:@"https://ntineloveu.com%@", imagePath];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

@end
