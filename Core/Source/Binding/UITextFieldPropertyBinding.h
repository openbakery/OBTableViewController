//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBPropertyBinding.h>

/**
* binds NSString properties to the cell UITextField, e.g. NSString *value -> UILabel *valueTextField
*/
@interface UITextFieldPropertyBinding : OBPropertyBinding


- (id)initWithSourceName:(NSString *)sourceName placeholderName:(NSString *)placeholderName andDestinationName:(NSString *)destinationName;
- (id)initWithSourceName:(NSString *)string andDestinationName:(NSString *)name;


@end
