//
//  OBTableViewCell.m
//  OBTableViewController
//
//  Created by René Pirringer on 16.04.20.
//  Copyright © 2020 Rene Pirringer. All rights reserved.
//

#import "OBTableViewCell.h"
#import "OBCellModel.h"

@implementation OBTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)setModel:(NSObject *)model {
	if ([model isKindOfClass:[OBCellModel class]]) {
		OBCellModel *cellModel = (OBCellModel *) model;
    self.textLabel.text = cellModel.text;
	}
}

@end
