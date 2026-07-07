//
//
// Created by Rene Pirringer.
//
//
//

#import "OBPropertyBinding.h"
#import <Foundation/Foundation.h>

/**
 * binds NString properties to the cell UISearchBar text
 */
@interface UISearchBarPropertyBinding : OBPropertyBinding

- (id)initSourceName:(NSString *)string andDestinationName:(NSString *)name;

@end
