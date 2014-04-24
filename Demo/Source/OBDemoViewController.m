//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBDemoViewController.h"
#import "UITableViewCellModel.h"
#import "OBTableViewController.h"
#import "OBTableViewSection.h"


@implementation OBDemoViewController {

	OBTableViewSection *_firstSection;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableViewController = [[OBTableViewController alloc] init];
	self.tableViewController.tableView = self.tableView;
	self.tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;

	[self.tableViewController registerIdentifier:@"TableViewCell" modelClass:[UITableViewCellModel class]];
	
	_firstSection = [[OBTableViewSection alloc] init];
	[self.tableViewController addSection:_firstSection];

	[self addItem:nil];
	[self addItem:nil];
	[self addItem:nil];
}


- (IBAction)addItem:(id)sender {
	static int count;

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	model.text = [NSString stringWithFormat:@"Item %@", [@(count) stringValue]];

	[self.tableViewController insertModel:model toSection:_firstSection];
	count++;
}

@end