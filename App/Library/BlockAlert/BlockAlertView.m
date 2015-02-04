//
//  BlockAlertView.m
//
//

#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

@implementation BlockAlertView

@synthesize view = _view;
@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static UIImage *background = nil;
static UIFont *titleFont = nil;
static UIFont *messageFont = nil;
static UIFont *buttonFont = nil;

#pragma mark - init

+ (void)initialize
{
    if (self == [BlockAlertView class])
    {
        background = [UIImage imageNamed:kAlertViewBackground];
        background = [[background stretchableImageWithLeftCapWidth:0 topCapHeight:kAlertViewBackgroundCapHeight] retain];
        
        titleFont = [UIFont systemFontOfSize:18];
        messageFont = [UIFont systemFontOfSize:20];
        buttonFont = [UIFont systemFontOfSize:18];
    }
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[BlockAlertView alloc] initWithTitle:title message:message] autorelease];
}

#pragma mark - NSObject

- (id)initWithTitle:(NSString *)title message:(NSString *)message 
{
    if ((self = [super init]))
    {
        UIWindow *parentView = [BlockBackground sharedInstance];
        CGRect frame = parentView.bounds;
        frame.origin.x = floorf((frame.size.width - background.size.width) * 0.5);
        frame.size.width = background.size.width;
        
        _view = [[UIView alloc] initWithFrame:frame];
        
        _blocks = [[NSMutableArray alloc] init];
        _height = kAlertViewBorder + 6;

        if (title.length>0)
        {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                            constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];

            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = [UIFont systemFontOfSize:18];
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kAlertViewTitleTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kAlertViewTitleShadowColor;
            labelView.shadowOffset = kAlertViewTitleShadowOffset;
            labelView.text = title;
            [_view addSubview:labelView];
            [labelView release];
            labelView = nil;
            
            _height += size.height + kAlertViewBorder;

            if (Platform>=7.0) {
                UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){10,_height,frame.size.width-kAlertViewBorder*2,0.5}];
                lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
                [_view addSubview:lineView];
                [lineView release];
                lineView = nil;
            }else {
                UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){10,_height,frame.size.width-kAlertViewBorder*2,1}];
                lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
                [_view addSubview:lineView];
                [lineView release];
                lineView = nil;
            }

            
            _height += 10;
        }
        
        if (message.length>0)
        {
            CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:20]
                              constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, frame.size.width-kAlertViewBorder*2, size.height)];
            labelView.font = [UIFont systemFontOfSize:20];
            labelView.numberOfLines = 0;
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.textColor = kAlertViewMessageTextColor;
            labelView.backgroundColor = [UIColor clearColor];
            labelView.textAlignment = NSTextAlignmentCenter;
            labelView.shadowColor = kAlertViewMessageShadowColor;
            labelView.shadowOffset = kAlertViewMessageShadowOffset;
            labelView.text = message;
            [_view addSubview:labelView];
            [labelView release];
            labelView = nil;
            
            _height += size.height + kAlertViewBorder;
        }
        
        _vignetteBackground = NO;
    }
    
    return self;
}

