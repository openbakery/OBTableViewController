//
//
// Created by rene on 19.02.14.

//
// 
//


#import <Foundation/Foundation.h>
#import "OBAbstractTableViewController.h"

/**
* Simple TableViewController that supports only one section
*/
@interface OBSimpleTableViewController : OBAbstractTableViewController



- (void)addModel:(NSObject *)model;
- (void)addModels:(NSArray *)models;


@end