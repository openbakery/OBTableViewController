//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>


@interface OBTableViewSection : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger identifier;

@property(nonatomic, copy) NSString *headerTitle;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToSection:(OBTableViewSection *)section;

- (NSUInteger)hash;

@end