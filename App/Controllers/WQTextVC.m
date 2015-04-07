//
//  WQTextVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQTextVC.h"

@interface WQTextVC ()<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation WQTextVC

-(void)dealloc {
    SafeRelease(_text);
    SafeRelease(_btn);
    SafeRelease(_titleLab);
    SafeRelease(_delegate);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - lifestyle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn setTitle:NSLocalizedString(@"Confirm", @"") forState:UIControlStateNormal];
    
    if (self.type==0) {
        self.titleLab.text = NSLocalizedString(@"CreatClass", @"");
    }else if (self.type==1) {
        self.titleLab.text = NSLocalizedString(@"CreatColor", @"");
    }else if (self.type==2) {
        self.titleLab.text = NSLocalizedString(@"CreatSize", @"");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Keyboard notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view.frame;
    frame.origin.y -= 40;
    self.view.frame = frame;
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view.frame;
    frame.origin.y += 40;
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.text resignFirstResponder];
    return YES;
}

-(IBAction)confirmPressed:(id)sender {
    if ([Utility checkString:self.text.text]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissTextVC:)]) {
            [self.delegate dismissTextVC:self];
        }
    }else {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"WQTextVC", @"")];
    }
}
@end
