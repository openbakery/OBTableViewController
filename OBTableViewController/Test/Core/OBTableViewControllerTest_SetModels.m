//
// Created by Rene Pirringer on 11.02.16.
//

#import <OBTableViewController/OBTableViewController.h>
#import "UITableViewStub.h"
#import "OBTestCase.h"

@interface OBTableViewControllerTest_SetModels : OBTestCase
@end

@implementation OBTableViewControllerTest_SetModels {
	OBTableViewController *tableViewController;
	UITableViewStub *tableView;
	OBTableViewSection *section;
}

- (void)setUp {
	tableViewController = [[OBTableViewController alloc] init];
	tableViewController.tableView = [[UITableView alloc] init];
	tableView = [[UITableViewStub alloc] init];
	tableViewController.tableView = tableView;
	section = [[OBTableViewSection alloc] init];
	[tableViewController addSection:section];
	[tableViewController addModels:@[@"A", @"E", @"I"] toSection:section];

}


- (void)testSetModelsInsert {
	[tableViewController setModels:@[@"A", @"B", @"E", @"I"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(4));

	assertThat(tableView.insertRows, hasCountOf(1));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));
	assertThat(tableView.deleteRows, hasCountOf(0));

}


- (void)testSetModelsInsert_2 {
	[tableViewController setModels:@[@"A", @"B", @"C", @"E", @"I"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(5));

	assertThat(tableView.insertRows, hasCountOf(2));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:2 inSection:0]));
	assertThat(tableView.deleteRows, hasCountOf(0));

}


- (void)testSetModelsInsert_3 {
	[tableViewController setModels:@[@"A", @"B", @"C", @"E", @"F", @"I"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(6));

	assertThat(tableView.insertRows, hasCountOf(3));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:2 inSection:0]));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:4 inSection:0]));
	assertThat(tableView.deleteRows, hasCountOf(0));

}


- (void)testSetModelsRemove {
	[tableViewController setModels:@[@"A", @"I"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(2));

	assertThat(tableView.deleteRows, hasCountOf(1));
	assertThat(tableView.deleteRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));
	assertThat(tableView.insertRows, hasCountOf(0));

}

- (void)testSetModelsRemove_2 {
	[tableViewController setModels:@[@"E"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(1));

	assertThat(tableView.deleteRows, hasCountOf(2));
	assertThat(tableView.deleteRows, hasItem([NSIndexPath indexPathForRow:0 inSection:0]));
	assertThat(tableView.deleteRows, hasItem([NSIndexPath indexPathForRow:2 inSection:0]));
	assertThat(tableView.insertRows, hasCountOf(0));

}


- (void)testSetModelsInsertAndRemove {
	[tableViewController setModels:@[@"A", @"B", @"I"] toSection:section];

	assertThat([tableViewController modelsForSection:section], hasCountOf(3));

	assertThat(tableView.insertRows, hasCountOf(1));
	assertThat(tableView.insertRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));
	assertThat(tableView.deleteRows, hasCountOf(1));
	assertThat(tableView.deleteRows, hasItem([NSIndexPath indexPathForRow:1 inSection:0]));

}

- (void)testAnimateOnlyOnUpdate_When_Empty {
	[tableViewController removeAllModelsFromSection:section];
	[tableViewController setModels:@[@"E", @"F"] toSection:section];
	assertThat(tableView.insertRows, hasCountOf(0));

	assertThatInteger([tableViewController tableView:tableView numberOfRowsInSection:0], is(@(2)));
	assertThatBool(tableView.hasReloadData, is(@YES));
}



- (void)testAnimateOnUpdate_HasEntriesInAnotherSection {
	OBTableViewSection *secondSection = [[OBTableViewSection alloc] init];
	[tableViewController addSection:secondSection];
	[tableViewController setModels:@[@"E", @"F"] toSection:secondSection];
	assertThat(tableView.insertRows, hasCountOf(2));
}



@end
