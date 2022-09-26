//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>


@interface OBTableViewSection : NSObject <NSCopying>

/**
* initialise a section
*/
- (id)init;

/**
* initialise a section with a header that has the given title
*/
- (id)initWithHeaderTitle:(NSString *)title;



/**
* title of the section that is shown in the section header
*/
@property(nonatomic, copy) NSString *headerTitle;

/**
* property that specify if this section is editable. If is set to YES then all cells in this section are editable
*/
@property(nonatomic) BOOL editable;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToSection:(OBTableViewSection *)section;

- (NSUInteger)hash;

@end