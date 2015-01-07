function fig2pdf(h,fn)
% Papersize fix for pdf prints. Saves the figure (h) as pdf with the
% filename fn.
%
% Example: plot(sin(1:10)), fig2pdf('Example_sin')
%
if ~ishandle(h)
    fn = h;
    h = gcf;
end

old_unit = get(h,'Units');
set(h,'Units','inches','PaperPositionMode','auto','PaperUnits','inches')
set(h,'PaperSize',get(h,'position')*[0 0;0 0;1 0;0 1])
print(h,'-dpdf',fn)
fprintf('%s created\n',fn)
set(h,'Units',old_unit)