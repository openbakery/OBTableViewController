//
//
// Created by Rene Pirringer.
//
// 
//


#import <OBTableViewController/OBTableViewController.h>
#import "OBTestCase.h"

@interface OBModelCellBindingTest : OBTestCase
@end



@implementation OBModelCellBindingTest {
	OBModelCellBinding *binding;
	NSArray *propertyBindings;
}

- (void)setUp {

	propertyBindings = @[
		[[UILabelPropertyBinding alloc] initWithSourceName:@"text" andDestinationName:@"textLabel"],
		[[UIImageViewPropertyBinding alloc] initWithSourceName:@"image" andDestinationName:@"imageView"],
		[[OBAccessoryPropertyBinding alloc] initSourceName:@"accessoryType" andDestinationName:@"accessoryType"],
		[[UILabelPropertyBinding alloc] initWithSourceName:@"detailText" andDestinationName:@"detailTextLabel"],
	];

}

- (void)testBindings {
	binding = [[OBModelCellBinding alloc] initWithModelClass:[UITableViewCellModel class] andCellClass:[UITableViewCell class] andPropertyBindings:propertyBindings];

	NSArray *bindings = [binding valueForKey:@"bindings"];

	assertThat(bindings, hasCountOf(4));
}

@end
