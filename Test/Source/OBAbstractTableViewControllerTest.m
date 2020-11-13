//
// Created by Rene Pirringer on 23.03.15.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OBAbstractTableViewController.h"
#import "OBCustomTableViewCell.h"
#import "OBTableViewControllerDelegate.h"

@interface OBAbstractTableViewControllerTest : XCTestCase
@end

@implementation OBAbstractTableViewControllerTest {
	OBAbstractTableViewController *tableViewController;
}

- (void)setUp {
	tableViewController = [[OBAbstractTableViewController alloc] init];
}


- (void)testRegisterCellClass {

	UITableView *tableView = mock([UITableView class]);
	tableViewController.tableView = tableView;
	[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[NSString class]];

	[verify(tableView) registerClass:[OBCustomTableViewCell class] forCellReuseIdentifier:@"OBCustomTableViewCell"];
}


- (void)testDynamicHeight {
	assertThatBool(tableViewController.dynamicCellHeight, is(@NO));
}


- (void)test_willDisplayCell_delegate_is_called_when_tableView_cell_will_be_displayed {
	UITableView *tableView = [[UITableView alloc] init];
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

	id <OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	tableViewController.delegate = delegate;

	// when
	[tableViewController tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];


	// then
	[verify(delegate) tableViewController:anything() willDisplayCell:cell withModel:anything()];
}


- (void)test_willDisplayHeader_delegate_is_called_when_tableView_header_will_be_displayed {
	UITableView *tableView = [[UITableView alloc] init];
	UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];

	id <OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	tableViewController.delegate = delegate;

	// when
	[tableViewController tableView:tableView willDisplayHeaderView:headerView forSection:0];


	// then
	[verify(delegate) tableViewController:anything() willDisplayHeader:headerView forSection:0];
}


- (void)test_willDisplayFooter_delegate_is_called_when_tableView_header_will_be_displayed {
	UITableView *tableView = [[UITableView alloc] init];
	UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] init];

	id <OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	tableViewController.delegate = delegate;

	// when
	[tableViewController tableView:tableView willDisplayFooterView:footerView forSection:0];


	// then
	[verify(delegate) tableViewController:anything() willDisplayFooter:footerView forSection:0];
}


- (void)test_cell_for_model_that_was_not_added_should_not_crash {
	// when
	UITableViewCell *cell = [tableViewController cellForModel:@"does not exist"];
	
	// then
	assertThat(cell, nilValue());
}

@end

