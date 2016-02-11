//
//
//
// Created by Rene Pirringer
//
// 
//


#import <Foundation/Foundation.h>

@class OBProperty;


@interface OBReflection : NSObject

+ (NSArray *)getPropertiesForClass:(Class)clazz;

+ (OBProperty *)propertyWithName:(NSString*)name forClass:(Class)clazz;

@end