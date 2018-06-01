/*************************************************************************
 *
 * SHOOT&PROVE CONFIDENTIAL
 * __________________
 *
 *  [2016]-[2018] Shoot&Prove SA/NV
 *  www.shootandprove.com
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property
 * of Shoot&Prove SA/NV. The intellectual and technical concepts contained
 * herein are proprietary to Shoot&Prove SA/NV.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Shoot&Prove SA/NV.
 */

#import "IndexesView.h"
#import "EnumHelper.h"
#import "DateTimeHelper.h"
#import "UIColor+HexString.h"
#import "UIView+FirstResponder.h"
#import "AbstractIndex.h"
#import "DefaultIndex.h"
#import "ListIndex.h"
#import "Item.h"
#import "UIStyle.h"

#define labelHeight 21.0f
#define singleTextHeight 30.0f
#define buttonSize 36.0f
#define multiTextHeight 90.0f

#define gap 8.0f

@interface IndexesView()
{
	BOOL _readOnly;
    UIStyle *_style;
}
@end

@implementation IndexesView
@synthesize preferredHeight = _preferredHeight, hasValue = _hasValue, updated = _updated, indexes = _indexes;

#pragma public setters/getters
- (void)setIndexes:(NSOrderedSet *)indexes readOnly:(BOOL)readOnly style:(UIStyle *)style  {
	_indexes = indexes;
	_preferredHeight = 0;
	_hasValue = NO;
	_updated = NO;
	_readOnly = readOnly;
    _style = style;
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:[UIColor clearColor]];
	CGFloat fieldWidth = self.frame.size.width - (gap * 2);
	fieldWidth = fieldWidth < 0 ? 0:fieldWidth;
	CGFloat posY = gap;
	UIView *previousView;
	NSInteger tag = 0;
	for(AbstractIndex *index in _indexes) {
		SPIndexType indexType = [EnumHelper indexTypeFromDescription:index.type];
		if(indexType == SPIndexTypeMultiText) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gap, posY, fieldWidth, labelHeight)];
			[label setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
            [label setTextColor:[UIColor colorWithHexString:_style.promptColor andAlpha:1.0f]];
			[label setTextAlignment:NSTextAlignmentLeft];
			[label setText:[NSString stringWithFormat:@"%@%@:", index.key, [index.mandatory boolValue] ? @" *":@""]];
			[self addSubview:label];
			[label setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self setLeftConstraintForView:label];
			if(previousView) {
				[self setTopConstraintForView:label relatedToView:previousView top:gap];
			} else {
				[self setTopConstraintForView:label top:gap];
			}
			[self setRightConstraintForView:label right:gap];
			[self setHeightConstraintForView:label height:labelHeight];
			UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(gap, posY + labelHeight, fieldWidth, multiTextHeight)];
			[textView setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
			[textView setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
			[textView.layer setBorderColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f].CGColor];
			[[textView layer] setBorderWidth:1.0f];
			[[textView layer] setCornerRadius:5.0f];
			[[textView layer] setSublayerTransform:CATransform3DMakeTranslation(5, 0, 0)];
			[textView setText:[index.value length] > 0 ? index.value:nil];
			[textView setTag:tag];
			
			if(index == [_indexes lastObject]) {
				[textView setReturnKeyType:UIReturnKeyDone];
			} else {
				[textView setReturnKeyType:UIReturnKeyNext];
			}
			[textView setDelegate:self];
			[textView setEditable:!_readOnly];
			
			[self addSubview:textView];
			
			[textView setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self setLeftConstraintForView:textView];
			[self setTopConstraintForView:textView relatedToView:label top:0];
			[self setRightConstraintForView:textView right:gap];
			[self setHeightConstraintForView:textView height:multiTextHeight];
			
			posY += labelHeight + multiTextHeight + gap;
			previousView = textView;
			
		} else if(indexType == SPIndexTypeNumber || indexType == SPIndexTypeSingleText) {
			
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(gap, posY, fieldWidth, singleTextHeight)];
			[textField setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
			[textField setTextColor:[UIColor colorWithHexString:colorDarkGrey andAlpha:1.0f]];
			[textField.layer setBorderColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f].CGColor];
			[textField.layer setBorderWidth:1.0f];
			[textField.layer setCornerRadius:5.0f];
			[textField.layer setSublayerTransform:CATransform3DMakeTranslation(5, 0, 0)];
			[textField setPlaceholder:index.desc];
			[textField setTag:tag];
			if(index == [_indexes lastObject]) {
				[textField setReturnKeyType:UIReturnKeyDone];
			} else {
				[textField setReturnKeyType:UIReturnKeyNext];
			}
			[textField setDelegate:self];
			[textField setEnabled:!_readOnly];
			[self addSubview:textField];
			[textField setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self setLeftConstraintForView:textField];
			if(previousView) {
				[self setTopConstraintForView:textField relatedToView:previousView top:gap];
			} else {
				[self setTopConstraintForView:textField top:gap];
			}
			[self setRightConstraintForView:textField right:gap];
			[self setHeightConstraintForView:textField height:singleTextHeight];
			[textField setPlaceholder:[NSString stringWithFormat:@"%@%@", index.key, [index.mandatory boolValue] ? @" *":@""]];
			[textField setText:[index.value length] > 0 ? index.value:nil];
			posY += singleTextHeight + gap;
			previousView = textField;
		} else if(indexType == SPIndexTypeDate || indexType == SPIndexTypeList) {
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(gap, posY, fieldWidth - (_readOnly ? 0:buttonSize), singleTextHeight)];
			[textField setBackgroundColor:[UIColor colorWithHexString:colorWhite andAlpha:0.9f]];
			[textField setFont:[UIFont fontWithName:normalFontName size:normalFontSize]];
			[textField setTextColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f]];
			[textField.layer setBorderColor:[UIColor colorWithHexString:colorLightGrey andAlpha:1.0f].CGColor];
			[textField.layer setBorderWidth:1.0f];
			[textField.layer setCornerRadius:5.0f];
			[textField.layer setSublayerTransform:CATransform3DMakeTranslation(5, 0, 0)];
			[textField setTag:tag];
			[textField setEnabled:NO];
			[textField setDelegate:self];
			[self addSubview:textField];
			[textField setPlaceholder:[NSString stringWithFormat:@"%@%@", index.key, [index.mandatory boolValue] ? @" *":@""]];
			if(indexType == SPIndexTypeDate) {
				if(index.value) {
					NSDate *date = [DateTimeHelper dateFromJson:index.value];
					NSDateFormatter *df = [[NSDateFormatter alloc] init];
					[df setDateStyle:NSDateFormatterShortStyle];
					[df setTimeStyle:NSDateFormatterNoStyle];
					[textField setText:[df stringFromDate:date]];
				} else {
					[textField setText:nil];
				}
			} else {
				[textField setText:[index.value length] > 0 ? index.value:nil];
			}
			UIButton *button;
			if(!_readOnly) {
				button = [[UIButton alloc] initWithFrame:CGRectMake(gap + fieldWidth - buttonSize, posY - ((buttonSize - singleTextHeight) / 2), buttonSize, buttonSize)];
				[button setTag:tag];
				if(indexType == SPIndexTypeDate) {
					[button setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
					[button addTarget:self action:@selector(dateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
				} else if(indexType == SPIndexTypeList) {
					[button setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
					[button addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
				}
				[self addSubview:button];
				[button setTranslatesAutoresizingMaskIntoConstraints:NO];
				if(previousView) {
					[self setTopConstraintForView:button relatedToView:previousView top:gap - ((buttonSize - singleTextHeight) / 2)];
				} else {
					[self setTopConstraintForView:button top:gap - ((buttonSize - singleTextHeight) / 2)];
				}
				[self setRightConstraintForView:button right:gap];
				[self setHeightConstraintForView:button height:buttonSize];
				[self setWidthConstraintForView:button width:buttonSize];
			}
			[textField setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self setLeftConstraintForView:textField];
			if(previousView) {
				[self setTopConstraintForView:textField relatedToView:previousView top:gap];
			} else {
				[self setTopConstraintForView:textField top:gap];
			}
			if(!_readOnly) {
				[self setRightConstraintForView:textField relatedToView:button right:gap/2];
			} else {
				[self setRightConstraintForView:textField right:gap];
			}
			[self setHeightConstraintForView:textField height:singleTextHeight];
			posY += singleTextHeight + gap;
			previousView = textField;
		}
		_preferredHeight = posY;
		if([index.value length]>0) {
			_hasValue = YES;
		}
		tag ++;
	}
}

- (CGFloat)preferredHeight {
	if(!_indexes)
		return 0;
	else
		return _preferredHeight;
}

#pragma view constraints
- (void)setLeftConstraintForView:(UIView *)view {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeLeading
													 relatedBy:NSLayoutRelationEqual
														toItem:self
													 attribute:NSLayoutAttributeLeading
													multiplier:1.0
													  constant:gap]];
}

