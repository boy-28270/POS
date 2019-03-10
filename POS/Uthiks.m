//
//  Uthiks.m
//  POS
//
//  Created by Adisak Phairat on 24/2/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)formatNumber:(NSString *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyISOCodeStyle];
    [formatter setCurrencyCode:@"฿"];
    NSString *groupingSeparator = [[NSLocale localeWithLocaleIdentifier:@"th_TH"] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:[number floatValue]]];
}

@end
