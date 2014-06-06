//
//
// Created by Rene Pirringer on 19.02.14.

//
// 
//


#import <Foundation/Foundation.h>
#import "OBSimpleTableViewController.h"
#import "UITableViewCellModel.h"
#import "OBCustomTableViewCell.h"
#import "Mock.h"


@interface OBSimpleTableViewControllerTest : XCTestCase
@end


@implementation OBSimpleTableViewControllerTest {
	OBSimpleTableViewController *tableViewController;
	UITableView *tableView;
}


- (void)setUp {
	tableViewController = [[OBSimpleTableViewController alloc] init];
	tableView = [[UITableView alloc] init];
}

- (void)testNumberRows_0 {
	NSInteger rows = [tableViewController tableView:tableView numberOfRowsInSection:0];
	assertThatInteger(rows, is(equalToInt(0)));
}

- (void)testNumberRows_5 {

	for (int i=0; i<5; i++) {
		UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
		[tableViewController addModel:model];
	}

	NSInteger rows = [tableViewController tableView:tableView numberOfRowsInSection:0];
	assertThatInteger(rows, is(equalToInt(5)));

}


- (void)testFirstCell {
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model];

	UITableViewCell *cell = [tableViewController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThat(cell, is(instanceOf([UITableViewCell class])));
}

- (void)testCustomTableCell {
	NSString *identifier = @"OBCustomTableViewCell";

	tableView = mock([UITableView class]);
	[given([tableView dequeueReusableCellWithIdentifier:identifier]) willReturn:[[OBCustomTableViewCell alloc] init]];

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];

	[tableViewController registerIdentifier:identifier modelClass:[UITableViewCellModel class]];

	[tableViewController addModel:model];

	UITableViewCell *cell = [tableViewController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThat(cell, is(instanceOf([OBCustomTableViewCell class])));

}

- (void)testCellText {
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	model.text = @"MyText";
	[tableViewController addModel:model];

	UITableViewCell *cell = [tableViewController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThat(cell, is(instanceOf([UITableViewCell class])));

	assertThat(cell.textLabel.text, is(equalTo(@"MyText")));
}

- (void)testFirstSelected {
	tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model];


	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	UITableViewCell *cell = [tableViewController tableView:tableViewController.tableView cellForRowAtIndexPath:indexPath];

	assertThatInt(cell.accessoryType, is(equalToInt(UITableViewCellAccessoryCheckmark)));

	assertThatInteger([tableViewController.selectedModels count], is(equalToInt(1)));

}

- (void)testFirstSelectedAndDeselected {
	tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];


	tableView = mock([UITableView class]);
	tableViewController.tableView = tableView;

	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	UITableViewCell *cell = [tableViewController tableView:tableViewController.tableView cellForRowAtIndexPath:indexPath];

	assertThatInt(cell.accessoryType, is(equalToInt(UITableViewCellAccessoryNone)));


	MKTArgumentCaptor *indexPathsArguments = [[MKTArgumentCaptor alloc] init];
	[verify(tableView) reloadRowsAtIndexPaths:[indexPathsArguments capture] withRowAnimation:UITableViewRowAnimationAutomatic];
	NSArray *indexPaths = [indexPathsArguments value];
	assertThatInteger([indexPaths count], is(equalToInt(1)));
	NSIndexPath *resultIndexPath = [indexPaths objectAtIndex:0];
	assertThatInteger(resultIndexPath.row, is(equalToInt(0)));
	assertThatInteger(resultIndexPath.section, is(equalToInt(0)));


}


- (void)testFirstSelectedAndThenSecond {
	tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;

	UITableViewCellModel *first = [[UITableViewCellModel alloc] init];
	UITableViewCellModel *second = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:first];
	[tableViewController addModel:second];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];


	tableView = mock([UITableView class]);
	tableViewController.tableView = tableView;

	indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	MKTArgumentCaptor *indexPathsArguments = [[MKTArgumentCaptor alloc] init];
	[verify(tableView) reloadRowsAtIndexPaths:[indexPathsArguments capture] withRowAnimation:UITableViewRowAnimationAutomatic];

	NSArray *indexPaths = [indexPathsArguments value];

	assertThatInteger([indexPaths count], is(equalToInt(2)));

	NSIndexPath *resultIndexPath = [indexPaths objectAtIndex:0];
	assertThatInteger(resultIndexPath.row, is(equalToInt(0)));
	assertThatInteger(resultIndexPath.section, is(equalToInt(0)));

	resultIndexPath = [indexPaths objectAtIndex:1];
	assertThatInteger(resultIndexPath.row, is(equalToInt(1)));
	assertThatInteger(resultIndexPath.section, is(equalToInt(0)));

}


- (void)testShouldSelectModel {
	tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;
	id<OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	tableViewController.delegate = delegate;

	[given([delegate shouldSelectModel:anything()]) willReturnBool:NO];

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	assertThatInteger([tableViewController.selectedModels count], is(equalToInt(0)));

}

- (void)testShouldDeselectModel {

	tableViewController.selectionMode = OBTableViewControllerSelectionSingleCheck;
	id<OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	tableViewController.delegate = delegate;

	[given([delegate shouldDeselectModel:anything()]) willReturnBool:NO];
	[given([delegate shouldSelectModel:anything()]) willReturnBool:YES];

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	assertThatInteger([tableViewController.selectedModels count], is(equalToInt(1)));

}

@end