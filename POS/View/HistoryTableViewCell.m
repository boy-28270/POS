//
//  HistoryTableViewCell.m
//  POS
//
//  Created by Adisak Phairat on 13/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "Utils.h"

@interface HistoryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configurationWithDate:(NSString *)date
                    totalItem:(NSString *)totalItem
                   totalPrice:(NSString *)totalPrice {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *dateServer  = [dateFormatter dateFromString:date];
        
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"th"]];
    [dateFormatter setDateFormat:@"HH:mm"];
    [self.timeLabel setText:[dateFormatter stringFromDate:dateServer]];
    
    [dateFormatter setDateFormat:@"EEEE, MMM d, yyyy"];
    [self.dateLabel setText:[dateFormatter stringFromDate:dateServer]];
    
    [self.totalItemLabel setText:[NSString stringWithFormat:@"%@", totalItem]];
    [self.totalPriceLabel setText:[Utils formatNumberWithText:totalPrice]];
}

@end
