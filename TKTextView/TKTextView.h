#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "TKTextStorage.h"

@interface TKTextView : UIView <UITextInput, UIGestureRecognizerDelegate> {
    NSString *_text;
    TKTextStorage *_textStorage;
    UIEdgeInsets _inset;
    
	CTFrameRef _frame;
    
    UITapGestureRecognizer *_tapGesture;
    
	UITextRange *_markedTextRange;
	UITextRange *_selectedTextRange;
	UITextPosition *_beginningOfDocument;
	UITextPosition *_endOfDocument;
	NSDictionary *_markedTextStyle;

	id<UITextInputDelegate> _inputDelegate;
	NSObject <UITextInputTokenizer> *_tokenizer;
}

- (id)initWithText:(NSString *)text showLinks:(BOOL)showLinks;
- (void)tap:(UITapGestureRecognizer *)tap;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGesture;

@property (atomic, readonly) TKTextStorage *textStorage;
@property (nonatomic, retain) NSString *text;
@property (nonatomic) UIEdgeInsets inset;
@property (nonatomic, assign) BOOL showLinks;

@property (nonatomic, readonly) UITextRange *markedTextRange;
@property (readwrite, copy) UITextRange *selectedTextRange;

@property(nonatomic, readonly) UITextPosition *beginningOfDocument;
@property(nonatomic, readonly) UITextPosition *endOfDocument;
@property (nonatomic, copy) NSDictionary *markedTextStyle;

@property (nonatomic, assign) id<UITextInputDelegate> inputDelegate;
@property (nonatomic, readonly) id <UITextInputTokenizer> tokenizer;

@end
