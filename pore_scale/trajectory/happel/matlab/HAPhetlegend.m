function HAPhetlegend (nfig,dim)
%modified from mathworks.com
figure (nfig)
str = {'Green circles represent heterodomain locations'};
annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','none','BackgroundColor','w');
drawnow
end