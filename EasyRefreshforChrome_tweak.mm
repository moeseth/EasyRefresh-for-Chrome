static UIButton *actionBtn = nil;

@interface WebToolbarController
@end

@interface OmniboxTextFieldIOS : UITextField
@end

@interface TabModel
@end

@interface Tab
@end

%hook BrowserViewController
- (void)keyboardWillBeHidden:(id)fp8
{
    if (actionBtn)
        actionBtn.hidden = NO;
        
    %orig;
}

%new(v@:)
- (void) reloadPage
{
    TabModel *model = [self tabModel];
    Tab *tab1 = [model currentTab];
    
    if (!tab1)
        return;
    
    [tab1 reload];
}

%new(v@:)
- (void) cancelLoading
{
    TabModel *model = [self tabModel];
    Tab *tab1 = [model currentTab];
    
    if (!tab1)
        return;
    
    [tab1 stopLoading];
}

- (void)updateToolbar
{
    WebToolbarController *toolBar = MSHookIvar<WebToolbarController *>(self, "toolbarController_");
    if (!toolBar)
    {
        %orig;
        return;
    }
    
    OmniboxTextFieldIOS *field = [toolBar omniBox];

    if (!actionBtn)
    {
        actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake(field.frame.size.width - 25, field.frame.size.height/2 - 10, 20, 20);
        [field addSubview:actionBtn];
    }
        
    if ([self isCurrentTabLoading])
    {
        [actionBtn setImage:[UIImage imageWithContentsOfFile:@"/Applications/MobileSafari.app/AddressViewStop.png"] forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(cancelLoading) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
        [actionBtn setImage:[UIImage imageWithContentsOfFile:@"/Applications/MobileSafari.app/AddressViewReload.png"] forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(reloadPage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        actionBtn.frame = CGRectMake(field.frame.size.width - 25, field.frame.size.height/2 - 10, 20, 20);
        actionBtn.hidden = NO;
    }];
    
    %orig;
}

- (void)locationBarDidBecomeFirstResponder:(id)fp8
{
    if (actionBtn)
        actionBtn.hidden = YES;
        
    %orig;
}

- (void)locationBarDidResignFirstResponder:(id)fp8
{
    if (actionBtn)
        actionBtn.hidden = NO;
    %orig;
}
%end