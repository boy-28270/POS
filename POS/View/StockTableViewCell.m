//
//  StockTableViewCell.m
//  POS
//
//  Created by Adisak Phairat on 10/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "StockTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface StockTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeSLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeMLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeXLLabel;

@end

@implementation StockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configurationWithName:(NSString *)name
                     imageUrl:(NSString *)imageUrl
                        sizeS:(NSString *)sizeS
                        sizeM:(NSString *)sizeM
                        sizeL:(NSString *)sizeL
                       sizeXL:(NSString *)sizeXL {
    [self.nameLabel setText:name];
    NSString *image = [NSString stringWithFormat:@"https://ntineloveu.com%@", imageUrl];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.sizeSLabel.text = [NSString stringWithFormat:@"S = %@", sizeS];
    self.sizeMLabel.text = [NSString stringWithFormat:@"M = %@", sizeM];
    self.sizeLLabel.text = [NSString stringWithFormat:@"L = %@", sizeL];
    self.sizeXLLabel.text = [NSString stringWithFormat:@"XL = %@", sizeXL];
}

@end
