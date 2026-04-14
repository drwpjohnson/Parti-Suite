function wait_msgUPSCALE
    d = dialog('Position',[600 600 250 150],'Name','Notice');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Data will be loaded from flux file, please wait a few seconds');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Continue',...
               'Callback','delete(gcf)');       
    % Get the handles of all pushbuttons and radiobuttons
    ContButton = [findall(gcf,'Style','Pushbutton');findall(gcf,'Style','radiobutton')];
    % Change to red all these buttons
    set(ContButton,'Backgroundcolor','y');
%     % Set to green the current button
     set(gcbo,'Backgroundcolor','y');
     w = waitforbuttonpress;
     close ('Notice')
end