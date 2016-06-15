function asc_to_nc( grid_name)

[ncols,nrows,...
    xllcorner, yllcorner,...
    cellsize, NODATA_value] = ...
    get_header_information_asc(grid_name);

lon = ((1:ncols)-1)*cellsize + (xllcorner + cellsize/2);
lat = ((1:nrows)-1)*cellsize + (yllcorner + cellsize/2);
lat = fliplr(lat);

grid_data = dlmread(grid_name,'',6,0);
grid_data(grid_data==NODATA_value) = NaN;

n_lat = numel(lat);
n_lon = numel(lon);

file_name = [grid_name(1:end-4),'.nc'];
var_name = grid_name(1:end-4);

delete(file_name);

nccreate(file_name,var_name,'Dimensions',{'lat',n_lat,'lon',n_lon});
nccreate(file_name,'lat','Dimensions',{'lat',n_lat});
ncwrite(file_name,'lat',lat)
nccreate(file_name,'lon','Dimensions',{'lon',n_lon});
ncwrite(file_name,'lon',lon)

grid_data(isnan(grid_data)) = -999.99;

ncwrite(file_name, var_name, grid_data);

ncwriteatt(file_name,'lat','units','degrees_north');
ncwriteatt(file_name,'lon','units','degrees_east');

ncwriteatt(file_name,var_name,'missing_value',-999.99);

end

function [ncols,nrows,...
    xllcorner, yllcorner,...
    cellsize, NODATA_value] = ...
    get_header_information_asc(grid_name)

fid = fopen(grid_name, 'r');
%line1: num of cols
ss = fgetl(fid);
s = strsplit(ss,' ');
ncols = str2double(s{1,2});
%line2: num of rows
ss = fgetl(fid);
s = strsplit(ss,' ');
nrows = str2double(s{1,2});
%line3: xllcorner
ss = fgetl(fid);
s = strsplit(ss,' ');
xllcorner = str2double(s{1,2});
%line4: yllcorner
ss = fgetl(fid);
s = strsplit(ss,' ');
yllcorner = str2double(s{1,2});
%line5: cellsize
ss = fgetl(fid);
s = strsplit(ss,' ');
cellsize = str2double(s{1,2});
%line6: NODATA_value
ss = fgetl(fid);
s = strsplit(ss,' ');
NODATA_value = str2double(s{1,2});
fclose(fid);

end

