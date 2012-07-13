#import "BAEditableCell.h"

#define kTextFieldDefaultWidth 200

@implementation BAEditableCell

@synthesize textField, textFieldWidth;

- (void)dealloc {
	self.textField = nil;
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
		self.textField.autoresizingMask = self.detailTextLabel.autoresizingMask;
		self.textField.font = [UIFont systemFontOfSize:17];
		self.textField.textColor = self.detailTextLabel.textColor;
		[self.contentView addSubview:self.textField];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	const CGFloat width = self.contentView.bounds.size.width;
	const CGFloat height = self.contentView.bounds.size.height;
	const CGFloat textWidth = self.textFieldWidth > 0 ? self.textFieldWidth : kTextFieldDefaultWidth;
	const CGFloat textHeight = self.textLabel.bounds.size.height;
	const CGFloat spacing = self.textLabel.frame.origin.x;
	self.textField.frame = CGRectMake(width - spacing - textWidth, (height - textHeight) / 2, textWidth, textHeight);
}

+ (void)stopEditing:(UITableView *)tableView {
	for (UITableViewCell *cell in [tableView visibleCells]) {
		if ([cell isKindOfClass:[BAEditableCell class]]) {
			BAEditableCell *editableCell = (BAEditableCell *)cell;
			[editableCell.textField resignFirstResponder];
		}
	}
}

@end
