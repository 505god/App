//
//  WQCodeVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCodeVC.h"

#import <SMS_SDK/SMS_SDK.h>

#import "BlockAlertView.h"
#import "WQInfoVC.h"

@interface WQCodeVC ()<UITextFieldDelegate,WQNavBarViewDelegate>{
    NSString* _phone;
    NSString* _areaCode;
    
    NSTimer* _timer1;
    NSTimer* _timer2;
}

@end

static int count = 0;

@implementation WQCodeVC

-(void)dealloc {
    SafeRelease(_telLabel);
    SafeRelease(_verifyCodeField.delegate);
    SafeRelease(_verifyCodeField);
    SafeRelease(_timeLabel);
    SafeRelease(_repeatSMSBtn);
    SafeRelease(_submitBtn);
}


-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode
{
    _phone=phone;
    _areaCode=areaCode;
}

-(void)submit {
    [self.view endEditing:YES];
    
    if(self.verifyCodeField.text.length!=4) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"verifycodeformaterror", @"")];
    }else{
        [SMS_SDK commitVerifyCode:self.verifyCodeField.text result:^(enum SMS_ResponseState state) {
            if (1==state) {
                //TODO:填写资料
                WQInfoVC *infoVC = [[WQInfoVC alloc]init];
                infoVC.phoneNumber = _phone;
                [self.navigationController pushViewController:infoVC animated:YES];
                SafeRelease(infoVC);
            }else if(0==state) {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"verifycodeerrormsg", @"")];
            }
        }];
    }
}


-(void)CannotGetSMS {
    [Utility checkAlert];
    
     NSString* str=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"cannotgetsmsmsg", nil) ,_phone];
    BlockAlertView *alert = [BlockAlertView alertWithTitle:NSLocalizedString(@"surephonenumber", nil) message:str];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
    }];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
        [SMS_SDK getVerifyCodeByPhoneNumber:_phone AndZone:_areaCode result:^(enum SMS_GetVerifyCodeResponseState state){
             if (1==state){
                 [self setTimer];
                 _timeLabel.text=[NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"timelablemsg", nil),60-count,NSLocalizedString(@"second", nil)];
                 [_repeatSMSBtn setHeight:YES];
             }else if(0==state) {
                 [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"codesenderrormsg", @"")];
             }else if (SMS_ResponseStateMaxVerifyCode==state) {
                 [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"maxcodemsg", @"")];
             }else if(SMS_ResponseStateGetVerifyCodeTooOften==state) {
                 [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"codetoooftenmsg", @"")];
             }
             
         }];
        
    }];
    [alert show];
    [[WQDataShare sharedService].alertArray addObject:alert];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"verifycode", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.isShowShadow = YES;
    self.navBarView.navDelegate = self;
    [self.view addSubview:self.navBarView];

    UILabel* label=[[UILabel alloc] init];
    label.frame=CGRectMake(15, self.navBarView.bottom+10, self.view.frame.size.width - 30, 21);
    label.text=[NSString stringWithFormat:NSLocalizedString(@"verifylabel", nil)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    self.telLabel=[[UILabel alloc] init];
    self.telLabel.frame=CGRectMake(15, label.bottom+10, self.view.frame.size.width - 30, 21);
    self.telLabel.textAlignment = NSTextAlignmentCenter;
    self.telLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.telLabel];
    self.telLabel.text= [NSString stringWithFormat:@"+%@ %@",_areaCode,_phone];
    
    self.verifyCodeField=[[UITextField alloc] init];
    self.verifyCodeField.frame=CGRectMake(15, self.telLabel.bottom+10, self.view.frame.size.width - 30, NavgationHeight);
    self.verifyCodeField.borderStyle=UITextBorderStyleNone;
    self.verifyCodeField.textAlignment=NSTextAlignmentCenter;
    self.verifyCodeField.placeholder=NSLocalizedString(@"verifycode", nil);
    self.verifyCodeField.font=[UIFont systemFontOfSize:16];
    self.verifyCodeField.keyboardType=UIKeyboardTypePhonePad;
    self.verifyCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.verifyCodeField.backgroundColor = [UIColor whiteColor];
    self.verifyCodeField.layer.cornerRadius = 4.0;
    self.verifyCodeField.layer.masksToBounds = YES;
    [self.view addSubview:self.verifyCodeField];
    
    self.timeLabel=[[UILabel alloc] init];
    self.timeLabel.frame=CGRectMake(15, self.verifyCodeField.bottom+10, self.view.frame.size.width - 30, 40);
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.text=NSLocalizedString(@"timelabel", nil);
    [self.view addSubview:self.timeLabel];
    
    self.repeatSMSBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    self.repeatSMSBtn.frame=CGRectMake(15, self.verifyCodeField.bottom+10, self.view.frame.size.width - 30, 40);
    [self.repeatSMSBtn setTitle:NSLocalizedString(@"repeatsms", nil) forState:UIControlStateNormal];
    [self.repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.repeatSMSBtn];
    
    
    self.submitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitBtn setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = COLOR(251, 0, 41, 1);
    self.submitBtn.frame=CGRectMake(15, self.repeatSMSBtn.bottom+10, self.view.frame.size.width - 30, 40);
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn  setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
    
    [self setTimer];
    
    SafeRelease(label);
}

-(void)setTimer {
    self.timeLabel.hidden = NO;
    self.repeatSMSBtn.hidden = YES;
    
    [_timer2 invalidate];
    [_timer1 invalidate];
    
    count = 0;
    
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:60
                                                    target:self
                                                  selector:@selector(showRepeatButton)
                                                  userInfo:nil
                                                   repeats:YES];
    
    NSTimer* timer2=[NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(updateTime)
                                                   userInfo:nil
                                                    repeats:YES];
    _timer1=timer;
    _timer2=timer2;
}

-(void)updateTime
{
    count++;
    if (count>=60)
    {
        [_timer2 invalidate];
        return;
    }
    self.timeLabel.text=[NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"timelablemsg", nil),60-count,NSLocalizedString(@"second", nil)];
}

-(void)showRepeatButton{
    self.timeLabel.hidden=YES;
    self.repeatSMSBtn.hidden=NO;
    
    [_timer1 invalidate];
    return;
}

@end
