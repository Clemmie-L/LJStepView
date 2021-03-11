//
//  LJStepView.m
//
//  Created by IMS_Mac on 2020/11/24.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "LJStepView.h"
#import "LJStepLayer.h"

@interface LJStepView ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,LJStepLayer *> *stepLayers;

@end

@implementation LJStepView

+ (instancetype)stepView:(NSArray<NSString *> *)titleArray {
    LJStepView *stepView = [[LJStepView alloc]init];
    stepView.titleArray = titleArray;
    return stepView;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    [self createSublayers];
}

- (void)createSublayers {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    [self.stepLayers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, LJStepLayer * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [self.stepLayers removeAllObjects];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    __block CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemWidth = (width - self.itemMargin * (self.titleArray.count - 1)) / self.titleArray.count;
    CGFloat itemHeight = height;
    
    __block LJStepLayerDrawType drawType = stepLayerDrawType_begin;
    [self.titleArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0  && idx < self.titleArray.count - 1) {
            drawType = stepLayerDrawType_middle;
        }else if (idx > 0 && idx == self.titleArray.count - 1 ) {
            drawType = stepLayerDrawType_end;
        }
        
        itemX = (itemWidth + self.itemMargin) * idx;
        
        LJStepLayer *layer = [LJStepLayer layerWithWidth:itemWidth andHeight:itemHeight andTitle:obj  andType:drawType];
        layer.normalColor = self.normalBgColor;
        layer.highlightColor = self.highlightBgColor;
        [layer setFont:self.textFont];
        [layer setTextColor:self.textColor];
        layer.selected = idx == 0;
        CGRect frame = layer.frame;
        frame.origin = CGPointMake(itemX, itemY);
        layer.frame = frame;
        [self.layer addSublayer:layer];
        [self.stepLayers setObject:layer forKey:@(idx)];
    }];
    
    self.didSelectedIndex = self.didSelectedIndex;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    [self.stepLayers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, LJStepLayer * _Nonnull layer, BOOL * _Nonnull stop) {
        CGPoint convertPoint = [layer convertPoint:point fromLayer:self.layer];
        if (CGPathContainsPoint(layer.path, NULL, convertPoint, NO) && self.didSelectedIndex != key.integerValue) {
            self.didSelectedIndex = key.integerValue;
            if ([_delegate respondsToSelector:@selector(stepView:didSelectRowAtIndex:)]) {
                [_delegate stepView:self didSelectRowAtIndex:key.integerValue];
            }
        }
    }];
    
    [self.stepLayers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, LJStepLayer * _Nonnull layer, BOOL * _Nonnull stop) {
        if (self.didSelectedIndex >= key.integerValue) {
            layer.selected = YES;
        }else {
            layer.selected = NO;
        }
    }];
}

- (void)setDidSelectedIndex:(NSInteger)didSelectedIndex {
    _didSelectedIndex = didSelectedIndex;
    [self.stepLayers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, LJStepLayer * _Nonnull layer, BOOL * _Nonnull stop) {
        if (self.didSelectedIndex >= key.integerValue) {
            layer.selected = YES;
        }else {
            layer.selected = NO;
        }
    }];
}

#pragma mark - lazy
- (NSMutableDictionary<NSNumber *,LJStepLayer *> *)stepLayers {
    if (_stepLayers == nil) {
        _stepLayers = [[NSMutableDictionary alloc] init];
    }
    return _stepLayers;
}

- (UIFont *)textFont {
    if (_textFont == nil) {
        _textFont = [UIFont systemFontOfSize:14];
    }
    return _textFont;
}

- (UIColor *)textColor {
    if (_textColor == nil) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}


@end
