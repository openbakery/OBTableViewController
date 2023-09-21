//
//
// Created by Rene Pirringer.
//
// 
//


@import XCTest;
@import OCHamcrest;
#import <Foundation/Foundation.h>
#import <OBTableViewController/OBTableViewController.h>
#import "OBSearchBarTableViewCell.h"

@interface UISearchBarPropertyBindingTest : XCTestCase
@end

@implementation UISearchBarPropertyBindingTest {

}

- (void)testBinding {

	UITableViewCellModel *model = [[UITableViewCellModel alloc] init];
	model.text = @"Test";

	UISearchBarPropertyBinding *binding = [[UISearchBarPropertyBinding alloc] initSourceName:@"text" andDestinationName:@"searchBar"];
	OBSearchBarTableViewCell *destination = [[OBSearchBarTableViewCell alloc] init];
	destination.searchBar = [[UISearchBar alloc] init];


	[binding setValueFrom:model to:destination];

	assertThat(destination.searchBar.text, is(equalTo(@"Test")));
}

@end
