//
//
//
// Created by Rene Pirringer on 20.02.14.
// Copyright 2014 openbakery.org. All rights reserved.
//
// 
//


#import "OBProperty.h"



@implementation OBProperty {

	BOOL _isPrimitive;
	NSString *_typeName;
	NSString *_name;
}

- (id)initWithName:(NSString *)name andTypeName:(NSString *)typeName {
	self = [super init];
	if (self) {
		_isPrimitive = YES;
		_name = name;
		_typeName = typeName;

	}
	return self;
}




- (id)initIntegerWithName:(NSString *)name {
	char *intChar = @encode(NSInteger);
	return [self initWithName:name andTypeName:[NSString stringWithFormat:@"%c" , *intChar]];
}


- (id)initFloatWithName:(NSString *)name {
	return [self initWithName:name andTypeName:@"f"];
}

- (id)initLongWithName:(NSString *)name {
	return [self initWithName:name andTypeName:@"l"];
}

- (id)initShortWithName:(NSString *)name {
	return [self initWithName:name andTypeName:@"s"];
}


- (id)initWithName:(NSString *)name andTypeString:(NSString *)typeString {
	self = [super init];
	if (self) {
		_isPrimitive = YES;
		_name = name;
		[self parseTypeString:typeString];

	}
	return self;
}

- (id)initWithName:(NSString *)name andClass:(Class)clazz {
	self = [super init];
		if (self) {
			_isPrimitive = NO;
			_name = name;
			_typeName = NSStringFromClass(clazz);
		}
		return self;
}


- (void)parseTypeString:(NSString *)typeString {

	NSArray *tokens = [typeString componentsSeparatedByString:@","];

	for (NSString *token in tokens) {

		if ([token hasPrefix:@"T@"]) {
			_isPrimitive = NO;
			if (token.length > 3) {
				_typeName = [token substringWithRange:NSMakeRange(3, token.length-4)];
			}
		} else if ([token hasPrefix:@"T"]) {
			_typeName = [token substringFromIndex:1];
		}
	}


}


- (BOOL)isPrimitive {
	return _isPrimitive;
}

- (NSString *)typeName {
	return _typeName;
}

- (NSString *)name {
	return _name;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

	[description appendString:@" name="];
	[description appendString:_name];
	[description appendString:@" typeName="];
	[description appendString:_typeName];

	[description appendString:@">"];
	return description;
}

- (id)valueForObject:(NSObject *)object {
	return [object valueForKey:_name];
}

- (void)setValueForObject:(NSObject *)object toValue:(NSObject *)value {
	[object setValue:value forKey:_name];
}


- (BOOL)isEqual:(id)other {
	if (other == self) {
			return YES;
	}
	if (!other || ![[other class] isEqual:[self class]]) {
			return NO;
	}

	return [self isEqualToProperty:other];
}

- (BOOL)isEqualToProperty:(OBProperty *)property {
	if (self == property) {
			return YES;
	}
	if (property == nil) {
			return NO;
	}
	if (self.isPrimitive != property.isPrimitive) {
			return NO;
	}
	if (self.typeName != property.typeName && ![self.typeName isEqualToString:property.typeName]) {
			return NO;
	}
	if (self.name != property.name && ![self.name isEqualToString:property.name]) {
			return NO;
	}
	return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = (NSUInteger) self.isPrimitive;
	hash = hash * 31u + [self.typeName hash];
	hash = hash * 31u + [self.name hash];
	return hash;
}


@end