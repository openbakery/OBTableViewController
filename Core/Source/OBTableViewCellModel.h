//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBModelCellBinding;


/**
* cell class the defines a binding between cell and model, so not the global binding is taken.
*/
@interface OBTableViewCellModel : NSObject

@property (nonatomic, readonly) OBModelCellBinding *binding;

@end