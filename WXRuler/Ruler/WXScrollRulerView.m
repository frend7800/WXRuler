//
//  WXScrollRulerView.m
//
//  Created by wxj on 2017/8/24.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import "WXScrollRulerView.h"
//最小刻度线的高度
#define MIN_LINE_HEIGHT  20

#define MIDDLE_LINE_HEIGHT  30
//最大刻度线的高度
#define MAX_LINE_HEIGHT  35
//最小一格刻度的间距
#define MIN_X_SPACE 8

//三角指示器的宽度
#define TRANGLE_WIDTH 16

/**
 *  绘制三角形标示
 */
typedef enum : NSUInteger {
    TranglePoint_DOWN,//三角形向下,
    TranglePoint_UP//三角形向上
} TranglePoint;

@interface IndicateView : UIView
@property(nonatomic,strong)UIColor *fillColor;
@property(nonatomic,assign)TranglePoint tranglePoint;
@end
@implementation IndicateView

-(void)drawRect:(CGRect)rect{
    //设置背景颜色
    [[UIColor clearColor]set];
    
    UIRectFill([self bounds]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path路径进行绘制三角形
    CGContextBeginPath(context);//标记
    
    if (self.tranglePoint == TranglePoint_UP) {
        
        CGContextMoveToPoint(context, 0, TRANGLE_WIDTH);
        
        CGContextAddLineToPoint(context, TRANGLE_WIDTH, TRANGLE_WIDTH);
        
        CGContextAddLineToPoint(context, TRANGLE_WIDTH/2.0, TRANGLE_WIDTH/2.0);

    }else
    {
        CGContextMoveToPoint(context, 0, 0);
        
        CGContextAddLineToPoint(context, TRANGLE_WIDTH, 0);
        
        CGContextAddLineToPoint(context, TRANGLE_WIDTH/2.0, TRANGLE_WIDTH/2.0);
        
    }
    CGContextSetLineCap(context, kCGLineCapButt);//线结束时是否绘制端点，该属性不设置。有方形，圆形，自然结束3中设置
    CGContextSetLineJoin(context, kCGLineJoinBevel);//线交叉时设置缺角。有圆角，尖角，缺角3中设置
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [_fillColor setFill];//设置填充色
    [_fillColor setStroke];//设置边框色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path，后属性表示填充
}

@end

@class IndicateView;
@interface WXScrollRulerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * contentView;

@property (nonatomic, assign) float minValue;//最小值

@property (nonatomic, assign) float maxValue;//最大值

@property (nonatomic, assign) float initialValue;//默认初始值

@property (nonatomic, strong) IndicateView *indicateView;//三角形指示

@end

@implementation WXScrollRulerView


- (instancetype)initWithFrame:(CGRect)frame minValue:(float )minValue maxValue:(float)maxValue initialValue:(float) initialValue
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.minValue = minValue;
        self.maxValue = maxValue;
        self.initialValue = initialValue;
        self.minRulerValue = 1.0;
        self.rulerColor = [UIColor lightGrayColor];
        self.rulerValueColor = [UIColor blackColor];
        self.showRulerNumber = YES;
    
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.frame = self.bounds;
        _contentView.delegate = self;
        [self addSubview:_contentView];
        [self addSubview:self.indicateView];
        
    }

    return self;
}

- (IndicateView *)indicateView
{
    
    if (!_indicateView) {
        _indicateView = [[IndicateView alloc] init];
        _indicateView.frame = CGRectMake((self.bounds.size.width - TRANGLE_WIDTH)/2.0, 0, TRANGLE_WIDTH, TRANGLE_WIDTH);
        _indicateView.backgroundColor = [UIColor clearColor];
        _indicateView.fillColor = [UIColor redColor];
    }
    return _indicateView;
}

- (void)drawRect:(CGRect)rect
{
    [self drawRuler];
}

- (void)setRulerColor:(UIColor *)rulerColor
{
    _rulerColor = rulerColor;
}

- (void)setShowRulerNumber:(BOOL)showRulerNumber
{
    _showRulerNumber = showRulerNumber;
}

- (void)setRulerValueColor:(UIColor *)rulerValueColor
{
    _rulerValueColor = rulerValueColor;
}

