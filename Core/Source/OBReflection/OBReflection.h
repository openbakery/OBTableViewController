//
//
// Created by rene on 20.02.14.
// Copyright 2014 openbakery.org. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>

@class OBProperty;


@interface OBReflection : NSObject

+ (NSArray *)getPropertiesForClass:(Class)clazz;

+ (OBProperty *)propertyWithName:(NSString*)name forClass:(Class)clazz;

@end