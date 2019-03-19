//
//  StockImageViewController.m
//  POS
//
//  Created by Adisak Phairat on 15/3/2562 BE.
//  Copyright © 2562 Adisak Phairat. All rights reserved.
//

#import "StockImageViewController.h"
#import <UIImageView+WebCache.h>
#import "Utils.h"

@interface StockImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSString *imageUrl;

@end

@implementation StockImageViewController

- (instancetype)initWithImageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        NSString *image = [NSString stringWithFormat:@"https://ntineloveu.com%@", imageUrl];
        self.imageUrl = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)tapView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
