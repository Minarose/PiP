% 1_PiP_attack.m
% Loop through all .mat adjacency matrices in the 'data/' directory,
% run PiP attack, and save node participation matrices to 'results/'

clear; clc;

% --- Paths ---
data_dir = fullfile('..', 'data');
output_dir = fullfile('..', 'results');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

files = dir(fullfile(data_dir, '*_broadband_psi_adj.mat'));
n_files = length(files);

% --- Parameters ---
n_attacks = 1000000;  % Number of attack iterations per subject

% --- Loop through all files ---
for f = 1:n_files
    fprintf('Processing %s (%d/%d)\n', files(f).name, f, n_files);

    % Load adjacency matrix
    file_path = fullfile(data_dir, files(f).name);
    data = load(file_path);
    A = sparse(data.psi_adj);  % ensure sparse format

    nNodes = size(A, 1);
    
    % Generate random attack sequences
    attack_sequences = zeros(n_attacks, nNodes);
    for a = 1:n_attacks
        attack_sequences(a, :) = randperm(nNodes);
    end

    % Initialize outputs
    first_comp  = zeros(n_attacks, nNodes - 1);
    second_comp = zeros(n_attacks, nNodes - 1);

    % Run percolation attack
    parfor a = 1:n_attacks
        atk = attack_sequences(a, :);
        mask = true(1, nNodes);
        temp_first = zeros(1, nNodes - 1);
        temp_second = zeros(1, nNodes - 1);

        for step = 1:nNodes - 1
            mask(atk(step)) = false;
            sub_adj = A(mask, mask);

            if nnz(sub_adj) == 0
                bin_sizes = ones(1, sum(mask));
            else
                G = graph(sub_adj);
                cc = conncomp(G);
                bin_sizes = histcounts(cc, 1:(max(cc)+1));
            end

            temp_first(step) = max(bin_sizes);
            if numel(bin_sizes) > 1
                sorted = sort(bin_sizes, 'descend');
                temp_second(step) = sorted(2);
            else
                temp_second(step) = 0;
            end
        end

        first_comp(a, :)  = temp_first;
        second_comp(a, :) = temp_second;
    end

    % Compute percolation point
    perc_point = zeros(n_attacks, 1);
    for x = 1:n_attacks
        if max(second_comp(x, :)) > 1
            perc_point(x) = find(second_comp(x, :) == max(second_comp(x, :)), 1, 'first');
        else
            perc_point(x) = nNodes;
        end
    end

    % Compute node participation at percolation
    node_participation_at_percolation = nan(nNodes, nNodes);
    for p = 1:nNodes
        idx = find(perc_point == p);
        if ~isempty(idx)
            node_counts = zeros(1, nNodes);
            for j = idx'
                involved = attack_sequences(j, 1:p);
                node_counts(involved) = node_counts(involved) + 1;
            end
            node_participation_at_percolation(p, :) = node_counts / numel(idx);
        end
    end

    % Save results
    [~, name, ~] = fileparts(files(f).name);
    save(fullfile(output_dir, [name '_participation.mat']), ...
        'node_participation_at_percolation', '-v7.3');
end

fprintf('PiP analysis complete. Results saved to: %s\n', output_dir);

