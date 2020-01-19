//
//  LoginViewController.m
//  POS
//
//  Created by Adisak Phairat on 19/1/2563 BE.
//  Copyright © 2563 Adisak Phairat. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/4;
    [self.emptyView setAlpha:1];
}

- (void)dismissKeyboard {
     [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *state = @"appState";
    NSString *appStateValue = [[NSUserDefaults standardUserDefaults]
    stringForKey:state];
    
    if ([@"main" isEqualToString:appStateValue]) {
        [self performSegueWithIdentifier:@"openMainAfterLogin" sender:self];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            [self.emptyView setAlpha:0];
        }];
    }
}

- (IBAction)clickLogin:(id)sender {
    NSString *username = @"adisak";
    NSString *password = @"0972972530";
    
    if ([self.usernameTextField.text isEqualToString:username] &&
        [self.passwordTextField.text isEqualToString:password]) {
        
        NSString *state = @"appState";
        [[NSUserDefaults standardUserDefaults] setObject:@"main" forKey:state];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"openMainAfterLogin" sender:self];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"เกิดข้อผิดพลาด" message:@"คุณกรอก ชื่อผู้ใช้งาน หรือ รหัสผ่าน ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ตกลง", nil];
        [alert show];
    }
    
    [self.usernameTextField setText:@""];
    [self.passwordTextField setText:@""];
}

@end
