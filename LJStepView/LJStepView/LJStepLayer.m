//
//  LJStepLayer.m
//
//  Created by IMS_Mac on 2020/11/24.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "LJStepLayer.h"

@interface LJStepLayer ()

@property (nonatomic, strong)  NSMutableAttributedString *attributedString;

@property (nonatomic, weak) CATextLayer *textLayer;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat layerHeight;
@end


@implementation LJStepLayer

+ (instancetype)layerWithWidth:(CGFloat)width andHeight:(CGFloat)height andTitle:(NSString *)title andType:(LJStepLayerDrawType)drawType {
    
    LJStepLayer *layer = [LJStepLayer layer];
    layer.layerHeight = height;
    layer.font = [UIFont systemFontOfSize:12];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radius = height*0.5;
    CGFloat angle = 0.6;
    
    if (drawType == stepLayerDrawType_begin) {
        [path moveToPoint:CGPointMake(radius, 0)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width+radius*angle, radius)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(radius, height)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI*2  clockwise:YES];
    }else if (drawType == stepLayerDrawType_middle) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width+radius*angle, height*0.5)];
        [path addLineToPoint:CGPointMake(width, height)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointMake(radius*angle, radius)];
    }else if (drawType == stepLayerDrawType_end) {
        [path moveToPoint:CGPointMake(width - radius, height)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path addLineToPoint:CGPointMake(radius*angle, radius)];
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(width - radius, 0)];
        [path addArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    }
    
    CATextLayer *textLayer = [CATextLayer layer];
    layer.textLayer = textLayer;
//    textLayer.backgroundColor = [UIColor brownColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.anchorPoint = CGPointMake(0, 0);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.wrapped = YES;// 换行
//    textLayer.truncationMode = kCATruncationEnd;
//    textLayer.actions = @{
//        @"bounds" : [NSNull null],  // prevent implicit animation of bounds
//        @"position" : [NSNull null] // and position
//    };

    textLayer.string = layer.attributedString = [[NSMutableAttributedString alloc]initWithString:title attributes:nil];
    [layer addSublayer:textLayer];
    
    layer.path = path.CGPath;
    layer.bounds = CGRectMake(0, 0, width, height);
    CGFloat textHeight = layer.attributedString.size.height;
//    CGFloat textHeight = [layer getTextLayerHeight:width-radius*angle];
//    textHeight = textHeight > height ? height-4 : textHeight;
    textLayer.frame = CGRectMake(radius*angle, (height-textHeight)*.5, width-radius*angle, textHeight);
    return layer;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self resetFillColor];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    [self resetFillColor];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self resetFillColor];
}

- (void)resetFillColor {
    if (_selected) {
        self.fillColor = _highlightColor.CGColor;
    } else {
        self.fillColor = _normalColor.CGColor;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        [_attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [_attributedString length])];
    }
    self.textLayer.string = _attributedString;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    if (font) {
        [_attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [_attributedString length])];
        CGRect textFrame = self.textLayer.frame;
        CGFloat textHeight = self.attributedString.size.height;
//        CGFloat textHeight = [self getTextLayerHeight:textFrame.size.width];
//        textHeight = textHeight > self.layerHeight ? self.layerHeight-4 : textHeight;
        textFrame.size.height = textHeight;
        textFrame.origin.y = (self.layerHeight-textHeight)*.5;
        self.textLayer.frame = textFrame;
    }
}

- (CGFloat)getTextLayerHeight:(CGFloat)textLayerWidth {
    
    CGFloat h = [_attributedString.string boundingRectWithSize:CGSizeMake(textLayerWidth, MAXFLOAT) options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : self.font} context:nil].size.height;
    return  h;
}



@end
