//
// Created by Rene Pirringer on 23.03.15.
//

#import "DTTestCase.h"
#import "OBCustomTableViewCell.h"
#import "OBSimpleTableViewController.h"

@interface OBAbstractTableViewControllerTest : DTTestCase
@end

@implementation OBAbstractTableViewControllerTest {
	OBSimpleTableViewController *tableViewController;
}

- (void)setUp {
	tableViewController = [[OBSimpleTableViewController alloc] init];
}


- (void)testRegisterCellClass {

	UITableView *tableView = mock([UITableView class]);
	tableViewController.tableView = tableView;
	[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[NSString class]];

	[verify(tableView) registerClass:[OBCustomTableViewCell class] forCellReuseIdentifier:@"OBCustomTableViewCell"];

}

- (void)testRegisteredCellClass {
	UITableView *tableView = [[UITableView alloc] init];
	tableViewController.tableView = tableView;

	NSString *model = @"Test";

	[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[model class]];
	[tableViewController addModel:model];

	OBCustomTableViewCell *cell =  (OBCustomTableViewCell*)[tableViewController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

	assertThat(cell, is(notNilValue()));
	assertThat(cell, is(instanceOf([OBCustomTableViewCell class])));

}

- (void)testDynamicHeight {
	assertThatBool(tableViewController.dynamicCellHeight, is(@NO));
}

- (void)testStaticCellHeight {
	UITableView *tableView = [[UITableView alloc] init];
	tableViewController.tableView = tableView;
	[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[NSString class]];
	NSString *model = @"Test";
	[tableViewController addModel:model];
	CGFloat height = [tableViewController tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThatFloat(height, is(@100));
}

- (void)testDynamicCellHeight {
	if (self.iOSVersion > 7) {
		UITableView *tableView = [[UITableView alloc] init];
		tableViewController.tableView = tableView;
		tableViewController.dynamicCellHeight = YES;
		[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[NSString class]];
		NSString *model = @"Test";
		[tableViewController addModel:model];
		CGFloat height = [tableViewController tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		assertThatFloat(height, is(@(UITableViewAutomaticDimension)));
	}
}


- (void)testStaticCellHeight_iOS7 {
	UITableView *tableView = [[UITableView alloc] init];
	tableViewController.tableView = tableView;
	[tableViewController registerTableViewCellClass:[OBCustomTableViewCell class] modelClass:[NSString class]];
	NSString *model = @"Test";
	[tableViewController addModel:model];
	CGFloat height = [tableViewController tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThatFloat(height, is(@100));

	height = [tableViewController tableView:tableView estimatedHeightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThatFloat(height, is(@100));


}


@end

