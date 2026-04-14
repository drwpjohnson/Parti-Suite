function [XOUTm,YOUTm,ZOUTm,TBULKs,TNEARs,TTOTAL,ATTACHK,XINIT,YINIT,RINIT,ZINIT,NSVEL] = importUPFLUX(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 7;
    endRow = 426;
end

%% Import the data
[~, ~, raw] = xlsread(workbookFile, sheetName, sprintf('A%d:AA%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    [~, ~, tmpRawBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:AA%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
ATTACHK = data(:,2);
XINIT = data(:,3);
YINIT = data(:,4);
ZINIT = data(:,6);
RINIT = data(:,7);
XOUTm = data(:,9);
YOUTm = data(:,10);
ZOUTm = data(:,11);
TBULKs = data(:,17);
TNEARs = data(:,18);
TFRICs = data(:,19);
NSVEL = data(:,27);
%remove NaN values
NaNind= isnan(XOUTm); 
ATTACHK(NaNind)=[];
XINIT(NaNind)=[];
YINIT(NaNind)=[];
RINIT(NaNind)=[];
ZINIT(NaNind)=[];
XOUTm(NaNind)=[]; 
YOUTm(NaNind)=[];
ZOUTm(NaNind)=[];
TBULKs(NaNind)=[];
TNEARs(NaNind)=[];
TFRICs(NaNind)=[];
NSVEL(NaNind)=[];
% calculate TTOTAL
TTOTAL = TBULKs+TNEARs+TFRICs;
end