- (void)setMinRulerValue:(float)minRulerValue
{
    _minRulerValue = minRulerValue;
}

- (void)drawRuler
{
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = self.rulerColor.CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = self.rulerColor.CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    float totalValue = self.maxValue - self.minValue;
    NSInteger totalCount = totalValue/self.minRulerValue;//要画的刻度数量
    float halfWidth = self.bounds.size.width/2.0;
    
    float horizontalLineY = CGRectGetHeight(self.bounds)/2.0 + MAX_LINE_HEIGHT/2.0 -2;
    
    CGMutablePathRef pathlineX = CGPathCreateMutable();
    CAShapeLayer *lineXLayer = [CAShapeLayer layer];
    lineXLayer.strokeColor = self.rulerColor.CGColor;
    lineXLayer.fillColor = [UIColor clearColor].CGColor;
    lineXLayer.lineWidth = 1.f;
    lineXLayer.lineCap = kCALineCapButt;
    
    CGPathMoveToPoint(pathlineX, NULL, halfWidth , horizontalLineY);
    CGPathAddLineToPoint(pathlineX, NULL, halfWidth + (MIN_X_SPACE*totalCount), horizontalLineY);
    lineXLayer.path = pathlineX;
    [self.contentView.layer addSublayer:lineXLayer];
    
    
    for (int i = 0 ; i <= totalCount; i++) {
        
        float x = halfWidth + MIN_X_SPACE*i;
        if (i % 10 == 0){
        
            CGPathMoveToPoint(pathRef2, NULL,x, horizontalLineY);
            CGPathAddLineToPoint(pathRef2, NULL, x, horizontalLineY - MAX_LINE_HEIGHT);
            
            if (self.showRulerNumber) {
                UILabel *rule = [[UILabel alloc] init];
                rule.textColor = self.rulerValueColor;
                rule.font = [UIFont systemFontOfSize:12.0];
                rule.text = [NSString stringWithFormat:@"%.0f",i * self.minRulerValue + self.minValue];
                CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
                
                rule.frame = CGRectMake(x - (textSize.width/2.0),horizontalLineY + 3,0,0);
                [rule sizeToFit];
                [self.contentView addSubview:rule];
            }
            
        }else if (i % 5 == 0){
        
            CGPathMoveToPoint(pathRef1, NULL, x , horizontalLineY);
            CGPathAddLineToPoint(pathRef1, NULL, x, horizontalLineY - MIDDLE_LINE_HEIGHT);
            
        
        }else{
        
            CGPathMoveToPoint(pathRef1, NULL, x , horizontalLineY);
            CGPathAddLineToPoint(pathRef1, NULL, x, horizontalLineY - MIN_LINE_HEIGHT);
        
        }
        
        
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.contentView.layer addSublayer:shapeLayer1];
    [self.contentView.layer addSublayer:shapeLayer2];
    
    if (self.indicateView.tranglePoint == TranglePoint_UP) {
        
       self.indicateView.frame = CGRectMake((self.bounds.size.width - TRANGLE_WIDTH)/2.0, horizontalLineY - TRANGLE_WIDTH, TRANGLE_WIDTH, TRANGLE_WIDTH);
    }
    
    self.contentView.contentSize = CGSizeMake(halfWidth*2 + MIN_X_SPACE * totalCount, 0);
    
    if (self.initialValue <= self.minValue) {
        [self.contentView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (self.initialValue >= self.maxValue){
        [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - self.contentView.bounds.size.width, 0) animated:NO];
    }else{
    
        float moveX = ((self.initialValue - self.minValue)/self.minRulerValue)*MIN_X_SPACE;
        [self.contentView setContentOffset:CGPointMake(moveX, 0) animated:NO];
    }
    
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float value = scrollView.contentOffset.x;
    float selectValue = (value/MIN_X_SPACE)*self.minRulerValue;
    selectValue += self.minValue;
    
    if (selectValue <= self.minValue) {
        selectValue = self.minValue;
    }
    if (selectValue >= self.maxValue){
    
        selectValue = self.maxValue;
    }
    
    if (self.currentValueChanged) {
        self.currentValueChanged(selectValue);
    }
    NSLog(@"scrollViewDidScroll ====%f",selectValue);
}




@end
