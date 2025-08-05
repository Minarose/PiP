% --- Setup ---
addpath(genpath('./BCT'))  % Assumes Brain Connectivity Toolbox is in ./BCT

data_dir = './data';
out_dir = './results/graph_hub_metrics';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% === Get file list ===
files = dir(fullfile(data_dir, '*_broadband_psi_adj.mat'));
n_subs = length(files);

% === Load a sample to get dimensions ===
sample = load(fullfile(data_dir, files(1).name));
A0 = sample.psi_adj;  % ensure the field name matches
n_nodes = size(A0, 1);

% === Preallocate output matrices ===
deg_all = zeros(n_subs, n_nodes);
bc_all  = zeros(n_subs, n_nodes);
pr_all  = zeros(n_subs, n_nodes);

% --- Loop over subjects ---
for s = 1:n_subs
    data = load(fullfile(data_dir, files(s).name));
    A = data.psi_adj;

    % === Degree (Strength) ===
    deg_all(s, :) = strengths_und(A);

    % === Betweenness Centrality ===
    A_len = weight_conversion(A, 'lengths');  % Convert weights to distances
    bc_all(s, :) = betweenness_wei(A_len);

    % === PageRank Centrality ===
    pr_all(s, :) = pagerank_centrality(A, 0.85);  % Damping factor = 0.85
end

% === Save output ===
save(fullfile(out_dir, 'hub_metrics_all_subjects.mat'), ...
     'deg_all', 'bc_all', 'pr_all');
