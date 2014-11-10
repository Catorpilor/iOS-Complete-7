//
//  SignInViewController.h
//  NSUserDefaut Segue and Protocols Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateAccountViewController.h"

@interface SignInViewController : UIViewController <CreateAccountViewControllerDelegate>
- (IBAction)signIn:(UIButton *)sender;

//property
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end
