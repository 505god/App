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
    SafeRelease(_textFieldText);
    SafeRelease(_titleString);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - lifestyle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn setTitle:NSLocalizedString(@"Confirm", @"") forState:UIControlStateNormal];
    
    self.titleLab.text = self.titleString;
    
    if ([Utility checkString:self.textFieldText] && self.type==1) {
        self.text.text = self.textFieldText;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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

-(BOOL)validateChangeName {
    
    if (self.type==1) {
        BOOL res = ![self.text.text isEqualToString:self.textFieldText];
        
        return res;
    }
    return NO;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.text resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(NSNotification *)notification {
    self.isEditing = [self validateChangeName];
}

-(IBAction)confirmPressed:(id)sender {
    if ([Utility checkString:self.text.text]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissTextVC:)]) {
            [self.delegate dismissTextVC:self];
        }
    }else {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"WQTextVC", @"")];
    }
}
@end
