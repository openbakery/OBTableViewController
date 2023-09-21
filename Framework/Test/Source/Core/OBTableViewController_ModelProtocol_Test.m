//
// Created by René Pirringer on 16.04.20.
// Copyright (c) 2020 Rene Pirringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import OCHamcrest;
#import <XCTest/XCTest.h>
#import <OBTableViewController/OBTableViewController.h>


@interface OBTableViewController_ModelProtocol_Test : XCTestCase
@end


@implementation OBTableViewController_ModelProtocol_Test {
	OBTableViewController *tableViewController;
	OBTableViewSection *section;
	UITableView *tableView;
}

- (void)setUp {
	[super setUp];
	tableViewController = [[OBTableViewController alloc] init];
	tableView = [[UITableView alloc] init];
	tableViewController.tableView = tableView;
	section = [[OBTableViewSection alloc] init];
	[tableViewController addSection:section];
	[tableViewController registerTableViewCellClass:[OBTableViewCell class] modelClass:[OBCellModel class]];
	[tableViewController removeAllPropertyBindings];
}

- (void)tearDown {
	tableViewController = nil;
	section = nil;
	[super tearDown];
}

- (void)test_model_based_cell_is_present {
	OBCellModel *model = [[OBCellModel alloc] initWithText:@"Text"];
	[tableViewController addModel:model toSection:section];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

	// when
	UITableViewCell *cell = [tableViewController tableView:tableView cellForRowAtIndexPath:indexPath];

	// then
	assertThat(cell, instanceOf([OBTableViewCell class]));
}

- (void)test_model_based_cell_is_present_and_the_model_was_property_set {
	OBCellModel *model = [[OBCellModel alloc] initWithText:@"Lorem Ipsum"];
	[tableViewController addModel:model toSection:section];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

	// when
	UITableViewCell *cell = [tableViewController tableView:tableView cellForRowAtIndexPath:indexPath];

	// then
	assertThat(cell, instanceOf([OBTableViewCell class]));
	assertThat(cell.textLabel.text, equalTo(@"Lorem Ipsum"));
}

@end
