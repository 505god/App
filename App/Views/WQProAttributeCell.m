//
//  WQProAttributeCell.m
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProAttributeCell.h"
#import "WQCellSelectedBackground.h"

#import "WQCreatProductVC.h"
#import "WQProductDetailVC.h"
#define TextTag 100
#define NextTextTag 1000

@interface WQProAttributeCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *titleLab2;//针对status＝2

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *lineView2;

@property (nonatomic, strong) UILabel *detailLab;

@end

@implementation WQProAttributeCell

-(void)dealloc {
    SafeRelease(_idxPath);
    SafeRelease(_dataDic);
    SafeRelease(_productVC);
    SafeRelease(_titleLab);
    SafeRelease(_titleLab2);
    SafeRelease(_textField.delegate);
    SafeRelease(_textField);
    SafeRelease(_textField2.delegate);
    SafeRelease(_textField2);
    SafeRelease(_lineView);
    SafeRelease(_lineView2);
    SafeRelease(_detailLab);
    SafeRelease(_switchBtn);
    SafeRelease(_delegate);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLab];
        
        self.titleLab2 = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab2.font = [UIFont systemFontOfSize:15];
        self.titleLab2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLab2];
        
        self.detailLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.detailLab.font = [UIFont systemFontOfSize:12];
        self.detailLab.textAlignment = NSTextAlignmentRight;
        self.detailLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.detailLab];
        
        self.textField = [[WQProductText alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.tag = TextTag;
        self.textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textField];
        
        self.textField2 = [[WQProductText alloc] initWithFrame:CGRectZero];
        self.textField2.borderStyle = UITextBorderStyleNone;
        self.textField2.font = [UIFont systemFontOfSize:16];
        self.textField2.tag = NextTextTag;
        self.textField2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textField2];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.lineView2 = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView2.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView2];
        
        
        self.switchBtn = [[WQSwitch alloc]initWithFrame:CGRectZero];
        [self.switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        self.switchBtn.offImage = [UIImage imageNamed:@"cross.png"];
        self.switchBtn.onImage = [UIImage imageNamed:@"check.png"];
        self.switchBtn.onColor = COLOR(251, 0, 41, 1);
        self.switchBtn.isRounded = NO;
        [self.contentView addSubview:self.switchBtn];
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    NSInteger status = [[self.dataDic objectForKey:@"status"]integerValue];
    
    if (status==3 || status==4) {
        self.titleLab.frame = (CGRect){8,10,120,20};
    }else {
        self.titleLab.frame = (CGRect){8,10,60,20};
    }
    
    self.textField.frame = (CGRect){self.titleLab.right+5,self.titleLab.top,self.contentView.width-self.titleLab.right-10,self.titleLab.height};
    self.lineView.frame = (CGRect){self.titleLab.right+5,self.textField.bottom+9,self.textField.width,2};
    
    self.titleLab2.frame = (CGRect){self.titleLab.left,NavgationHeight-4+10,self.titleLab.width,self.titleLab.height};
    self.textField2.frame = (CGRect){self.titleLab2.right+5,self.titleLab2.top,self.contentView.width-self.titleLab2.right-10,self.titleLab2.height};
    self.lineView2.frame = (CGRect){self.titleLab2.right+5,self.textField2.bottom+9,self.textField2.width,2};
    
    self.switchBtn.frame = (CGRect){self.contentView.width-70,5,60,30};
    
    self.detailLab.frame = (CGRect){self.titleLab.right+5,(self.contentView.height-self.titleLab.height)/2,self.contentView.width-self.titleLab.right-32,self.titleLab.height};
    
    [self.textLabel sizeToFit];
    self.textLabel.frame = (CGRect){(self.contentView.width-self.textLabel.width)/2,(self.contentView.height-self.textLabel.height)/2,self.textLabel.width,self.textLabel.height};
}

#pragma mark - private

-(WQProductText *)addText:(CGRect)frame {
    WQProductText *text = [[WQProductText alloc] initWithFrame:frame];
    text.borderStyle = UITextBorderStyleNone;
    text.font = [UIFont systemFontOfSize:16];
    text.backgroundColor = [UIColor clearColor];
    return text;
}

-(void)setProductVC:(WQCreatProductVC *)productVC {
    _productVC = productVC;
    
    self.textField.delegate = productVC;
    self.textField2.delegate = productVC;
}

-(void)setDetailVC:(WQProductDetailVC *)detailVC {
    _detailVC = detailVC;
    
    self.textField.delegate = detailVC;
    self.textField2.delegate = detailVC;
}

