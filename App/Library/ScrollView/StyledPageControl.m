//
//  PageControl.m
//  PageControlDemo
//
/**
 * Created by honcheng on 5/14/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com> http://twitter.com/honcheng
 * @copyright	2011	Muh Hon Cheng
 * 
 */

#import "StyledPageControl.h"


@implementation StyledPageControl

#define COLOR_GRAYISHBLUE [UIColor colorWithRed:128/255.0 green:130/255.0 blue:133/255.0 alpha:1]
#define COLOR_GRAY [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.strokeWidth = 3;
        self.gapWidth = 5;
        self.diameter = 14;
        self.pageControlStyle = PageControlStyleDefault;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        SafeRelease(tapGestureRecognizer);
    }
    return self;
}

- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2)
    {
        // move left
        if (self.currentPage>0)
        {
            self.currentPage -= 1;
        }
        
    }
    else
    {
        // move right
        if (self.currentPage<self.numberOfPages-1)
        {
            self.currentPage += 1;
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
    UIColor *kcoreNormalColor, *kcoreSelectedColor, *kstrokeNormalColor, *kstrokeSelectedColor;
    
    if (self.coreNormalColor) kcoreNormalColor = self.coreNormalColor;
    else kcoreNormalColor = COLOR_GRAYISHBLUE;
    
    if (self.coreSelectedColor) kcoreSelectedColor = self.coreSelectedColor;
    else
    {
        if (self.pageControlStyle==PageControlStyleStrokedCircle || self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            kcoreSelectedColor = COLOR_GRAYISHBLUE;
        }
        else
        {
            kcoreSelectedColor = COLOR_GRAY;
        }
    }
    
    if (self.strokeNormalColor) kstrokeNormalColor = self.strokeNormalColor;
    else 
    {
        if (self.pageControlStyle==PageControlStyleDefault && self.coreNormalColor)
        {
            kstrokeNormalColor = self.coreNormalColor;
        }
        else
        {
            kstrokeNormalColor = COLOR_GRAYISHBLUE;
        }
        
    }
    
    if (self.strokeSelectedColor) kstrokeSelectedColor = self.strokeSelectedColor;
    else
    {
        if (self.pageControlStyle==PageControlStyleStrokedCircle || self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            kstrokeSelectedColor = COLOR_GRAYISHBLUE;
        }
        else if (self.pageControlStyle==PageControlStyleDefault && self.coreSelectedColor)
        {
            kstrokeSelectedColor = self.coreSelectedColor;
        }
        else
        {
            kstrokeSelectedColor = COLOR_GRAY;
        }
    }
    
    // Drawing code
    if (self.hidesForSinglePage && self.numberOfPages==1)
	{
		return;
	}
	
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	
	int gap = self.gapWidth;
    float kdiameter = self.diameter - 2*self.strokeWidth;
    
    if (self.pageControlStyle==PageControlStyleThumb)
    {
        if (self.thumbImage && self.selectedThumbImage)
        {
            kdiameter = self.thumbImage.size.width;
        }
    }
	
	int total_width = self.numberOfPages*kdiameter + (self.numberOfPages-1)*gap;
	
	if (total_width>self.frame.size.width)
	{
		while (total_width>self.frame.size.width)
		{
			kdiameter -= 2;
			gap = kdiameter + 2;
			while (total_width>self.frame.size.width) 
			{
				gap -= 1;
				total_width = self.numberOfPages*kdiameter + (self.numberOfPages-1)*gap;
				
				if (gap==2)
				{
					total_width = self.numberOfPages*kdiameter + (self.numberOfPages-1)*gap;
                    break;
				}
			}
			
			if (kdiameter==2)
			{
				total_width = self.numberOfPages*kdiameter + (self.numberOfPages-1)*gap;
                break;
			}
		}
		
		
	}
	
	int i;
	for (i=0; i<self.numberOfPages; i++)
	{
		int x = (self.frame.size.width-total_width)/2 + i*(kdiameter+gap);

        if (self.pageControlStyle==PageControlStyleDefault)
        {
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [kcoreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeSelectedColor CGColor]);
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [kcoreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeNormalColor CGColor]);
            }
        }
        else if (self.pageControlStyle==PageControlStyleStrokedCircle)
        {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [kcoreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [kstrokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleWithPageNumber)
        {
            CGContextSetLineWidth(myContext, self.strokeWidth);
            if (i==self.currentPage)
            {
                int kcurrentPageDiameter = kdiameter*1.6;
                x = (self.frame.size.width-total_width)/2 + i*(kdiameter+gap) - (kcurrentPageDiameter-kdiameter)/2;
                CGContextSetFillColorWithColor(myContext, [kcoreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kcurrentPageDiameter)/2,kcurrentPageDiameter,kcurrentPageDiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kcurrentPageDiameter)/2,kcurrentPageDiameter,kcurrentPageDiameter));
            
                NSString *pageNumber = [NSString stringWithFormat:@"%i", i+1];
                CGContextSetFillColorWithColor(myContext, [[UIColor whiteColor] CGColor]);
                
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = NSTextAlignmentCenter;
                
                NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:kcurrentPageDiameter-2],
                                      NSParagraphStyleAttributeName:paragraph
                                      };
                
                [pageNumber drawInRect:CGRectMake(x,(self.frame.size.height-kcurrentPageDiameter)/2-1,kcurrentPageDiameter,kcurrentPageDiameter) withAttributes:dic];
            }
            else
            {
                CGContextSetStrokeColorWithColor(myContext, [kstrokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
            }
        }
        else if (self.pageControlStyle==PageControlStylePressed1 || self.pageControlStyle==PageControlStylePressed2)
        {
            if (self.pageControlStyle==PageControlStylePressed1)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2-1,kdiameter,kdiameter));
            }
            else if (self.pageControlStyle==PageControlStylePressed2)
            {
                CGContextSetFillColorWithColor(myContext, [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2+1,kdiameter,kdiameter));
            }
            
            
            if (i==self.currentPage)
            {
                CGContextSetFillColorWithColor(myContext, [kcoreSelectedColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeSelectedColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
            }
            else
            {
                CGContextSetFillColorWithColor(myContext, [kcoreNormalColor CGColor]);
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
                CGContextSetStrokeColorWithColor(myContext, [kstrokeNormalColor CGColor]);
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter));
            }
        }
        else if (self.pageControlStyle==PageControlStyleThumb)
        {
            if (self.thumbImage && self.selectedThumbImage)
            {
                if (i==self.currentPage)
                {
                    [self.selectedThumbImage drawInRect:CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter)];
                }
                else
                {
                    [self.thumbImage drawInRect:CGRectMake(x,(self.frame.size.height-kdiameter)/2,kdiameter,kdiameter)];
                }
            }
        }
	}
}


- (void)dealloc
{
    self.coreSelectedColor = nil;
    self.coreNormalColor = nil;
    self.strokeNormalColor = nil;
    self.strokeSelectedColor = nil;
    self.thumbImage = nil;
    self.selectedThumbImage = nil;
    
    [super dealloc];
}

- (PageControlStyle)pageControlStyle
{
    return self.pageControlStyle;
}

- (void)setPageControlStyle:(PageControlStyle)style
{
    self.pageControlStyle = style;
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(int)page
{
    self.currentPage = page;
    [self setNeedsDisplay];
}

- (int)currentPage
{
    return self.currentPage;
}

- (void)setNumberOfPages:(int)numOfPages
{
    self.numberOfPages = numOfPages;
    [self setNeedsDisplay];
}

- (int)numberOfPages
{
    return self.numberOfPages;
}


@end
