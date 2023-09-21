//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBProperty;



@interface OBPropertyBinding : NSObject <NSCopying>

- (id)initSourceName:(NSString *)sourceName sourceClass:(Class)sourceClass destinationName:(NSString *)destinationName destinationClass:(Class)destinationClass;


@property (nonatomic, strong) OBProperty *sourceProperty;
@property (nonatomic, strong) OBProperty *destinationProperty;


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject;


@end