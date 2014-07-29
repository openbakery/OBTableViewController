//
//
// Created by Rene Pirringer.
//
// 
//




#import <Foundation/Foundation.h>
#import "OBTableViewSection.h"
#import "OBTableViewController.h"
#import "Mock.h"
#import "UITableViewCellModel.h"


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

- (void)testSingleSection {


	tableViewController.selectionMode = OBTableViewControllerSelectionSingleSelection;
	OBTableViewSection *section = [[OBTableViewSection alloc] init];


	[tableViewController addSection:section];
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];

	id<OBTableViewControllerDelegate> delegate = mockProtocol(@protocol(OBTableViewControllerDelegate));
	[given([delegate shouldSelectModel:anything()]) willReturnBool:NO];
	tableViewController.delegate = delegate;

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];

	UITableViewCell *cell = [tableViewController tableView:tableViewController.tableView cellForRowAtIndexPath:indexPath];
	[tableViewController tableView:tableViewController.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
	assertThat(cell, is(instanceOf([UITableViewCell class])));
	assertThatBool(cell.selected, is(equalToBool(NO)));

}


- (void) testEditingEmpty {
	tableViewController.editing = YES;
	assertThatBool(tableViewController.editing, is(equalToBool(NO)));
}

- (void)testEditing {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];
	[tableViewController addSection:section];
	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];
	tableViewController.editing = YES;

	assertThatBool(tableViewController.editing, is(equalToBool(YES)));

}

- (void)testEditingDisabledBySection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];
	section.editable = NO;
	[tableViewController addSection:section];

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	[tableViewController addModel:model toSection:section];
	tableViewController.editing = YES;

	assertThatBool(tableViewController.editing, is(equalToBool(NO)));
}


- (void)testOneSectionEditable {
	OBTableViewSection *notEditableSection = [[OBTableViewSection alloc] init];
	notEditableSection.editable = NO;
	[tableViewController addSection:notEditableSection];
	[tableViewController addModel: [[UITableViewCellModel alloc] init] toSection:notEditableSection];


	OBTableViewSection *editableSection = [[OBTableViewSection alloc] init];
	[tableViewController addSection:editableSection];
	[tableViewController addModel: [[UITableViewCellModel alloc] init] toSection:editableSection];

	tableViewController.editing = YES;
	assertThatBool(tableViewController.editing, is(equalToBool(YES)));


	BOOL canEdit = [tableViewController tableView:tableViewController.tableView canEditRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThatBool(canEdit, is(equalToBool(NO)));

	canEdit = [tableViewController tableView:tableViewController.tableView canEditRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	assertThatBool(canEdit, is(equalToBool(YES)));

}


- (void)testAppendModelsToSection {
	OBTableViewSection *section = [[OBTableViewSection alloc] init];

	[tableViewController addSection:section];

  UITableViewCellModel *model = [[UITableViewCellModel alloc] init];

	[tableViewController addModel:model toSection:section];

	UITableViewCellModel *modelToInsert1 = [[UITableViewCellModel alloc] init];
	UITableViewCellModel *modelToInsert2 = [[UITableViewCellModel alloc] init];
	[tableViewController appendModels:@[modelToInsert1, modelToInsert2] toSection:section];

	NSIndexPath *indexPath = [tableViewController indexPathForModel:modelToInsert1];

	assertThatInteger(indexPath.row, is(equalToInt(1)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

	indexPath = [tableViewController indexPathForModel:modelToInsert2];
	assertThatInteger(indexPath.row, is(equalToInt(2)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));


	indexPath = [tableViewController indexPathForModel:model];
	assertThatInteger(indexPath.row, is(equalToInt(0)));
	assertThatInteger(indexPath.section, is(equalToInt(0)));

}

@end