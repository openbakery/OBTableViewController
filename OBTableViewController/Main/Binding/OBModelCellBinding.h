//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OBModelCellBinding : NSObject

- (id)initWithModelClass:(Class)modelClass andCellClass:(Class)cellClass andPropertyBindings:(NSArray *)propertyBindings;

- (void)setValuesForCell:(UITableViewCell *)cell usingModel:(NSObject *)model;
@end