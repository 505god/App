//
//  WQNewCustomerVC.m
//  App
//
//  Created by 邱成西 on 15/4/26.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQNewCustomerVC.h"
#import "WQInputText.h"
#import "UIView+XD.h"

#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>

#import "UICustomerBtn.h"

@interface WQNewCustomerVC ()<WQNavBarViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userText;
@property (nonatomic, strong) UITextField *remarkText;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSMutableArray *areaArray;

@property (nonatomic, strong) UICustomerBtn *codeBtn;
@end

@implementation WQNewCustomerVC

-(void)dealloc {

}
-(NSString *)setTheLocalAreaCode {
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    
    return defaultCode;
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerNew", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    
    self.areaArray= [NSMutableArray array];
    //获取支持的地区列表
    [SMS_SDK getZone:^(enum SMS_ResponseState state, NSArray *array){
        if (1==state){
            //区号数据
            self.areaArray=[NSMutableArray arrayWithArray:array];
        }
    }];
    
    
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    WQInputText *inputText = [[WQInputText alloc] init];
    CGFloat userY = 100;
    
    //帐号
    self.userText = [inputText setupWithIcon:@"login_name" textY:userY centerX:centerX point:NSLocalizedString(@"CustomerPhone", @"")];
    self.userText.delegate = self;
    self.userText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.userText];
    
    //备注
    userY = self.userText.bottom + 5;
    self.remarkText = [inputText setupWithIcon:@"login_name" textY:userY centerX:centerX point:nil];
    self.remarkText.delegate = self;
    self.remarkText.keyboardType = UIKeyboardTypeDefault;
    self.remarkText.placeholder = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"CustomerRemark", @""),NSLocalizedString(@"ShopNameLimit", @"")] ;
    [self.remarkText setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.remarkText];

    self.codeBtn = [UICustomerBtn buttonWithType:UIButtonTypeCustom];
    self.codeBtn.width = self.userText.width;
    self.codeBtn.height = 40;
    self.codeBtn.x = self.userText.left;
    self.codeBtn.y = self.remarkText.bottom + 10;
    [self.codeBtn setBackgroundColor:COLOR(244, 242, 242, 1)];
    [self.codeBtn setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
    [self.codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.codeBtn.hidden = YES;
    [self.view addSubview:self.codeBtn];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.width = self.userText.width;
    self.sureBtn.height = 40;
    self.sureBtn.x = self.userText.left;
    self.sureBtn.y = self.remarkText.bottom + 10;
    [self.sureBtn setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = COLOR(251, 0, 41, 1);
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
    [self.sureBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)submitBtnClick {
    [self.view endEditing:YES];
//    
//    int compareResult = 0;
//    for (int i=0; i<self.areaArray.count; i++) {
//        NSDictionary* dict1=[self.areaArray objectAtIndex:i];
//        NSString* code1=[dict1 valueForKey:@"zone"];
//        if ([code1 isEqualToString:[self setTheLocalAreaCode]]) {
//            compareResult=1;
//            NSString* rule1=[dict1 valueForKey:@"rule"];
//            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
//            BOOL isMatch=[pred evaluateWithObject:self.userText.text];
//            if (!isMatch){
//                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"errorphonenumber", @"")];
//                return;
//            }
//            break;
//        }
//    }
//    
//    if (compareResult==0) {
//        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"countrychoose", @"")];
//        return;
//    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/user/addCustomer" parameters:@{@"userPhone":self.userText.text,@"remark":self.remarkText.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *dic = [jsonData objectForKey:@"returnObj"];
                NSString *code = [dic objectForKey:@"storeValidate"];
                [self.codeBtn setTitle:code forState:UIControlStateNormal];
                self.codeBtn.hidden = NO;
                CGRect frame = self.sureBtn.frame;
                frame.origin.y = self.codeBtn.bottom + 10;
                self.sureBtn.frame = frame;
                
                WQCustomerObj *customerObj = [[WQCustomerObj alloc]init];
                [customerObj mts_setValuesForKeysWithDictionary:dic];
                if (self.delegate && [self.delegate respondsToSelector:@selector(addNewCustomer:)]) {
                    [self.delegate addNewCustomer:customerObj];
                }
                
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)codeBtnClick{
    [self.view endEditing:YES];
    
    [self.codeBtn becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.codeBtn.frame inView:self.codeBtn.superview];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.userText]) {
        [self.userText resignFirstResponder];
        [self.remarkText becomeFirstResponder];
    }else {
        [self.remarkText resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidChange:(NSNotification *)notification {
    UITextField *text = (UITextField *)notification.object;
    
    if ([text isEqual:self.remarkText]) {
        NSInteger kMaxLength = 10;
        
        NSString *toBeString = text.text;
        
        NSString *lang = text.textInputMode.primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入
            UITextRange *selectedRange = [text markedTextRange];
            UITextPosition *position = [text positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (toBeString.length > kMaxLength) {
                    text.text = [toBeString substringToIndex:kMaxLength];
                }
            }
        }else {
            if (toBeString.length > kMaxLength) {
                text.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
}

@end
