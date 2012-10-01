//
//  ViewController.m
//  niceActionSheetDemo
//
//  Created by Zabolotnyy Sergey on 10/1/12.
//  Copyright (c) 2012 Zabolotnyy Sergey. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (IBAction)showActionSheetPressed:(UIButton *)sender
{
    niceActionSheet *actionSheet = [[niceActionSheet alloc] initWithTitle:@"Hello" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destructive" otherButtonTitles:@[@"First", @"Second", @"Third"]];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheetDidDismissWithButtonIndex:(NSInteger)index
{
    NSLog(@"Pressed button with index %i", index);
}


@end
