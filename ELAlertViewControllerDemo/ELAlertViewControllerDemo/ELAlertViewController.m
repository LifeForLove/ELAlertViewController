//
//  ELAlertViewController.m
//  AFNetworking
//
//  Created by 高欣 on 2020/4/28.
//

#import "ELAlertViewController.h"
#import <Masonry.h>
#import <objc/runtime.h>
typedef NS_ENUM(NSInteger, ELAlertControllerStyle) {
    ELAlertControllerStyleActionSheet = 0,
    ELAlertControllerStyleAlert
};

#define iPhoneX IsIphoneX()
#define SafeAreaBarIncreaseHeight tabbarIncreaseHeight()

@interface ELALertViewTwoActionsCell : UITableViewCell

@property (nonatomic,copy) void (^LeftSelectBlock) (UIButton * button);
@property (nonatomic,copy) void (^RightSelectBlock) (UIButton * button);

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@end

@implementation ELALertViewTwoActionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_centerX);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_centerX);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        UIView * line_v = [[UIView alloc]init];
        line_v.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:line_v];
        
        [line_v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(1);
        }];
        
        
    }
    return self;
}

- (void)leftButtonAction:(UIButton *)sender {
    if (self.LeftSelectBlock) {
        self.LeftSelectBlock(sender);
    }
}

- (void)rightButtonAction:(UIButton *)sender {
    if (self.RightSelectBlock) {
        self.RightSelectBlock(sender);
    }
}

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}



@end

@interface ELAlertViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ELAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


@interface ELAlertAction ()

@property (nonatomic,copy) void (^AlertHandler) (ELAlertAction *action);

@end

@interface ELAlertViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) NSMutableArray *actionArray;

@property (nonatomic,copy) NSString *alertTitle;

@property (nonatomic,copy) NSString *alertMessage;

@property (nonatomic,assign) ELAlertControllerStyle alertStyle;

@property (nonatomic,strong) UITableView *el_tableView;

@end

@implementation ELAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemHeight = 50.f;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgClickAction)];
        ges.delegate = self;
        [self.view addGestureRecognizer:ges];
    }
    return self;
}

+ (instancetype)el_alertControllerAlertStyleWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    ELAlertViewController * alert = [[ELAlertViewController alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.alertStyle = ELAlertControllerStyleAlert;
    alert.alertTitle = title;
    alert.alertMessage = message;
    return alert;
}

+ (instancetype)el_alertControllerWithActionSheetStyle {
    ELAlertViewController * alert = [[ELAlertViewController alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.alertStyle = ELAlertControllerStyleActionSheet;
    return alert;
}

- (void)createView {
    [self.el_tableView registerClass:[ELAlertViewCell class] forCellReuseIdentifier:NSStringFromClass([ELAlertViewCell class])];
    [self.el_tableView registerClass:[ELALertViewTwoActionsCell class] forCellReuseIdentifier:NSStringFromClass([ELALertViewTwoActionsCell class])];
    self.el_tableView.scrollEnabled = NO;
    self.el_tableView.separatorColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    self.el_tableView.backgroundColor = self.contentView.backgroundColor;
    
    if (self.alertStyle == ELAlertControllerStyleAlert) {
        [self configStyleAlertView];
    } else {
        [self configStyleActionSheetView];
    }
}

- (void)configStyleAlertView {
    [self.contentView sizeToFit];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(290);
        make.center.equalTo(self.view);
    }];
    
    if (self.alertTitle) {
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.text = self.alertTitle;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.top.mas_equalTo(self.contentView).offset(10);
        }];
    }
    
    if (self.alertMessage) {
        [self.contentView addSubview:self.messageLabel];
        self.messageLabel.text = self.alertMessage;
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.alertTitle ? self.titleLabel.mas_bottom : self.contentView).offset(10);
        }];
    }
    
    [self.contentView addSubview:self.el_tableView];
    [self.el_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo([self alertCenterStyleTableViewHeight]);
        make.top.equalTo([self styelForAlertTableViewTopMasAttribute]).offset([self styelForAlertTableViewTopMasAttributeOffset]);
    }];
    
    if (self.alertTitle || self.alertMessage) {
        UIView * line_h = [[UIView alloc]init];
        line_h.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:line_h];
        [line_h mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.el_tableView);
        }];
    }
}

- (MASViewAttribute *)styelForAlertTableViewTopMasAttribute {
    if ( self.alertMessage) {
        return self.messageLabel.mas_bottom;
    } else if (self.alertTitle) {
        return self.titleLabel.mas_bottom;
    } else {
        return self.contentView.mas_top;
    }
}

- (CGFloat)styelForAlertTableViewTopMasAttributeOffset {
    if (self.alertTitle == nil && self.alertMessage == nil) {
        return 0;
    }
    return 10;
}

