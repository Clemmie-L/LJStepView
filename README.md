# LJStepView
stepView 和第三方WMPageController使用，效果还不错

## result

![image](https://github.com/Clemmie-L/LJStepView/blob/main/Sources/image1.png)

## init

        _stepView = [LJStepView stepView:@[@"Step 1",@"Step 2",@"Step 3"]];
        // _stepView = [[LJStepView alloc]init];
        _stepView.itemMargin = 2;
        _stepView.delegate = self;
        _stepView.normalBgColor = [UIColor blackColor];
        _stepView.highlightBgColor = [UIColor redColor];
        _stepView.textColor = [UIColor whiteColor];
        _stepView.textFont = [UIFont systemFontOfSize:14];
        // _stepView.titleArray = @[@"Step 1",@"Step 2",@"Step 3"];

## delegate

    - (void)stepView:(LJStepView *)stepView didSelectRowAtIndex:(NSInteger)index {
        NSLog(@"%zd",index);

    }
