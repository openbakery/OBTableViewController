//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBTableViewController;


@interface OBDemoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;


@property(nonatomic, strong) OBTableViewController *tableViewController;
@end