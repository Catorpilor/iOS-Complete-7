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
#import "ToDoListTableViewAddNew.h"
#import "ToDoListTableViewPinchToAdd.h"

#define CELL_HEIGHT 88

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) ToDoListTable *cTableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property  (nonatomic,strong) ToDoListTableViewAddNew *nTableView;
@property (nonatomic,strong) ToDoListTableViewPinchToAdd *pTableView;

@property (nonatomic,strong) NSDateFormatter *dayFormatter;
@property (nonatomic,strong) NSDateFormatter *originalFormatter;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic) float editingOffset;

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
            [[ToDoListManager sharedManager] addToDoListWithText:@"Kiss my ass"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Execelent in C++"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Pro c#"];
            [[ToDoListManager sharedManager] addToDoListWithText:@"Also ruby"];
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
    CGRect headerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
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
    //self.cTableView = [[ToDoListTable alloc] init];
    self.cTableView = [[ToDoListTable alloc] init];
    //self.tableView.backgroundColor = [UIColor clearColor];
    self.cTableView.delegate = self;
    self.cTableView.dataSource = self;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cTableView.backgroundColor = [UIColor blackColor];
    [self.cTableView registerClassForCells:[ToDoListTableViewCell class]];
    //self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    //self.tableView.pagingEnabled = YES;
    self.cTableView.frame = CGRectOffset(self.cTableView.frame, 0, 20);
    //[self.view addSubview:self.cTableView];
    self.nTableView = [[ToDoListTableViewAddNew alloc] initWithTableView:self.cTableView];
    self.pTableView = [[ToDoListTableViewPinchToAdd alloc] initWithTableView:self.cTableView];
    [self.view addSubview:self.cTableView];
    //self.tableView.backgroundColor  = UIColorFromRGB(0xffffff);
   // [self.tableView registerClass:[ToDoListTableViewCell class] forCellReuseIdentifier:@"List Cell"];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //hide the 1st section of UITableView in grouped style
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
//        self.tableView.contentInset = UIEdgeInsetsMake(-2*CELL_HEIGHT, 0, 0, 0);
//    }
    
    
    
    //self.tableView.tableHeaderView = header;
    
    
    
}

-(UIColor*)colorForIndex:(NSInteger) index {
    //NSUInteger itemCount = self.list.count - 1;
    float val = index*0.12;
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
    self.cTableView.frame = bounds;
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

#pragma mark - ToDoListTableDataSource
-(NSInteger)numberOfRows{
    return self.list.count;
}

-(UITableViewCell *)cellForRow:(NSInteger)row{
    //static NSString *CellIdentifier = @"List Cell";
    //ToDoListTableViewCell *cell = [[ToDoListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    ToDoListTableViewCell *cell = (ToDoListTableViewCell *)[self.cTableView dequeueResuableCell];
    
    //    if (! cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    //    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    ToDoListModel *item = self.list[row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    //cell.textLabel.text = item.toDoGoal;
    cell.delegate = self.cTableView;
    cell.toDoItem = item;
    cell.backgroundColor = [self colorForIndex:row];
    return cell;
}

-(void)itemAdded{
    [self itemAddedAtIndex:0];
}

-(void)itemAddedAtIndex:(NSInteger)index{
    //create the new item
    ToDoListModel *toDoItem = [[ToDoListModel alloc] init];
    [_list insertObject:toDoItem atIndex:index];
    //refresh the table
    [_cTableView reloadData];
    
    //enter the edit mode
    ToDoListTableViewCell *editCell;
    for(ToDoListTableViewCell *cell in [_cTableView visibleCells]){
        if(cell.toDoItem == toDoItem){
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
}

#pragma make - UITableViewDataSource
    
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.list.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"List Cell";
//    ToDoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
////    if (! cell) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
////    }
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    //cell.detailTextLabel.textColor = [UIColor whiteColor];
//    
//    ToDoListModel *item = self.list[[indexPath row] ];
//    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
//    //cell.textLabel.text = item.toDoGoal;
//    cell.delegate = self;
//    cell.toDoItem = item;
//    
////
////    if(indexPath.section == 0){
////        if(indexPath.row == 0){
////            [self configureHeaderCell:cell title:@"Things to do"];
////        }
////    }else if(indexPath.section == 1){
////        if(indexPath.row==0){
////            [self configureHeaderCell:cell title:@"Things done"];
////        }
////    }
//    return cell;
//}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // TODO: Determine cell height based on screen
//    //NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//    return CELL_HEIGHT;
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor = [self colorForIndex:[indexPath row] ];
//}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 1
//    CGFloat height = scrollView.bounds.size.height;
//    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
//    // 2
//    CGFloat percent = MIN(position / height, 1.0);
//    // 3
//    self.blurredImageView.alpha = percent;
//}

#pragma mark - TodoListTableViewDelegate

-(void)cellDidBeginEditing:(ToDoListTableViewCell *)cell{
    //self.editingOffset = self.tableView.scrollView.contentOffset.y - cell.frame.origin.y;
    _editingOffset = _cTableView.scrollView.contentOffset.y - cell.frame.origin.y;
    for(ToDoListTableViewCell *tCell in [self.cTableView visibleCells]){
        [UIView animateWithDuration:0.3
                         animations:^{
                             tCell.frame = CGRectOffset(tCell.frame, 0.0f, _editingOffset);
                             if(tCell != cell) tCell.alpha = 0.3;
                         }];
    }
}

-(void)cellDidEndEditing:(ToDoListTableViewCell *)cell{
    for(ToDoListTableViewCell *tCell in [self.cTableView visibleCells]){
        [UIView animateWithDuration:0.3
                         animations:^{
                             tCell.frame = CGRectOffset(tCell.frame, 0.0f, -_editingOffset);
                             if(tCell != cell) tCell.alpha = 1.0f;
                         }];
    }
}

-(void)toDoItemDeleted:(ToDoListModel *)item{
    //old school ways using UITtableViewRowAnimationFade
    //    NSUInteger index = [self.list indexOfObject:item];
    //    [self.tableView beginUpdates];
    //    [self.list removeObject:item];
    //    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
    //new way manually animate the cell's location
    float delay = 0.0;
    //remote the model object
    [self.list removeObject:item];
    //find the visible cells
    NSArray *visibleCells = [self.cTableView visibleCells];
    
    UIView *lastView = [visibleCells lastObject];
    bool startAnimation = false;
    
    //iterator over all the cells
    int index = 0;
    for(ToDoListTableViewCell *cell in visibleCells){
        if(startAnimation){
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                                 //cell.backgroundColor = [self colorForIndex:index-1];
                             }
                             completion:^(BOOL finished){
                                 if(cell == lastView ){
                                     [self.cTableView reloadData];
                                 }
                             }];
            delay += 0.03;
        }
        if( cell.toDoItem == item ){
            startAnimation = true;
            cell.hidden = YES;
            //for delete the last cell
            if( cell == lastView) [self.cTableView reloadData];
        }
        index ++;
    }
}



@end
