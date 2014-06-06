//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBButtonTableViewCell.h"


@implementation OBButtonTableViewCell {

}


- (void)setBusy:(BOOL)busy {
	_busy = busy;
	if (self.activityIndicatorView) {
		if (busy) {
			[self.activityIndicatorView startAnimating];
		} else {
			[self.activityIndicatorView stopAnimating];
		}

		self.activityIndicatorView.hidden = !busy;
	}
}

@end