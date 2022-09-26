//
// Created by Rene Pirringer
//

#import "OBIntegerPropertyBinding.h"
#import <OBTableViewController/OBProperty.h>


@implementation OBIntegerPropertyBinding {

}

- (id)initWithSourceName:(NSString *)sourceName destinationName:(NSString *)destinationName {
	self = [super init];
	if (self) {
		if (sourceName) {
			self.sourceProperty = [[OBProperty alloc] initIntegerWithName:sourceName];
		}
		self.destinationProperty = [[OBProperty alloc] initIntegerWithName:destinationName];
	}
	return self;
}

- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	NSNumber* value = [self.sourceProperty valueForObject:sourceObject];
	[self.destinationProperty setValueForObject:destinationObject toValue:value];
}

@end
