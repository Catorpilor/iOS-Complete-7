//
//  ViewController.h
//  Passing Data Challenge Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@interface ViewController : UIViewController <DetailsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myText;


@end

