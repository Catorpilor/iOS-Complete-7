//
//  CreateAccountViewController.m
//  NSUserDefaut Segue and Protocols Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "CreateAccountViewController.h"




@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(UIButton *)sender {
    [self.delegate didCancel];
}

- (IBAction)createAccount:(UIButton *)sender {
    if(![self.userName.text isEqualToString:@""]){
        if([self.password.text isEqualToString:self.confirmPassword.text] && ![self.password.text isEqualToString:@""]){
            NSDictionary *accountInfo = @{USER_NAME:self.userName.text,USER_PASSWORD:self.password.text};
            [self.delegate didAddAccount:accountInfo];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alertView show];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username can't empty" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
    }
}
@end
