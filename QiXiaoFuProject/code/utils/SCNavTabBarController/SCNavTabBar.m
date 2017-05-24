//
//顶部栏
//


#define SCREENW  ([UIScreen mainScreen].bounds.size.width)

#define kMarginWidth 20

#import "SCNavTabBar.h"
#import "NSString+YZExtension.h"


@interface SCNavTabBar ()
{
    UIScrollView    *_navgationTabBar;
    UIView          *_line;                 // underscore show which item selected
    NSArray         *_itemsWidth;           // an array of items' width
    
    float           _contentWidth;         //导航条内容的宽度
}
@end

@implementation SCNavTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _items = [@[] mutableCopy];
    [self viewConfig];
}

- (void)viewConfig
{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
    _navgationTabBar.bounces = YES;
//    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)updateData
{
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        //导航条的宽度
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _contentWidth = contentWidth;
        
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
        
        //首先调用一次 让第一个按钮选中
        [self setCurrentItemIndex:0];
        //处理下划线
        [self showLineWithButtonWidth:[_itemsWidth[0] floatValue]];
    }
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] yzSizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize];
  
        //按钮的大小也算上了左右20的间距
        textRealSize = CGSizeMake(textRealSize.width + kMarginWidth*2, 44);
        button.frame = CGRectMake(buttonX, 0,textRealSize.width, 44);
        
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
    }

    return buttonX;
}

#pragma mark  初始化下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(kMarginWidth, 44 - 2.0f, width, 2.0f)];
    _line.backgroundColor = [UIColor redColor];
    [_navgationTabBar addSubview:_line];
    
//    UIButton *btn = _items[0];
//    [self itemPressed:btn type:0];
}

#pragma mark --按钮被点击的事件
- (void)itemPressed:(UIButton *)button type:(int)type
{
    
    NSInteger index = [_items indexOfObject:button];
    
    //代理方法中调用了如果触发了ScrollViewDidScroll  _navTabBar.currentItemIndex = _currentIndex;
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
}

//计算标题数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [title yzSizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize];
       
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
  
    return widths;
}

#pragma mark 重写setter方法  内容视图切换传递过来的偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    //选中与取消选中
    UIButton *lastButton=_items[_currentItemIndex];
    lastButton.selected = NO;
    
    _currentItemIndex = currentItemIndex;
    
    UIButton *button = _items[currentItemIndex];
    button.selected = YES;
    
    
    if (_contentWidth >SCREENW) {//内容比屏幕大才偏移
        if (button.frame.origin.x + button.frame.size.width + 50 >= SCREENW)
        {
            CGFloat offsetX = button.frame.origin.x + button.frame.size.width - SCREENW;
            if (_currentItemIndex < [_itemTitles count]-1)
            {

                if (offsetX+button.frame.size.width > _contentWidth -SCREENW) {//超出最大位移
                    
                    offsetX = _contentWidth-SCREENW;
                    
                }else{
                    
                    offsetX = offsetX + button.frame.size.width;

                }
                
            }
            [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            
        }
        else
        {
            [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
 
       //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + kMarginWidth, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue], _line.frame.size.height);
    }];
}


#pragma mark --重写setter方法
-(void)setLineColor:(UIColor *)lineColor{

    _lineColor = lineColor;
    //下划线的颜色
    _line.backgroundColor = lineColor;
}

@end
