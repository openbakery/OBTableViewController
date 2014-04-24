//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBPropertyBinding.h"

/**
* binds UIImage properties to the cell UIImageView, e.g. UIImage *image -> UIImageView *imageView
*/
@interface UIImageViewPropertyBinding : OBPropertyBinding

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName;

@end