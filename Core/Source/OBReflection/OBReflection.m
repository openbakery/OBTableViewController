//
// ELO 
//
// Created by rene on 20.02.14.
// Copyright 2014 Drobnik.com. All rights reserved.
//
// 
//


#import <objc/runtime.h>
#import "OBReflection.h"
#import "OBProperty.h"


@implementation OBReflection {

}

+ (OBProperty *)propertyForProperty:(objc_property_t)property {
	const char *type = property_getAttributes(property);
	NSString *typeString = [NSString stringWithUTF8String:type];

	const char *propertyName = property_getName(property);
	NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];

	//DDLogDebug(@"property name: %@", propertyNameString);
	//DDLogDebug(@"property type: %@", typeString);
	return [[OBProperty alloc] initWithName:propertyNameString andTypeString:typeString];
}


+ (NSArray *)getPropertiesForClass:(Class)clazz {

	NSMutableArray *result = [[NSMutableArray alloc] init];
	unsigned int count = 0;

	// add properties from all superclasses
	Class superClass = class_getSuperclass(clazz);
	if (superClass && ![superClass isEqual:[NSObject class]]) {
		[result addObjectsFromArray:[self getPropertiesForClass:superClass]];
	}

	objc_property_t* properties = class_copyPropertyList(clazz, &count);
	for (int i=0; i<count; i++) {
		/*
		const char *type = property_getAttributes(*properties);
		NSString *typeString = [NSString stringWithUTF8String:type];

		const char *propertyName = property_getName(*properties);
		NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];

		//DDLogDebug(@"property name: %@", propertyNameString);
		//DDLogDebug(@"property type: %@", typeString);
		OBProperty *property = [[OBProperty alloc] initWithName:propertyNameString andTypeString:typeString];
		*/
		[result addObject:[self propertyForProperty:*properties]];

		properties++;
	}

	return result;
}


+ (OBProperty *)propertyWithName:(NSString*)name forClass:(Class)clazz {
	objc_property_t property = class_getProperty(clazz, [name UTF8String]);
	return [self propertyForProperty:property];
}

@end