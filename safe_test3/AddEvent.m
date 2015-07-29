//
//  AddEvent.m
//  safe_test3
//
//  Created by bbiiggppiigg on 2015/7/29.
//  Copyright (c) 2015年 bbiiggppiigg. All rights reserved.
//

#import "AddEvent.h"
#import "Database.h"

@interface AddEvent()

+ (sqlite3 *)database;
+ (void)setDatabase :(sqlite3 *)newDatabase;

@property (strong, nonatomic) IBOutlet UITextField *event_title;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freq;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *eventsDB;

@end


@implementation AddEvent


-(void) viewDidLoad{
    [super viewDidLoad];
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateSelectionTextField setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]  initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate) ];
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems: [NSArray arrayWithObjects:space,doneBtn,nil]];
    [self.dateSelectionTextField setInputAccessoryView:toolBar];
    
    [self initDB];
}

-(void)initDB{
    BOOL write_success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDictionary = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDictionary stringByAppendingPathComponent:@"events.sqlite"];
    NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"events.sqlite"];
    
    if ([fileManager fileExistsAtPath: defaultDBPath ] == NO){
        const char *dbpath = [defaultDBPath UTF8String];
        if (sqlite3_open(dbpath, &_eventsDB) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS EVENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, EVENT_TITLE TEXT, EVENT_TIME TEXT, FREQ TEXT)";
            if (sqlite3_exec(_eventsDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"Failed to create table");
            }else{
                NSLog(@"create table successful");
            }
            sqlite3_close(_eventsDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }else{
        NSLog(@"file is not exsit at defaultdbpath");
    }
}


- (IBAction)onButntest:(UIButton *)sender {
    [self saveData:self];
}

- (void) saveData:(id)sender
{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_eventsDB) == SQLITE_OK){
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO events (event_title, event_time, freq) VALUES (\"%@\", \"%@\",\"1\")",
                               self.event_title.text, self.date.text];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_eventsDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_prepare_v2(_eventsDB, insert_stmt, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"insert failed: %s", sqlite3_errmsg(_eventsDB));
        }
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Contact added");
            self.event_title.text = @"";
            self.date.text = @"";
        } else {
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_eventsDB);
    }
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