-(void)setIdxPath:(NSIndexPath *)idxPath {
    _idxPath = idxPath;
    
    self.textField.idxPath = idxPath;
    self.textField2.idxPath = idxPath;
}

/*
 status:
 
 0=名称
 1=价格和库存----没有图片
 2=有图片
 3=分类
 4=客户
 5=完成创建
 6=热卖
 7=优惠方式
 */
-(void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleLab.hidden = NO;
    self.titleLab2.hidden = YES;
    self.textField2.hidden = YES;
    self.lineView2.hidden = YES;
    self.detailLab.hidden = YES;
    self.textLabel.hidden = YES;
    [self.switchBtn setHidden:YES];
    self.textField.hidden = NO;
    self.lineView.hidden = NO;
    NSInteger status = [[dataDic objectForKey:@"status"]integerValue];
    if (status == 0) {///名称
        self.titleLab.text = [dataDic objectForKey:@"titleName"];
        
        self.textField.text = [dataDic objectForKey:@"name"];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }else if (status ==12){///货币
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.detailLab.hidden = NO;
        
        self.titleLab.text = [dataDic objectForKey:@"titleName"];
        self.detailLab.text = [dataDic objectForKey:@"coinType"];
    }else if (status ==1){///价格和库存
        self.titleLab2.hidden = NO;
        self.textField2.hidden = NO;
        self.lineView2.hidden = NO;
        
        self.titleLab.text = [dataDic objectForKey:@"titlePrice"];
        self.textField.text = [dataDic objectForKey:@"price"];
        self.textField.returnKeyType = UIReturnKeyNext;
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        self.titleLab2.text = [dataDic objectForKey:@"titleStock"];
        self.textField2.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"stock"]];
        self.textField2.returnKeyType = UIReturnKeyDone;
        self.textField2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else if (status ==3) {///商品分类
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.detailLab.hidden = NO;
        
        self.titleLab.text = [dataDic objectForKey:@"titleClass"];
        self.detailLab.text = [dataDic objectForKey:@"details"];
        
    }else if (status ==4) {///推荐客户
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.detailLab.hidden = NO;
        
        self.titleLab.text = [dataDic objectForKey:@"titleCustomer"];
        self.detailLab.text = [NSString stringWithFormat:NSLocalizedString(@"SelectedCustomer", @""),[[dataDic objectForKey:@"details"] integerValue]];
    }else if (status ==5) {///完成创建
        self.textLabel.hidden = NO;
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.titleLab.hidden = YES;
        
        self.textLabel.text = [dataDic objectForKey:@"titleFinish"];
    }else if (status ==6) {///热卖
        [self.switchBtn setHidden:NO];
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.switchBtn.tag = 100;
        self.titleLab.text = [dataDic objectForKey:@"titleHot"];
        self.switchBtn.on = [[dataDic objectForKey:@"isOn"] boolValue];
    }else if (status ==7) {///优惠方式
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.detailLab.hidden = NO;
        
        self.titleLab.text = [dataDic objectForKey:@"titleSale"];
        
        if ([[dataDic objectForKey:@"type"]integerValue]==0) {
            self.detailLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderSale", @""),[[dataDic objectForKey:@"details"] floatValue]];
        }else if([[dataDic objectForKey:@"type"]integerValue]==1){
            self.detailLab.text = [NSString stringWithFormat:@"%d%@",(NSInteger)([[dataDic objectForKey:@"details"]floatValue]),NSLocalizedString(@"proDiscount", @"")];
        }else {
            self.detailLab.text = NSLocalizedString(@"saleNone", @"");
        }
    }else if (status ==8) {//上架
        [self.switchBtn setHidden:NO];
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.switchBtn.tag = 1000;
        self.titleLab.text = [dataDic objectForKey:@"titleHot"];
        self.switchBtn.on = [[dataDic objectForKey:@"isOn"] boolValue];
    }else if (status ==9) {//上架
        self.textLabel.hidden = NO;
        self.textField.hidden = YES;
        self.lineView.hidden = YES;
        self.titleLab.hidden = YES;
        
        self.textLabel.text = [dataDic objectForKey:@"titleFinish"];
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.titleLab.text = nil;
    self.titleLab2.text = nil;
    self.detailLab.text = nil;
    self.textField.text = nil;
    self.textField2.text = nil;
    self.textField.returnKeyType = UIReturnKeyNext;
}

-(void)switchChanged:(WQSwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(proAttributeCell:changeSwitch:)]) {
        [self.delegate proAttributeCell:self changeSwitch:sender.on];
    }
}
@end
