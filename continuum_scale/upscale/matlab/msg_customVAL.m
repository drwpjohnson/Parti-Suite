function msg_customVAL
    d = dialog('Position',[600 600 250 150],'Name','Notice');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','User-defined rate constants loaded!');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Continue',...
               'Callback','delete(gcf)');       
    % Get the handles of all pushbuttons and radiobuttons
    ContButton = [findall(gcf,'Style','Pushbutton');findall(gcf,'Style','radiobutton')];
    % Change to red all these buttons
    set(ContButton,'Backgroundcolor','g');
%     % Set to green the current button
     set(gcbo,'Backgroundcolor','g');
     w = waitforbuttonpress;
     close ('Notice')
end