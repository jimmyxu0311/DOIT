#import <UIKit/UIKit.h>

@interface BAEditableCell : UITableViewCell

@property(nonatomic, retain) UITextField *textField;
@property(nonatomic, assign) CGFloat textFieldWidth;

+ (void)stopEditing:(UITableView *)tableView;

@end
