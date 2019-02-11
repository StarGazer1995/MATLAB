function text_win(fig_title_cell,descriptive_text_cell,done_flag)
%
% Function to create a graphics window for displaying
% graphs and text in a list box for the demo
%
% Input:
%   done_flag = optional, =1 to add a Close button to the screen

global demo_fig

if nargin < 3,  % No done flag provided
  done_flag = 0;
end;

clf;
text_plot_fig=gcf;
colordef none;

fig_title = uicontrol(text_plot_fig,...
  'style','text',...
  'units','normalized',...
  'fontsize',18',...
  'fontweight','bold',...
  'horizontalalignment','left',...
  'string',fig_title_cell,...
  'backgroundcolor','black',...
  'foregroundcolor','white',...
  'position',[0.1 0.1 0.85 0.85]);

text_describe = uicontrol(text_plot_fig,...
  'style','listbox',...
  'units','normalized',...
  'fontsize',12,...
  'backgroundcolor','white',...
  'position',[0.1 0.05 0.85 0.80],...
  'string',descriptive_text_cell);

if done_flag==1,
  close_txt_win = uicontrol(text_plot_fig,...
  'style','push',...
  'units','normalized',...
  'backgroundcolor','white',...
  'fontsize',12,...
  'position',[0.80 0.925 0.15 0.05],...
  'string','Return to Main',...
  'CallBack',[ ...
    'close(text_plot_fig);',...
    'set(demo_fig(1),''visible'',''on'');']);
end;



