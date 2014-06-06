//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBAccessoryPropertyBinding.h"
#import "OBProperty.h"


@implementation OBAccessoryPropertyBinding {

}


- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	self = [super init];
	if (self) {
		self.sourceProperty = [[OBProperty alloc] initIntegerWithName:sourceName];
		self.destinationProperty = [[OBProperty alloc] initIntegerWithName:destinationName];
	}
	return self;
}

- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	NSNumber* value = [self.sourceProperty valueForObject:sourceObject];
	[self.destinationProperty setValueForObject:destinationObject toValue:value];
}
@end