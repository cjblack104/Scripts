% Supply a mat file from the kvaser and this will create a new mat file
% better structured to do analsys on.
clear
file = '2015-01-06_airflow_test_001.mat';
map = containers.Map;
matname = 'test.mat';

varlist = whos('-file',file);

[r,c] = size(varlist);

for i = [1:r]
    if(strcmp(varlist(i).name,'header')) 
        continue 
    end
    k = load(file,varlist(i).name);
    var = getfield(k,varlist(i).name);
    n = regexp(var.Channelname, '_\d*_', 'split');
    n = regexp(n{2}, '_\d*', 'split');
    sig.name = n{1};
    sig.ts = timeseries(var.signals.values,var.time);
    sig.ts.Name = sig.name;
    sig.time = var.time;
    sig.value = var.signals.values;
    map(sig.name) = sig;
    headers{i} = sig.name;
end

save(matname,'headers','map');

