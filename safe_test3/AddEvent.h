//
//  AddEvent.h
//  safe_test3
//
//  Created by bbiiggppiigg on 2015/7/29.
//  Copyright (c) 2015年 bbiiggppiigg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface AddEvent : UITableViewController
{
    UIDatePicker * datePicker;
}
@property (weak, nonatomic) IBOutlet UITextField * dateSelectionTextField;


@end
