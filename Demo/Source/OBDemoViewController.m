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
#import "OBInsertViewController.h"


@implementation OBDemoViewController {
	NSMutableArray* _colorModels;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableViewController = [[OBTableViewController alloc] init];
	self.tableViewController.tableView = self.tableView;
	self.tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;

	[self.tableViewController registerIdentifier:@"TableViewCell" modelClass:[UITableViewCellModel class]];
	
	[self.tableViewController addSection:[[OBTableViewSection alloc] initWithHeaderTitle:@"First"]];
	[self.tableViewController addSection:[[OBTableViewSection alloc] initWithHeaderTitle:@"Second"]];
	[self.tableViewController addSection:[[OBTableViewSection alloc] initWithHeaderTitle:@"Third"]];
	[self.tableViewController addSection:[[OBTableViewSection alloc] initWithHeaderTitle:@"Forth"]];

	NSArray *colors = @[ @"White", @"Silver", @"Gray", @"Black", @"Red", @"Maroon", @"Yellow", @"Olive", @"Lime", @"Green", @"Aqua", @"Teal", @"Blue", @"Navy", @"Fuchsia", @"Purple" ];

	_colorModels = [[NSMutableArray alloc] init];
	for (NSString *color in colors) {
		UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
		model.text = color;

		[_colorModels addObject:model];
	}

}


- (IBAction)addItem:(NSString *)name toSection:(OBTableViewSection *)section{
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	model.text = name;
	[self.tableViewController insertModel:model toSection:section];
}


- (IBAction)addRandom:(id)sender{
	NSMutableArray *models = [[NSMutableArray alloc] init];
	for (UITableViewCellModel *model in _colorModels) {
		if (arc4random() % 2) {
			[models addObject:model];
		}
	}
	OBTableViewSection *firstSection = [self.tableViewController.sections firstObject];
	[self.tableViewController setModels:models toSection:firstSection];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"InsertItem"]) {
		OBInsertViewController *insertViewController = segue.destinationViewController;
		insertViewController.sections = [self.tableViewController sections];
		__weak OBDemoViewController *weakSelf = self;
		insertViewController.completion = ^(NSString *name, OBTableViewSection *section) {
		    [weakSelf addItem:name toSection:section];
		    [weakSelf.navigationController popViewControllerAnimated:YES];
		};
	}
}


@end