- (void)dealloc 
{
    [_backgroundImage release];
    _backgroundImage = nil;
    [_view release];
    _view = nil;
    [_blocks release];
    _blocks = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title color:(NSString*)color block:(void (^)())block 
{
    [_blocks addObject:[NSArray arrayWithObjects:
                        block ? [[block copy] autorelease] : [NSNull null],
                        title,
                        color,
                        nil]];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"confirm" block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block 
{
    [self addButtonWithTitle:title color:@"cancel" block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:title color:@"confirm" block:block];
}

- (void)show
{
    BOOL isSecondButton = NO;
    NSUInteger index = 0;

    if (_blocks.count>0) {
        if (Platform>=7.0) {
            UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){10,_height,260,0.5}];
            lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
            [_view addSubview:lineView];
            [lineView release];
            lineView = nil;
        }else {
            UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){10,_height,260,1}];
            lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
            [_view addSubview:lineView];
            [lineView release];
            lineView = nil;
        }

        if (_blocks.count>1) {
            if (Platform>=7.0) {
                UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){140,_height,0.5,kAlertButtonHeight+7}];
                lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
                [_view addSubview:lineView];
                [lineView release];
                lineView = nil;
            }else {
                UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){140,_height,1,kAlertButtonHeight+7}];
                lineView.backgroundColor = COLOR(49.0, 49.0, 49.0, 1);
                [_view addSubview:lineView];
                [lineView release];
                lineView = nil;
            }
        }
    }

    for (NSUInteger i = 0; i < _blocks.count; i++)
    {
        NSArray *block = [_blocks objectAtIndex:i];
        NSString *title = [block objectAtIndex:1];

        CGFloat maxHalfWidth = floorf((_view.bounds.size.width-kAlertViewBorder*3)*0.5);
        CGFloat width = _view.bounds.size.width-kAlertViewBorder*2;
        CGFloat xOffset = kAlertViewBorder;
        if (isSecondButton)
        {
            width = maxHalfWidth;
            xOffset = width + kAlertViewBorder * 2;
            isSecondButton = NO;
        }
        else if (i + 1 < _blocks.count)
        {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:NSLineBreakByClipping];
            
            if (size.width < maxHalfWidth - kAlertViewBorder)
            {
                NSArray *block2 = [_blocks objectAtIndex:i+1];
                NSString *title2 = [block2 objectAtIndex:1];
                size = [title2 sizeWithFont:[UIFont systemFontOfSize:18]
                                minFontSize:10 
                             actualFontSize:nil
                                   forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                              lineBreakMode:NSLineBreakByClipping];
                
                if (size.width < maxHalfWidth - kAlertViewBorder)
                {
                    isSecondButton = YES;  // For the next iteration
                    width = maxHalfWidth;
                }
            }
        }
        else if (_blocks.count  == 1)
        {
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:18]
                                  minFontSize:10 
                               actualFontSize:nil
                                     forWidth:_view.bounds.size.width-kAlertViewBorder*2 
                                lineBreakMode:NSLineBreakByClipping];

            size.width = MAX(size.width, 80);
            if (size.width + 2 * kAlertViewBorder < width)
            {
                width = size.width + 2 * kAlertViewBorder;
                xOffset = floorf((_view.bounds.size.width - width) * 0.5);
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height+5, width, kAlertButtonHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        if (Platform>=6.0) {
            button.titleLabel.minimumScaleFactor = 10;
        }
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        if (title.length>0) {
            [button setTitleColor:kAlertViewButtonTextColor forState:UIControlStateNormal];
            [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.accessibilityLabel = title;
        }

        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_view addSubview:button];
        
        if (!isSecondButton)
            _height += kAlertButtonHeight + kAlertViewBorder;
        
        index++;
    }

    if (_height < background.size.height)
    {
        CGFloat offset = background.size.height - _height;
        _height = background.size.height;
        CGRect frame;
        for (NSUInteger i = 0; i < _blocks.count; i++)
        {
            UIButton *btn = (UIButton *)[_view viewWithTag:i+1];
            frame = btn.frame;
            frame.origin.y += offset+5;
            btn.frame = frame;
        }
    }

    CGRect frame = _view.frame;
    frame.origin.y = - _height;
    frame.size.height = _height;
    _view.frame = frame;

    UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:_view.bounds];
    [modalBackground setImage:[[UIImage imageNamed:@"alert-window.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:35]];
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    modalBackground.layer.shadowPath = [UIBezierPath bezierPathWithRect:modalBackground.bounds].CGPath;
    modalBackground.layer.masksToBounds = NO;
    modalBackground.layer.shadowOffset = CGSizeMake(5, 5);
    modalBackground.layer.shadowRadius = 5;
    modalBackground.layer.shadowOpacity = 0.5;
    modalBackground.alpha = 0.85;
    
    [_view insertSubview:modalBackground atIndex:0];
    [modalBackground release];
    modalBackground = nil;

    if (_backgroundImage)
    {
        [BlockBackground sharedInstance].backgroundImage = _backgroundImage;
        [_backgroundImage release];
        _backgroundImage = nil;
    }
    [BlockBackground sharedInstance].vignetteBackground = _vignetteBackground;
    [[BlockBackground sharedInstance] addToMainWindow:_view];

    __block CGPoint center = _view.center;
    center.y = floorf([BlockBackground sharedInstance].bounds.size.height * 0.5) + kAlertViewBounce;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [BlockBackground sharedInstance].alpha = 1.0f;
                         _view.center = center;
                     } 
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              _view.center = center;
                                          } 
                                          completion:nil];
                     }];
    
    [self retain];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
    {
        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             CGPoint center = _view.center;
                             center.y += 20;
                             _view.center = center;
                         } 
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                                   delay:0.0 
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  CGRect frame = _view.frame;
                                                  frame.origin.y = -frame.size.height;
                                                  _view.frame = frame;
                                              }
                                              completion:^(BOOL finished) {
                                                  [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                                  [[BlockBackground sharedInstance] removeView:_view];
                                                  [_view release]; _view = nil;
                                                  [self autorelease];
                                              }];
                         }];
    }
    else
    {
        [[BlockBackground sharedInstance] removeView:_view];
        [_view release]; _view = nil;
        [self autorelease];
    }
}

- (void)performDismissal
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         CGPoint center = _view.center;
                         center.y += 20;
                         _view.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = _view.frame;
                                              frame.origin.y = -frame.size.height;
                                              _view.frame = frame;
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                                              [[BlockBackground sharedInstance] removeView:_view];
                                              [_view release]; _view = nil;
                                              [self autorelease];
                                          }];
                     }];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    UIButton *btn = (UIButton *)sender;
    NSInteger buttonIndex = btn.tag - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end
