//
//  CreateAccountViewController.h
//  NSUserDefaut Segue and Protocols Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USER_ACCOUNT_INFO_KEY @"user account info"
#define USER_NAME @"username"
#define USER_PASSWORD @"password"

@protocol CreateAccountViewControllerDelegate <NSObject>

@required

-(void)didCancel;
-(void)didAddAccount:(NSDictionary *)accountInfo;

@end

@interface CreateAccountViewController : UIViewController
- (IBAction)cancel:(UIButton *)sender;
- (IBAction)createAccount:(UIButton *)sender;

//property
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property  (weak,nonatomic) id <CreateAccountViewControllerDelegate> delegate;

@end
