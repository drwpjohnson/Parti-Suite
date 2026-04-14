function warning_msgUPSCALE
    d = dialog('Position',[600 600 250 150],'Name','Warning');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Check user input colloid and collector radii, mismatch with data flux files');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Continue',...
               'Callback','delete(gcf)');       
    % Get the handles of all pushbuttons and radiobuttons
%     ContButton = [findall(gcf,'Style','Pushbutton');findall(gcf,'Style','radiobutton')];
%     % Change to red all these buttons
%     set(ContButton,'Backgroundcolor','r');
%     % Set to green the current button
%      set(gcbo,'Backgroundcolor','r');
     w = waitforbuttonpress;
     close ('Warning')
end