- (void)setTopConstraintForView:(UIView *)view top:(CGFloat)top {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeTop
													 relatedBy:NSLayoutRelationEqual
														toItem:self
													 attribute:NSLayoutAttributeTop
													multiplier:1.0
													  constant:top]];
}

- (void)setTopConstraintForView:(UIView *)view relatedToView:(UIView *)toView top:(CGFloat)top {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeTop
													 relatedBy:NSLayoutRelationEqual
														toItem:toView
													 attribute:NSLayoutAttributeBottom
													multiplier:1.0
													  constant:top]];
}

- (void)setRightConstraintForView:(UIView *)view right:(CGFloat)right {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self
													 attribute:NSLayoutAttributeTrailing
													 relatedBy:NSLayoutRelationEqual
														toItem:view
													 attribute:NSLayoutAttributeTrailing
													multiplier:1.0
													  constant:right]];
}

- (void)setRightConstraintForView:(UIView *)view relatedToView:(UIView *)toView right:(CGFloat)right {
	[self addConstraint:[NSLayoutConstraint constraintWithItem:toView
													 attribute:NSLayoutAttributeLeading
													 relatedBy:NSLayoutRelationEqual
														toItem:view
													 attribute:NSLayoutAttributeTrailing
													multiplier:1.0
													  constant:right]];
}

