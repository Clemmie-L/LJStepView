//
//  LJStepView.h
//
//  Created by IMS_Mac on 2020/11/24.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LJStepView;
@protocol LJStepViewDelegate <NSObject>

@optional

- (void)stepView:(LJStepView *)stepView didSelectRowAtIndex:(NSInteger)index;

@end

@interface LJStepView : UIView

+ (instancetype)stepView:(NSArray<NSString *> *)titleArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger didSelectedIndex;//选中的下标，默认0

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *normalBgColor;

@property (nonatomic, strong) UIColor *highlightBgColor;

@property (nonatomic, weak) id<LJStepViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
