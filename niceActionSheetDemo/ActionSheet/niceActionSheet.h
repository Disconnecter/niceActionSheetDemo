//
//  niceActionSheet.h
//  
//
//  Created by Zabolotnyy Sergey on 9/26/12.
//  Copyright (c) 2012 . All rights reserved.
//


@protocol niceActionSheetDelegate;

@interface niceActionSheet : UIView
{
    UIImageView *_backgroundImage;
}

@property(assign, atomic) id<niceActionSheetDelegate>delegate;

- (id)initWithTitle:(NSString *)title
           delegate:(id<niceActionSheetDelegate>)actionSheetDelegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showInView:(UIView*)view;

@end

@protocol niceActionSheetDelegate <NSObject>

@optional
- (void)actionSheetDidDismissWithButtonIndex:(NSInteger)index;

@end