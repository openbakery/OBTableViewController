//
//
// Created by rene on 20.02.14.
// Copyright 2014 openbakery.org. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>


@interface OBProperty : NSObject
- (id)initWithName:(NSString *)nameString andTypeString:(NSString *)string;
- (id)initWithName:(NSString *)string andClass:(Class)class;
- (id)initIntWithName:(NSString *)name;
- (id)initFloatWithName:(NSString *)name;
- (id)initLongWithName:(NSString *)name;
- (id)initShortWithName:(NSString *)name;


- (id)valueForObject:(NSObject *)object;

- (void)setValueForObject:(NSObject *)object toValue:(NSObject *)value;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToProperty:(OBProperty *)property;

- (NSUInteger)hash;


@property (readonly, nonatomic) NSString *typeName;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) BOOL isPrimitive;



@end