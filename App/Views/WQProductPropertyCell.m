//
//  WQProductPropertyCell.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductPropertyCell.h"

@interface WQProductPropertyCell ()

@property (nonatomic, weak) IBOutlet UIButton *addPropertyBtn;

@property (nonatomic, weak) IBOutlet UIView *lineView;
@end

@implementation WQProductPropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQProductPropertyCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];

        self.addPropertyBtn.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsCouldExtend:(BOOL)isCouldExtend {
    _isCouldExtend = isCouldExtend;
    if (isCouldExtend) {
        self.addPropertyBtn.hidden = NO;
        self.titleTextField.userInteractionEnabled = NO;
        self.infoTextField.userInteractionEnabled = NO;
        self.lineView.hidden = YES;
    }else {
        self.addPropertyBtn.hidden = YES;
        self.titleTextField.userInteractionEnabled = YES;
        self.infoTextField.userInteractionEnabled = YES;
        self.lineView.hidden = NO;
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.titleTextField.userInteractionEnabled = NO;
    
    if (indexPath.row==0) {
        self.infoTextField.placeholder = @"最多5个字";
    }else if (indexPath.row==1) {
        self.infoTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row==2) {
        self.infoTextField.placeholder = @"最多20个字";
    }else {
        if (!self.isCouldExtend) {
            self.titleTextField.userInteractionEnabled = YES;
        }
    }
}

-(void)setADic:(NSDictionary *)aDic {
    _aDic = aDic;
    NSString *name = [[aDic allKeys] firstObject];
    
    self.titleTextField.text = name;
        
    self.infoTextField.text = [aDic objectForKey:name];
}


-(IBAction)addPropertyBtnPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addProperty:)]) {
        [self.delegate addProperty:self];
    }
}
@end