- (void)setHeightConstraintForView:(UIView *)view height:(CGFloat)height {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeHeight
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0
													  constant:height]];
}

- (void)setWidthConstraintForView:(UIView *)view width:(CGFloat)width {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeWidth
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0
													  constant:width]];
}

#pragma - public methods
- (void)setFocus {
	if(!_readOnly) {
		[self focusOnFieldWithTag:0];
	}
}

#pragma - helper to focus on field with specified tag
- (BOOL)focusOnFieldWithTag:(NSInteger)tag {
	for(UIView *subView in self.subviews) {
		if([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
			if(subView.tag == tag) {
				return [subView becomeFirstResponder];
			}
		}
	}
	return NO;
}

#pragma - helper to get the index, text field or text view from specified tag
- (AbstractIndex *)indexForTag:(NSInteger)tag {
	if([_indexes count] == 0)
		return nil;
	AbstractIndex *index;
	if(tag<0)
		index = [_indexes objectAtIndex:0];
	else if(tag >= [_indexes count])
		index = [_indexes lastObject];
	else
		index = [_indexes objectAtIndex:tag];
	return index;
}

- (UITextField *)textFieldForTag:(NSInteger)tag {
	UITextField *textField;
	for(UIView *subView in self.subviews) {
		if([subView isKindOfClass:[UITextField class]]) {
			if(subView.tag == tag) {
				textField = (UITextField *)subView;
				break;
			}
		}
	}
	return textField;
}

- (UITextView *)textViewForTag:(NSInteger)tag {
	UITextView *textView;
	for(UIView *subView in self.subviews) {
		if([subView isKindOfClass:[UITextView class]]) {
			if(subView.tag == tag) {
				textView = (UITextView *)subView;
				break;
			}
		}
	}
	return textView;
}

#pragma - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(![self focusOnFieldWithTag:textField.tag+1]) {
		return [[self findFirstResponder] resignFirstResponder];
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	textField.text = [textField.text stringByTrimmingCharactersInSet:
					  [NSCharacterSet whitespaceCharacterSet]];
	_updated = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	textField.text = [textField.text stringByTrimmingCharactersInSet:
					  [NSCharacterSet whitespaceCharacterSet]];
	AbstractIndex *index = [self indexForTag:textField.tag];
	if(index) {
		index.value = textField.text;
	}
}

#pragma text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if([text isEqualToString:@"\n"]) {
		if(![self focusOnFieldWithTag:textView.tag+1]) {
			[[self findFirstResponder] resignFirstResponder];
		}
		return NO;
	}
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_updated = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	AbstractIndex *index = [self indexForTag:textView.tag];
	if(index) {
		index.value = textView.text;
	}
}

#pragma date button click method
- (void)dateButtonClick:(id)sender {
	[[self findFirstResponder] resignFirstResponder];
	UIButton *button = (UIButton *)sender;
	NSInteger tag = button.tag;
	AbstractIndex *index = [self indexForTag:tag];
	NSDate *date;
	if(index) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateStyle:NSDateFormatterShortStyle];
		[df setTimeStyle:NSDateFormatterNoStyle];
		date = [df dateFromString:index.value];
	} else {
		date = [NSDate date];
	}
	[self resignFirstResponder];
    [[[DateTimePicker alloc] initWithCurrentDate:date displayDate:YES displayTime:NO maxDate:nil minDate:nil style:_style delegate:self tag:tag] show];
}

#pragma list button click method
- (void)listButtonClick:(id)sender {
	[[self findFirstResponder] resignFirstResponder];
	UIButton *button = (UIButton *)sender;
	NSInteger tag = button.tag;
	ListIndex *index = (ListIndex *) [self indexForTag:tag];
	if([index.list count]>0) {
		NSArray *list = [[NSArray alloc] initWithArray:[index.list array]];
		[self resignFirstResponder];
		[[[ItemPicker alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TASK_DETAILS_SELECT", nil), index.key] items:list delegate:self tag:tag] show];
	}
}

#pragma date/time picker delegate
- (void)didDateTimePickerReturnDate:(NSDate *)date tag:(NSInteger)tag {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];
	UITextField *textField = [self textFieldForTag:tag];
	if(textField) {
		[textField setText:[df stringFromDate:date]];
	}
	DefaultIndex *index = (DefaultIndex *)[self indexForTag:tag];
	if(index) {
		index.value = [df stringFromDate:date];
	}
	_updated = YES;
	[self focusOnFieldWithTag:tag+1];
}

#pragma value picker delegate
- (void)didItemPickerReturnItem:(Item *)item tag:(NSInteger)tag {
	UITextField *textField = [self textFieldForTag:tag];
	if(textField) {
		[textField setText:item.value];
	}
	ListIndex *index = (ListIndex *) [self indexForTag:tag];
	if(index) {
		index.value = item.value;
	}
	_updated = YES;
	[self focusOnFieldWithTag:tag+1];
}
@end
