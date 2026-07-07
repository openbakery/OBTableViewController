//
//
// Created by Rene Pirringer.
//
// 
//


@import Foundation;
@import UIKit;

@class OBTableViewController;


@interface OBDemoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;


@property(nonatomic, strong) OBTableViewController *tableViewController;
@end
