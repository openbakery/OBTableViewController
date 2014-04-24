//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBPropertyBinding.h"

/**
* binds NSString properties to the cell UITextField, e.g. NSString *value -> UILabel *valueTextField
*/
@interface UITextFieldPropertyBinding : OBPropertyBinding

- (id)initSourceName:(NSString *)string andDestinationName:(NSString *)name;


@end