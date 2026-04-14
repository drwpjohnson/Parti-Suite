function color_change_buttom
    % Get the handles of all pushbuttons and radiobuttons
    ContButton = [findall(gcf,'Style','Pushbutton');findall(gcf,'Style','radiobutton')];
    % Change to red all these buttons
    set(ContButton,'Backgroundcolor','r');
%     % Set to green the current button
     set(gcbo,'Backgroundcolor','r');
end
