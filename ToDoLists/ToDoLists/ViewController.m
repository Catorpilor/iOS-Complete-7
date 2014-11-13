//
//  ViewController.m
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "ToDoListManager.h"
#import "ToDoListTableViewCell.h"

#define CELL_HEIGHT 88

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic,strong) NSDateFormatter *dayFormatter;
@property (nonatomic,strong) NSDateFormatter *originalFormatter;
@property (nonatomic,strong) NSMutableArray *list;

@end

@implementation ViewController

- (id)init{
    self = [super init];
    if (self) {
        _dayFormatter = [[NSDateFormatter alloc] init];
        _dayFormatter.dateFormat = @"hh:mm:ss";
        
        _originalFormatter = [[NSDateFormatter  alloc] init];
        _originalFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        _list = [[[ToDoListManager sharedManager] listToDoItems] mutableCopy];
        if(!_list.count){
            [[ToDoListManager sharedManager] addToDoListWithText:@"Feed the cat"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Buy eggs"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Pack bags for WWDC"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Rule the web"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Buy a new iPhone"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Write a new tutorial"];
        }
        _list = [[ToDoListManager sharedManager] listToDoItems];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //init the view
    
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect headerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    
//    UIImage *image = [UIImage imageNamed:@"new_bg@1x.png"];
//    self.backgroundImageView = [[UIImageView alloc] initWithImage:image ];
//    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:self.backgroundImageView];
//    
//    // 3
//    self.blurredImageView = [[UIImageView alloc] init];
//    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.blurredImageView.alpha = 0;
//    [self.blurredImageView setImageToBlur:image blurRadius:10 completionBlock:nil];
//    [self.view addSubview:self.blurredImageView];
    
    // 4
    self.tableView = [[UITableView alloc] init];
    //self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    //self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    //self.tableView.backgroundColor  = UIColorFromRGB(0xffffff);
    [self.tableView registerClass:[ToDoListTableViewCell class] forCellReuseIdentifier:@"List Cell"];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //hide the 1st section of UITableView in grouped style
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
//        self.tableView.contentInset = UIEdgeInsetsMake(-2*CELL_HEIGHT, 0, 0, 0);
//    }
    
    
    
    //self.tableView.tableHeaderView = header;
    
    
    
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.list.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureActiveToDoCell:(UITableViewCell *)cell withModel:(ToDoListModel *)model {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = model.toDoGoal;
    if([model.endTime timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] < ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Today " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    if([model.endTime timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] < 2*ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Tomorrow " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    cell.imageView.image = nil;
}

- (void)configureOverdueToDoCell:(UITableViewCell *)cell withModel:(ToDoListModel *)model {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = model.toDoGoal;
    if([[NSDate date] timeIntervalSince1970] - [model.endTime timeIntervalSince1970]  < ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Today " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    if([[NSDate date] timeIntervalSince1970] - [model.endTime timeIntervalSince1970]   < 2*ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Yesterday " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    cell.imageView.image = nil;
}


#pragma make - UITableViewDataSource
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"List Cell";
    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (! cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    ToDoListModel *item = self.list[[indexPath row] ];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    //cell.textLabel.text = item.toDoGoal;
    cell.delegate = self;
    cell.toDoItem = item;
    
//
//    if(indexPath.section == 0){
//        if(indexPath.row == 0){
//            [self configureHeaderCell:cell title:@"Things to do"];
//        }
//    }else if(indexPath.section == 1){
//        if(indexPath.row==0){
//            [self configureHeaderCell:cell title:@"Things done"];
//        }
//    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    //NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [self colorForIndex:[indexPath row] ];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
    self.blurredImageView.alpha = percent;
}

#pragma mark - ToDoListTableViewCellDelegate

-(void)toDoItemDeleted:(ToDoListModel *)item{
    NSUInteger index = [self.list indexOfObject:item];
    [self.tableView beginUpdates];
    [self.list removeObject:item];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
