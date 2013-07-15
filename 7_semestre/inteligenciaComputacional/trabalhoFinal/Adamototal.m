clear all;

filename = 'car.data';
%fid = fopen(filename);
%N = fscanf(fid, '%s,', 1);
%N
%fclose(fid);

%filename = 'car.dat';
%measrows = 4;
%meascols = 4;

% open the file
fid = fopen(filename);

teste = textscan(fid,'%s %s %s %s %s %s %s');
%mat=cell2mat(teste{1,1});


%for i=1:10
   %teste{1}{1}
   x = teste{6}{1};
   %m(1) = x;
%end
%csvread(
%filename = 'car.data';
%delimiterIn = ' ';
%headerlinesIn = 1728;
%A = importdata(filename,delimiterIn,headerlinesIn);
%x = A(1);
%for k = [3, 5]
%   disp(A.colheaders{1, k})
%   disp(A.data(:, k))
%   disp(' ')
%end
% make sure the file is not empty
%finfo = dir(filename);
%fsize = finfo.bytes;

%if fsize > 0 

    % read the file
 %   block = 1;
  %  while ~feof(fid)
   %     mystruct(block) = fscanf(fid, '%s,%s,%s,%s,%s,%s,%s', 1);
        %mystruct(block).mdate = fscanf(fid, '%s', 1);

        % fscanf fills the array in column order,
        % so transpose the results
       % mystruct(block).meas  = ...
       %   fscanf(fid, '%f', [measrows, meascols])';

    %    block = block + 1;
    %end

%end

% close the file
fclose(fid);