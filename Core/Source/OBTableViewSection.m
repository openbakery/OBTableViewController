//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBTableViewSection.h"


@implementation OBTableViewSection {

}


- (id)copyWithZone:(NSZone *)zone {
	OBTableViewSection *copy = [[self class] allocWithZone:zone];
	if (copy) {
		copy.identifier = self.identifier;
	}
	return copy;

}

- (BOOL)isEqual:(id)other {
	if (other == self) {
			return YES;
	}
	if (!other || ![[other class] isEqual:[self class]]) {
			return NO;
	}

	return [self isEqualToSection:other];
}

- (BOOL)isEqualToSection:(OBTableViewSection *)section {
	if (self == section) {
			return YES;
	}
	if (section == nil) {
			return NO;
	}
	if (self.identifier != section.identifier) {
			return NO;
	}
	return YES;
}

- (NSUInteger)hash {
	return (NSUInteger) self.identifier;
}


- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

	[description appendString:@"id="];
	[description appendFormat:@"%d", (int)self.identifier];
	[description appendString:@">"];
	return description;
}


@end