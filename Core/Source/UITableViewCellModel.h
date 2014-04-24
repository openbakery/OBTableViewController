//
// ELO 
//
// Created by rene on 19.02.14.

//
// 
//


#import <Foundation/Foundation.h>
#import "OBTableViewCellModel.h"


@interface UITableViewCellModel : NSObject
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *detailText;
@property(nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, assign) NSInteger tag;


@end