- (void)configStyleActionSheetView {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo([self alertSheetHeight]);
    }];
    
    [self.contentView addSubview:self.el_tableView];
    [self.el_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.view.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alertStyle == ELAlertControllerStyleAlert && self.actions.count == 2) {
        ELAlertAction * leftAction = self.actions.firstObject;
        ELAlertAction * rightAction = self.actions.lastObject;
        ELALertViewTwoActionsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ELALertViewTwoActionsCell class])];
        [cell.leftButton setTitle:leftAction.title forState:UIControlStateNormal];
        [cell.leftButton setTitleColor:leftAction.textColor forState:UIControlStateNormal];
        cell.leftButton.titleLabel.font = leftAction.textFont;
        
        [cell.rightButton setTitle:rightAction.title forState:UIControlStateNormal];
        [cell.rightButton setTitleColor:rightAction.textColor forState:UIControlStateNormal];
        cell.rightButton.titleLabel.font = rightAction.textFont;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.LeftSelectBlock = ^(UIButton *button) {
            if (leftAction.AlertHandler) {
                leftAction.AlertHandler(leftAction);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        cell.RightSelectBlock = ^(UIButton *button) {
            if (rightAction.AlertHandler) {
                rightAction.AlertHandler(rightAction);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        return cell;
    }
    ELAlertViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ELAlertViewCell class])];
    cell.titleLabel.text = self.actions[indexPath.row].title;
    cell.titleLabel.textColor = self.actions[indexPath.row].textColor;
    cell.titleLabel.font = self.actions[indexPath.row].textFont;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alertStyle == ELAlertControllerStyleAlert && self.actions.count == 2) {
        return;
    }
    ELAlertAction * action = self.actions[indexPath.row];
    if (action.AlertHandler) {
        action.AlertHandler(action);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.alertStyle == ELAlertControllerStyleAlert && self.actions.count == 2) {
        return 1;
    }
    return self.actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemHeight;
}

- (void)el_addAction:(ELAlertAction *)action {
    if (action && [action isKindOfClass:[ELAlertAction class]]) {
        [self.actionArray addObject:action];
    }
    _actions = self.actionArray;
}

- (void)bgClickAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)alertSheetHeight {
    CGFloat height = SafeAreaBarIncreaseHeight + self.itemHeight * self.actionArray.count;
    if (height >= [UIScreen mainScreen].bounds.size.height / 2 + 100) {
        height = [UIScreen mainScreen].bounds.size.height / 2 + 100;
        self.el_tableView.scrollEnabled = YES;
    }
    return height;
}

- (CGFloat)alertCenterStyleTableViewHeight {
    CGFloat height = self.itemHeight * self.actionArray.count;
    if (self.actions.count == 2) {
        height = self.itemHeight;
    }
    return height;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (self.alertStyle == ELAlertControllerStyleActionSheet) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            self.contentView.frame = frame;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [super dismissViewControllerAnimated:flag completion:completion];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.alpha = 0;
            self.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [super dismissViewControllerAnimated:flag completion:completion];
        }];
    }
}

- (void)show {
    if (self.actions.count == 0) {
        return;
    }
    
    [self createView];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (self.alertStyle == ELAlertControllerStyleActionSheet) {
        CGRect frame = self.contentView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.contentView.frame = frame;
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            CGRect frame = self.contentView.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - [self alertSheetHeight];
            self.contentView.frame = frame;
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        } completion:^(BOOL finished) {
        }];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.view];
    CGPoint contentPoint = [self.view.layer convertPoint:point toLayer:self.contentView.layer];
    if ([self.contentView.layer containsPoint:contentPoint]) {
        return NO;
    }
    return  YES;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (NSMutableArray *)actionArray {
    if (_actionArray == nil) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (CGFloat)itemHeight {
    return _itemHeight <= 44.f ? 44.f : _itemHeight;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIRectCorner rectCorner = self.alertStyle == ELAlertControllerStyleActionSheet ? UIRectCornerTopLeft | UIRectCornerTopRight : UIRectCornerAllCorners;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

- (UITableView *)el_tableView {
    if (!_el_tableView) {
        _el_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _el_tableView.delegate = self;
        _el_tableView.dataSource = self;
        _el_tableView.showsHorizontalScrollIndicator = NO;
        _el_tableView.showsVerticalScrollIndicator = NO;
        _el_tableView.separatorColor = [UIColor clearColor];
        _el_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _el_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _el_tableView.estimatedSectionHeaderHeight = 0;
            _el_tableView.estimatedSectionFooterHeight = 0;
        } else {
        }
    }
    return _el_tableView;
}

static inline BOOL Screen_Orientation_V() {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }else {
        return NO;
    }
}

static inline CGSize ELScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

static inline BOOL IsIphoneX() {
    NSInteger scale = ELScreenSize().height / ELScreenSize().width * 100;
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (scale == 216) : NO);
}

static inline CGFloat tabbarIncreaseHeight() {
    if (Screen_Orientation_V()) {
        return (iPhoneX ? 34 : 0);
    } else {
        return (iPhoneX ? 21 : 0);
    }
}

@end

@implementation ELAlertAction

+ (instancetype)el_actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(ELAlertAction *action))handler {
    ELAlertAction * obj = [[ELAlertAction alloc]init];
    obj.AlertHandler = handler;
    [obj setValue:title forKey:@"title"];
    return obj;
}

- (UIFont *)textFont {
    if (_textFont == nil) {
        _textFont = [UIFont systemFontOfSize:15];
    }
    return _textFont;
}

- (UIColor *)textColor {
    if (_textColor == nil) {
        _textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    return _textColor;
}

@end


@interface UIViewController (ELAlertActionExtension)

@end

@implementation UIViewController (ELAlertActionExtension)

+ (void)load {
    SEL originalSel = @selector(presentViewController:animated:completion:);
    SEL newSel = @selector(hook_presentViewController:animated:completion:);
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    
}

- (void)hook_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[ELAlertViewController class]]) {
        [self hook_presentViewController:viewControllerToPresent animated:NO completion:^{
            ELAlertViewController * vc = (ELAlertViewController *)viewControllerToPresent;
            [vc show];
        }];
    } else {
        [self hook_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


@end
