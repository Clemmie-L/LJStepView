//
//  LJStepLayer.h
//
//  Created by IMS_Mac on 2020/11/24.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LJStepLayerDrawType) {
    stepLayerDrawType_begin,
    stepLayerDrawType_middle,
    stepLayerDrawType_end,
};

NS_ASSUME_NONNULL_BEGIN

@interface LJStepLayer : CAShapeLayer

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightColor;

- (void)setTextColor:(UIColor *)textColor;

- (void)setFont:(UIFont *)font;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

+ (instancetype)layerWithWidth:(CGFloat)width andHeight:(CGFloat)height andTitle:(NSString *)title andType:(LJStepLayerDrawType)drawType;

@end

NS_ASSUME_NONNULL_END
