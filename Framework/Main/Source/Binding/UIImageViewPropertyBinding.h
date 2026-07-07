//
//
// Created by Rene Pirringer.
//
//
//

#import "OBPropertyBinding.h"
#import <Foundation/Foundation.h>

/**
 * binds UIImage properties to the cell UIImageView, e.g. UIImage *image ->
 * UIImageView *imageView
 */
@interface UIImageViewPropertyBinding : OBPropertyBinding

- (id)initWithSourceName:(NSString *)sourceName
      andDestinationName:(NSString *)destinationName;

@end
