//
//  OBInsertViewController.m
//  OBTableViewController
//
//  Created by Rene Pirringer on 28.07.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//


#import <OBTableViewController/OBTableViewSection.h>
#import "OBInsertViewController.h"

@interface OBInsertViewController ()

@end

@implementation OBInsertViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.sectionPicker.dataSource = self;
	self.sectionPicker.delegate = self;

	[self updateView];
}

- (void)updateView {
	self.insertButton.enabled = [self.nameTextField.text length] > 0;
}

- (IBAction)insertButtonPressed:(id)sender {

	if (self.completion) {
		NSInteger row = [self.sectionPicker selectedRowInComponent:0];
		self.completion(self.nameTextField.text, [self.sections objectAtIndex:row]);
	}

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.sections count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	OBTableViewSection *section = [self.sections objectAtIndex:row];
	return section.headerTitle;
}

- (IBAction)nameChanged:(id)sender {
	[self updateView];
}

@end
