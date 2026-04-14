function msg_select_roughness_large
    d = dialog('Position',[600 600 250 150],'Name','Notice');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 50],...
               'String','Roughness algorithm designed for <10 µm asperity height,for which generation of new impinging surfaces is limited');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Continue',...
               'Callback','delete(gcf)');       
    % Get the handles of all pushbuttons and radiobuttons
    ContButton = [findall(gcf,'Style','Pushbutton')];
    % Change to red all these buttons
    set(ContButton,'Backgroundcolor','g');
%     % Set to green the current button
     set(gcbo,'Backgroundcolor','g');
     w = waitforbuttonpress;
     close ('Notice')
end