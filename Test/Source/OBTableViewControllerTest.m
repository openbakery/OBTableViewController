//
//
// Created by Rene Pirringer.
//
// 
//




#import <Foundation/Foundation.h>
#import "OBTableViewSection.h"
#import "OBTableViewController.h"
#import "UITableViewCellModel.h"
#import "Mock.h"


@interface OBTableViewControllerTest : XCTestCase
@end

@implementation OBTableViewControllerTest {
	OBTableViewController *tableViewController;
}

- (void)setUp {
	tableViewController = [[OBTableViewController alloc] init];
	tableViewController.tableView = [[UITableView alloc] init];
}

- (void)testOneSection {

	OBTableViewSection *section = [[OBTableViewSection alloc] init];
	[tableViewController addSection:section];

	NSInteger numberOfSections = [tableViewController numberOfSectionsInTableView:tableViewController.tableView];
	assertThatInteger(numberOfSections, is(equalToInt(1)));
}

- (void)testMultipleSections {
	NSInteger numberSections = 5;
	for (int i=0; i<numberSections; i++){
		NSLog(@"ADD SECTION %d", i);
		OBTableViewSection *section = [[OBTableViewSection alloc] init];
		[tableViewController addSection:section];
	}

	NSInteger numberOfSections = [tableViewController numberOfSectionsInTableView:tableViewController.tableView];
	assertThatInteger(numberOfSections, is(equalTo(@(numberSections))));

}


- (void)testModelInSection {

	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];

	[tableViewController addModel:model toSection:section];

	NSInteger rows = [tableViewController tableView:tableViewController.tableView numberOfRowsInSection:0];
	assertThatInteger(rows, is(equalToInt(1)));
}

- (void)testAddModelsToSection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];
	NSInteger numberModels = 5;
	for (int i=0; i<numberModels; i++){
		UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
		[tableViewController addModel:model toSection:section];
	}

	NSInteger rows = [tableViewController tableView:tableViewController.tableView numberOfRowsInSection:0];
	assertThatInteger(rows, is(equalToInt(5)));
}

- (void)testInsertModelToSection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];

	UITableViewCellModel *modelToInsert = [[UITableViewCellModel alloc] init];
	[tableViewController insertModel:modelToInsert toSection:section];

	NSIndexPath *indexPath = [tableViewController indexPathForModel:modelToInsert];

	assertThatInteger(indexPath.row, is(equalToInt(0)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

	// the model must now be on second position
	indexPath = [tableViewController indexPathForModel:model];
	assertThatInteger(indexPath.row, is(equalToInt(1)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));
}

- (void)testInsertModelsToSection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];

	UITableViewCellModel *first = [[UITableViewCellModel alloc] init];
	UITableViewCellModel *second = [[UITableViewCellModel alloc] init];
	[tableViewController insertModels:@[first, second] toSection:section];

	NSIndexPath *indexPath = [tableViewController indexPathForModel:first];

	assertThatInteger(indexPath.row, is(equalToInt(0)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

	// the model must now be on third position
	indexPath = [tableViewController indexPathForModel:model];
	assertThatInteger(indexPath.row, is(equalToInt(2)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));
}


- (void)testAppendModelToSection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];

	UITableViewCellModel *modelToInsert = [[UITableViewCellModel alloc] init];
	[tableViewController appendModel:modelToInsert toSection:section];

	NSIndexPath *indexPath = [tableViewController indexPathForModel:modelToInsert];

	assertThatInteger(indexPath.row, is(equalToInt(1)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

	// the model must now be on second position
	indexPath = [tableViewController indexPathForModel:model];
	assertThatInteger(indexPath.row, is(equalToInt(0)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

}

- (void)testNoTableHeader {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];
	[tableViewController addSection:section];

	CGFloat height = [tableViewController tableView:tableViewController.tableView heightForHeaderInSection:0];
	assertThatFloat(height, is(equalToFloat(0.0)));

}

- (void)testTableHeader {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];
	section.headerTitle = @"Header";
	[tableViewController addSection:section];

	CGFloat height = [tableViewController tableView:tableViewController.tableView heightForHeaderInSection:0];
	assertThatFloat(height, is(equalToFloat(UITableViewAutomaticDimension)));

	NSString *title = [tableViewController tableView:tableViewController.tableView titleForHeaderInSection:0];
	assertThat(title, is(equalTo(@"Header")));
}

@end