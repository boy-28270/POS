//
//  TransactionTableViewCell.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "Utils.h"
#import <UIImageView+WebCache.h>

@interface TransactionTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation TransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configurationWithName:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                         size:(NSString *)size
                         item:(double)item
                        price:(double)price
                   totalPrice:(double)totalPrice {
    [self.nameLabel setText:name];
    NSString *image = [NSString stringWithFormat:@"https://ntineloveu.com%@", imageUrl];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.sizeLabel setText:size];
    [self.itemLabel setText:[NSString stringWithFormat:@"%.0f", item]];
    [self.priceLabel setText:[Utils formatNumberWithNumber:price]];
    [self.totalPriceLabel setText:[Utils formatNumberWithNumber:totalPrice]];
}

@end
