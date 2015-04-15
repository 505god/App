//
//  WQCustomerDetailEditCell.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailEditCell.h"
#import "WQStarView.h"
#import "WQSwitch.h"
#import "WQProductText.h"

#import "WQCustomerDetailEditVC.h"

@interface WQCustomerDetailEditCell ()

@property (nonatomic, strong) WQProductText *textField;

@property (nonatomic, strong) WQStarView *starView;

@property (nonatomic, strong) WQSwitch *switchBtn;

@end

@implementation WQCustomerDetailEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.textField = [[WQProductText alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textField];
        
        self.starView = [[WQStarView alloc]initWithFrame:(CGRect){0,0,140,30}];
        self.starView.enable = YES;
        self.starView.showNormal = YES;
        [self addSubview:self.starView];
        
        self.switchBtn = [[WQSwitch alloc]initWithFrame:CGRectZero];
        
        self.switchBtn.offImage = [UIImage imageNamed:@"cross.png"];
        self.switchBtn.onImage = [UIImage imageNamed:@"check.png"];
        self.switchBtn.onColor = COLOR(251, 0, 41, 1);
        self.switchBtn.isRounded = NO;
        [self.contentView addSubview:self.switchBtn];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.frame = (CGRect){10,(self.contentView.height-self.textLabel.height)/2,self.textLabel.width,self.textLabel.height};
    
    self.textField.frame = (CGRect){self.textLabel.right+10,(self.contentView.height-18)/2,self.contentView.width-30-self.textLabel.width,18};
    
    self.starView.frame = (CGRect){self.contentView.width-self.starView.width,(self.contentView.height-self.starView.height)/2,self.starView.width,self.starView.height};
    
    self.switchBtn.frame = (CGRect){self.contentView.width-70,5,60,30};
}

-(void)setIdxPath:(NSIndexPath *)idxPath {
    _idxPath = idxPath;
    
    self.textField.idxPath = idxPath;
    self.starView.idxPath = idxPath;
    self.switchBtn.idxPath = idxPath;
}

-(void)setDetailEditVC:(WQCustomerDetailEditVC *)detailEditVC {
    _detailEditVC = detailEditVC;
    
    self.textField.delegate = detailEditVC;
    [self.switchBtn addTarget:detailEditVC action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    self.starView.delegate = detailEditVC;
}

-(void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    
    self.textField.hidden = YES;
    self.starView.hidden = YES;
    self.switchBtn.hidden = YES;
    
    self.textLabel.text = [dictionary objectForKey:@"title"];
    
    NSInteger status = [[dictionary objectForKey:@"status"]integerValue];
    if (status == 0) {
        self.textField.hidden = NO;
        self.textField.text = [Utility checkString:[dictionary objectForKey:@"detail"]]?[dictionary objectForKey:@"detail"]:@"";
    }else if (status==1){
        self.starView.hidden = NO;
        self.starView.starNumber =[[dictionary objectForKey:@"detail"] integerValue];
    }else if ( status==2){
        self.switchBtn.hidden = NO;
        self.switchBtn.on = [[dictionary objectForKey:@"detail"] boolValue];
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.textField.text = @"";
}
@end
