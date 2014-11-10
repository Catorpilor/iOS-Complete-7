//
//  SignInViewController.m
//  NSUserDefaut Segue and Protocols Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "SignInViewController.h"
#import "ViewController.h"

@interface SignInViewController ()
//@property (nonatomic,strong) NSMutableArray *accounts;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toViewController"]){
        //check the NSUserDefaut
        ViewController *viewVC = segue.destinationViewController;
        viewVC.name = self.username.text;
        viewVC.pass= self.password.text;
    }
    if([segue.identifier isEqualToString:@"toCreateAccountViewController"]){
        CreateAccountViewController* createAccountVC = segue.destinationViewController;
        createAccountVC.delegate = self;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CreateAccountViewController Delegate

-(void)didCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddAccount:(NSDictionary *)accountInfo{
   // if(!self.accounts) self.accounts = [[NSMutableArray alloc] init];
   // [self.accounts addObject:accountInfo];
    [[NSUserDefaults standardUserDefaults] setObject:accountInfo[USER_NAME] forKey:USER_NAME];
    [[NSUserDefaults  standardUserDefaults] setObject:accountInfo[USER_PASSWORD] forKey:USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)signIn:(UIButton *)sender {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PASSWORD];
    if( [self.username.text isEqualToString:username] && [self.password.text isEqualToString:password] ){
        [self performSegueWithIdentifier:@"toViewController" sender:sender];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No such user or password wrong" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
    }

//    if(![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]){
//        NSArray *accounts = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_ACCOUNT_INFO_KEY];
//        for( NSDictionary *accoutInfo in accounts ){
//            if( [self.username.text isEqualToString:accoutInfo[USER_NAME]] && [self.password.text isEqualToString:accoutInfo[USER_PASSWORD]] ){
//                [self performSegueWithIdentifier:@"toViewController" sender:self];
//            }
//        }
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No such user or password wrong" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
//        [alertView show];
//    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or password can't empty" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
//        [alertView show];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
@end
