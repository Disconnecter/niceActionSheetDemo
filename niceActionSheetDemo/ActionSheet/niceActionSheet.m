//
//  niceActionSheet.m
//  
//
//  Created by Zabolotnyy Sergey on 9/26/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "niceActionSheet.h"

#define BACKGROUND_IMAGE           @"action_sheet_background.png"
#define BUTTON_NORMAL              @"action_sheet_button_normal.png"
#define BUTTON_PRESSED             @"action_sheet_button_pressed.png"
#define CANCEL_BUTTON_NORMAL       @"cancel_button_normal.png"
#define CANCEL_BUTTON_PRESSED      @"cancel_button_pressed.png"
#define DESTRUCTIVE_BUTTON_NORMAL  @"destructive_button_normal.png"
#define DESTRUCTIVE_BUTTON_PRESSED @"destructive_button_pressed.png"
#define ANIMATION_DURATION 0.1  

typedef enum
{
    niceActionSheetCancelButton,
    niceActionSheetDestructiveButton,
    niceActionSheetNormalButton
} niceActionSheetButton;

@implementation niceActionSheet

@synthesize delegate;

#pragma mark - Initialization, dealocation

- (id)initWithTitle:(NSString *)title
           delegate:(id<niceActionSheetDelegate>)actionSheetDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super init];

    if (self)
    {
        delegate = actionSheetDelegate;
        self.frame = [[UIScreen mainScreen] bounds];
        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
        _backgroundImage.userInteractionEnabled = YES;
        [self addSubview:_backgroundImage];
        [_backgroundImage setFrame:CGRectMake(0, 460, 320, 480)];
        
        if (title != nil)
        {
            UILabel *actionSheetTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 300, 19)];
            actionSheetTitle.textAlignment = UITextAlignmentCenter;
            actionSheetTitle.text = title;
            actionSheetTitle.textColor = [UIColor whiteColor];
            actionSheetTitle.backgroundColor = [UIColor clearColor];
            [self addViewInActionSheet:actionSheetTitle];
            [actionSheetTitle release];
        }
        
        NSInteger lastButtonTag = 1;
        if (otherButtonTitles.count > 0)
        {
            for (NSInteger i = 0; i < otherButtonTitles.count; i++)
            {
                [self addActionSheetButton:niceActionSheetNormalButton
                                 withTitle:[otherButtonTitles objectAtIndex:i]
                                       tag:lastButtonTag++];
            }
        }

        if (destructiveButtonTitle != nil)
        {
            [self addActionSheetButton:niceActionSheetDestructiveButton
                             withTitle:destructiveButtonTitle
                                   tag:lastButtonTag++];
        }

        if (cancelButtonTitle != nil)
        {
            [self addActionSheetButton:niceActionSheetCancelButton
                             withTitle:cancelButtonTitle
                                   tag:lastButtonTag++];
        }
    }
    
    return self ;
}

- (void)dealloc
{
    [_backgroundImage release];
    
    [super dealloc];
}

#pragma mark - Manage view

- (void)showInView:(UIView*)view
{
    CGFloat yPoint = CGRectGetMinY(_backgroundImage.frame) - 10;
    [_backgroundImage setFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(_backgroundImage.frame), CGRectGetHeight(_backgroundImage.frame))];
    [view addSubview:self];
    [view bringSubviewToFront:self];

    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options: UIViewAnimationCurveLinear
                     animations:^
     {
         [_backgroundImage setFrame:CGRectMake(0, yPoint, CGRectGetWidth(_backgroundImage.frame), CGRectGetHeight(_backgroundImage.frame))];
         self.backgroundColor = [UIColor colorWithWhite:.0/255. alpha:0.8];
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void)hideActionSheet:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(actionSheetDidDismissWithButtonIndex:)] && delegate != nil)
    {
        [delegate actionSheetDidDismissWithButtonIndex:sender.tag];
    }
     self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options: UIViewAnimationCurveLinear
                     animations:^
     {
         [self setFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
     }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

#pragma mark - Private methods

- (void)addViewInActionSheet:(UIView*)view
{
    CGRect viewFrame = view.frame;
    viewFrame.origin.y = CGRectGetMaxY([[_backgroundImage.subviews lastObject] frame]) + 10;
    view.frame = viewFrame;
    
    _backgroundImage.frame = CGRectOffset(_backgroundImage.frame, 0, -(view.frame.size.height + 10));
    [_backgroundImage addSubview:view];
}

- (void)addActionSheetButton:(niceActionSheetButton)type withTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(24, 20, 274, 41);
    UIImage *imageForNormalState = nil;
    UIImage *imageForHighlightedState = nil;
    UIColor *titleColorForNormalState = [UIColor blackColor];
    UIColor *titleColorForHighlightedState = nil;
    
    switch (type)
    {
        case niceActionSheetNormalButton:
        {
            imageForNormalState   = [UIImage imageNamed:BUTTON_NORMAL];
            imageForHighlightedState = [UIImage imageNamed:BUTTON_PRESSED];
            
            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
         }
            break;
        
        case niceActionSheetCancelButton:
        {
            imageForNormalState   = [UIImage imageNamed:CANCEL_BUTTON_NORMAL];
            imageForHighlightedState = [UIImage imageNamed:CANCEL_BUTTON_PRESSED];
            
            titleColorForHighlightedState = [UIColor whiteColor];
            
            [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];

            [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
            break;
        
        case niceActionSheetDestructiveButton:
        {
            imageForNormalState   = [UIImage imageNamed:DESTRUCTIVE_BUTTON_NORMAL];
            imageForHighlightedState = [UIImage imageNamed:DESTRUCTIVE_BUTTON_PRESSED];
            
            titleColorForNormalState = [UIColor whiteColor];
        }
            break;
        
        default:
            break;
    }

    [button setBackgroundImage:imageForNormalState   forState:UIControlStateNormal];
    [button setBackgroundImage:imageForHighlightedState forState:UIControlStateHighlighted];
    
    [button setTitleColor:titleColorForNormalState   forState:UIControlStateNormal];
    [button setTitleColor:titleColorForHighlightedState forState:UIControlStateHighlighted];

    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(hideActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = tag;
    
    [self addViewInActionSheet:button];
}

@end
