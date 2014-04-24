//
//
// Created by Rene Pirringer.
//
// 
//



#import <Foundation/Foundation.h>
#import "UISearchBarPropertyBinding.h"
#import "UISearchBarTestModel.h"
#import "UISearchBarTestTableViewCell.h"
#import "Mock.h"



@interface UISearchBarPropertyBindingTest : XCTestCase
@end

@implementation UISearchBarPropertyBindingTest {

}

- (void)testBinding {

	UISearchBarTestModel *searchEditModel = [[UISearchBarTestModel alloc] initWithSearchText:@"Test-Search"];

	UISearchBarPropertyBinding *binding = [[UISearchBarPropertyBinding alloc] initSourceName:@"searchText" andDestinationName:@"searchBar"];
	UISearchBarTestTableViewCell *destination = [[UISearchBarTestTableViewCell alloc] init];
	destination.searchBar = [[UISearchBar alloc] init];


	[binding setValueFrom:searchEditModel to:destination];

	assertThat(destination.searchBar.text, is(equalTo(@"Test-Search")));
}

@end