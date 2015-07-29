//
//  AddEvent.m
//  safe_test3
//
//  Created by bbiiggppiigg on 2015/7/29.
//  Copyright (c) 2015年 bbiiggppiigg. All rights reserved.
//

#import "AddEvent.h"

@implementation AddEvent

NSArray * tableData;
-(void) viewDidLoad{
    [super viewDidLoad];
    tableData = [NSArray arrayWithObjects:@"Egg Benedict",@"Mushroom Ristto",nil];
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateSelectionTextField setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]  initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate) ];
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems: [NSArray arrayWithObjects:space,doneBtn,nil]];
    [self.dateSelectionTextField setInputAccessoryView:toolBar];
}

-(void) ShowSelectedDate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MMM/dd hh:mm"];
    self.dateSelectionTextField.text =[NSString stringWithFormat:@"%@", [formatter stringFromDate: datePicker.date ] ];
    [self.dateSelectionTextField resignFirstResponder];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [super tableView:tableView numberOfRowsInSection : (section)];
}
-(UITableViewCell *) tableView : (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    /*static NSString * simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;*/
}

@end
