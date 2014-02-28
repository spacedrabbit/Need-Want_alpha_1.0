//
//  NWViewController.m
//  Need-Want_alpha_1.0
//
//  Created by Louis Tur on 2/28/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NWViewController.h"

@interface NWViewController ()

@property (strong, nonatomic) NSMutableArray * taskList;
@property (strong, nonatomic) NSMutableArray * completedTaskList;

@property (weak, nonatomic) IBOutlet UITableView *taskTable;

@property (strong, nonatomic) UITextField * addTask;
@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation NWViewController
{
    NSUInteger totalSections;
}

/**********************************
 
 Lazy instantiation of arrays
 
 **********************************/

-(NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
    }
    return _taskList;
}

-(NSMutableArray *)completedTaskList{
    if (!_completedTaskList) {
        _completedTaskList = [NSMutableArray array];
    }
    return _completedTaskList;
}

/**********************************
 
 View methods
 
 **********************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalSections = 3;
    
    //demo tasks
    [self.taskList addObjectsFromArray:@[@"Check on Cat", @"Buy Milk", @"Call Dentist", @"Return Movie Rental"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**********************************
 
 TableView set up
 
 **********************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 1;
    }
    if (section == 1){
         return [self.taskList count];
    }
    else{
        return [self.completedTaskList count];
    }
   
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Add Task:";
    }
    else if (section == 1) {
        return @"Tasks in Progress (get to it!)";
    }
    else{
        return @"Completed Tasks";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return totalSections;
}

/**********************************
 
 Cell contents
 
 **********************************/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"needCell"];
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addTask"];
        
        //creating and adding a textfield progmatically
        self.addTask = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-100.0, tableView.rowHeight)];
        
        [self.addTask setDelegate:self];
        [[cell contentView] addSubview:self.addTask];
        
        //creating and adding a button progmatically
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-100.0, cell.frame.origin.y, 100.0, tableView.rowHeight)];
        [self.addBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.addBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"Add" forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [[cell contentView] addSubview:self.addBtn];
        
        
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = self.taskList[indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.completedTaskList[indexPath.row];
    }
    
    return cell;
}

- (void)addBtn:(UIButton *)sender {
    
    //check to see if something was inputted
    if ([self.addTask.text length] > 0 ){
        //adds task to array
        [self.taskList addObject:self.addTask.text];
    }
    //clears the text field
    self.addTask.text = @"";
    
    //reloads the data in the 1st section
    [self.taskTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    //dismiss keyboard
    [self.view endEditing:TRUE];
}

/**********************************
 
 Task Arrangement Methods
 
 **********************************/

//handles moving tasks from new to completed.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id tempStorage;//placeholder object

    //get the object at the selected index and section, removes it from it's corresponding array and moves it into another array. in this case either tasks > completed, or vice verse
    if(indexPath.section == 1){
        tempStorage = [self.taskList objectAtIndex:indexPath.row];
        [self.taskList removeObjectAtIndex:indexPath.row];
        [self.completedTaskList addObject:tempStorage];
    }
    else if (indexPath.section ==2 ){
        tempStorage = [self.completedTaskList objectAtIndex:indexPath.row];
        [self.completedTaskList removeObjectAtIndex:indexPath.row];
        [self.taskList addObject:tempStorage];
    }
    
    //reloads table data to reflect array changes
    //[tableView reloadData];
    
    //need to create an index set for this to work, define it as a range from 0 to 1, ideally I need a count for total number of sections in the app to make this less static
    NSIndexSet * sectionSets = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, totalSections) ];
    
    [tableView reloadSections:sectionSets withRowAnimation:UITableViewRowAnimationAutomatic];//fade animation

}

/**********************************
 
 Dismissing Keyboard
 
 **********************************/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}
@end
