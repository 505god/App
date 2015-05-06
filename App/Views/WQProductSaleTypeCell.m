//
//  WQProductSaleTypeCell.m
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductSaleTypeCell.h"

#import "WQProductSaleVC.h"

#import "WQProductText.h"

@interface WQProductSaleTypeCell ()

@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation WQProductSaleTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = COLOR(213, 213, 213, 1);
        
        self.textField = [[WQProductText alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.font = [UIFont systemFontOfSize:15];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.textField];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.textField.idxPath = indexPath;
    
    if (indexPath.row==0 || indexPath.row==3) {
        self.textField.hidden = NO;
        self.detailTextLabel.hidden = YES;
    }else {
        self.textField.hidden = YES;
        self.detailTextLabel.hidden = NO;
    }
}

-(void)setProSaleVC:(WQProductSaleVC *)proSaleVC {
    _proSaleVC = proSaleVC;
    
    self.textField.delegate = proSaleVC;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textField.text = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    
    self.textLabel.frame = (CGRect){20,(self.height-self.textLabel.height)/2,self.textLabel.width,self.textLabel.height};
    
    self.detailTextLabel.frame = (CGRect){self.width-self.detailTextLabel.width-32,(self.height-self.detailTextLabel.height)/2,self.detailTextLabel.width,self.detailTextLabel.height};
    
    self.textField.frame = (CGRect){self.width-120-32,(self.height-20)/2,120,20};
    
    self.lineView.frame = (CGRect){20,self.height-1,self.width,2};
}
@end
