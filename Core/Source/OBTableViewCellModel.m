//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBTableViewCellModel.h"
#import "OBModelCellBinding.h"


@implementation OBTableViewCellModel {

}

/*
- (id)initWithBindings:(NSArray)*binding {
	self = [super init];
	if (self) {



		[self addPropertyBinding:[[UILabelPropertyBinding alloc] initSourceName:@"text" andDestinationName:@"textLabel"]];
		[self addPropertyBinding:[[UIImageViewPropertyBinding alloc] initSourceName:@"image" andDestinationName:@"imageView"]];

		binding = [[OBModelCellBinding alloc] initWithModelClass:[self class] andCellClass:[cell class] andPropertyBindings:_propertyBindings];
	}
}
*/

- (OBModelCellBinding *)binding {
	return nil;
}

@end