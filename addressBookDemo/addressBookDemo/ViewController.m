//
//  ViewController.m
//  addressBookDemo
//
//  Created by YXZT on 16/9/12.
//  Copyright © 2016年 YXZT. All rights reserved.
//

#import "ViewController.h"
#import "SDContactModel.h"
#import "SDContactsTableViewCell.h"
#import "SDAnalogDataGenerator.h"

#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];

    [self getData];
    
    
}

-(void)creatView
{
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppFrameWidth, 50)];
    showView.backgroundColor = [UIColor redColor];
    [self.view addSubview:showView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(showView.frame), kAppFrameWidth, kAppFrameHeight-50) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

-(void)getData
{
    self.dataArray = [NSMutableArray array];
    NSArray *nameArray = @[@"和课",@"和平",@"你好",@"he",@"我的",@"你的",@"咱们的",@"你呢"];
    NSArray *number = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    for (int i = 0 ; i<nameArray.count; i++) {
        SDContactModel *model = [SDContactModel new];
        model.name = nameArray[i];
        model.number = number[i];
        model.imageName = [SDAnalogDataGenerator randomIconImageName];
        [self.dataArray addObject:model];
    }
    
    [self setUpTableSection];
}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (SDContactModel *model in self.dataArray) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    self.sectionTitlesArray = [NSMutableArray array];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    self.sectionArray = newSectionArray;
    
}

#pragma mark - delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"SDContacts";
    SDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SDContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SDContactModel *model = self.sectionArray[section][row];
    cell.model = model;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.sectionTitlesArray.count-1) {
        return 1;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHTFORCONTACTSCELL;
}


//title

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 20)];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [self.sectionTitlesArray objectAtIndex:section];
    [view addSubview:label];
    
    return view;
}

//index
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    return self.sectionTitlesArray;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDContactModel *model = self.sectionArray[indexPath.section][indexPath.row];
    NSLog(@"%@",model.number);
}



@end
