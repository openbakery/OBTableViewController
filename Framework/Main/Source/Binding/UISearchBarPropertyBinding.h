//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBPropertyBinding.h>

/**
* binds NString properties to the cell UISearchBar text
*/
@interface UISearchBarPropertyBinding : OBPropertyBinding

- (id)initSourceName:(NSString *)string andDestinationName:(NSString *)name;

@end
