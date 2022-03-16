%RUNCH12MODEL - Run the DynaSim implementation of the (Ching et al., 2012) model!
%{
This is a starter script to show both how to use the DynaSim mechanisms for
simulating the (Ching et al., 2012) model in Dynasim, available here
(https://github.com/asoplata/dynasim-ching-2012-model) while also giving you
a good skeleton to start experimenting yourself.

- Install:
  1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
     including adding it to your MATLAB path.
  2. `git clone` or download this code's repo
     (https://github.com/asoplata/dynasim-ching-2012-model) into
     '/your/path/to/dynasim/models', i.e. the 'models' subdirectory of your
     copy of the DynaSim repo.
  3. Run this file.
  4. Believe it or not...that should be it! You should be able to start MATLAB
     in your DynaSim code directory and run this script successfully!  Let me
     know if there are problems, at austin.soplata 'at-symbol-thingy' gmail
     'dot' com

- Dependencies:
    - This has only been tested on MATLAB version 2017a.

- References:
    - Ching S, Purdon PL, Vijayan S, Kopell NJ, Brown EN. A
    neurophysiological-metabolic model for burst suppression. Proceedings of
    the National Academy of Sciences. 2012;109: 3095–3100.
    doi:10.1073/pnas.1121461109

This is descended from DynaSim's `tutorial.m` script, at
https://github.com/DynaSim/DynaSim/blob/master/demos/tutorial.m

Author: Austin E. Soplata <austin.soplata@gmail.com>
Copyright (C) 2018 Austin E. Soplata, Boston University, USA
%}

% -------------------------------------------------------------------
%% 1. Define simulation parameters
% -------------------------------------------------------------------
% Setting `study_dir` to `mfilename`, which is a reserved word, will
% automatically run the simulation and deposit its data and metadata into a
% new folder in the current directory that has the SAME NAME as this file:
study_dir = mfilename;
% If you're on a cluster and instead want to save the simulation results to a
% folder in a different location, use the commented-out line below instead:com
% study_dir = strcat('/projectnb/$PROJECT/$USERNAME/p25-anesthesia-grant-sim-data/', mfilename);

% Debug: If you want to completely clean the environment, close all figures,
% and remove all data before running the simulation, set `debug` to 1:
debug = 1;
if debug == 1
    clf
    close all
    % Note: the below may be dangerous!
    if 7==exist(study_dir, 'dir')
        rmdir(study_dir, 's')
    end
end

% This is where you set the length of your simulation, in ms
time_end = 3000; % in milliseconds

% For the full size model (10 PY's and 4 FS's), use a `numCellsScaleFactor` of
% 1. To lower the number of cells simulated, but keep the same proportions,
% decrease this number to something > 0
numCellsScaleFactor = 1;

% "Vary" parameters, aka parameters to be varied -- this tells DynaSim to run a
% simulation for all combinations of values. For a tutorial on how to use
% this, see
% https://github.com/DynaSim/DynaSim/wiki/DynaSim-Getting-Started-Tutorial#running-sets-of-simulations-by-varying-model-parameters
% You can also type 'help Vary2Modifications' or see demos for more
% examples/instructions.
vary={
    'PY','appliedStim',1.8;
    % Since the original paper (and supplement) did not specify what value it
    % used for gKATP, I'm just guessing here. If you want to run this model,
    % email the author to ask him what the conductance value should be!
    'PY','gKATP', 0.25;
    'PY','JATP', 0.25;
    'PY','concATPIC', 1.25;
    'PY','concNaIC', 1.0;
    'FS','appliedStim',0.5;
};

% Here is where we set simulator options specific to `dsSimulate`, which are
% explained in the DynaSim code file `dsSimulate.m`.
simulator_options={
    'cluster_flag', 0,...       % Whether to submit simulation jobs to a cluster, 0 or 1
    'cluster_matlab_version','2017b',...% TODO
    'compile_flag', 0,...       % Whether to compile simulation using MEX, 0 or 1
    'disk_flag', 0,...% TODO
    'downsample_factor', 10,... % How much to downsample data, proportionally {integer}
    'dsPlot2_no_spikes', 1,...% TODO
    'dt', 0.01,...              % Fixed time step, in milliseconds
    'memory_limit', '16G',...    % Memory limit for use on cluster
    'mex_flag', 0,...% TODO
    'num_cores', 1,...          % Number of CPU cores to use, including on cluster
    'overwrite_flag', 1,...     % Whether to overwrite simulation raw data, 0 or 1
    'parfor_flag', 0,...        % Whether to use parfor if running multiple local sims, 0 or 1
    'plot_functions', {@dsPlot, @dsPlot, @dsPlot},...% Which plot functions to call automatically
    'plot_options', {{'plot_type', 'waveform'},...   % Arguments to pass to each of those plot functions
                     {'plot_type', 'rastergram'},...
                     {'plot_type', 'power'},...
                    },...
    'random_seed', 'shuffle',...% What seed to use, or to randomize
    'save_data_flag', 0,...     % Whether to save raw output data, 0 or 1
    'save_results_flag', 1,...  % Whether to save output plots and analyses, 0 or 1
    'solver', 'euler',...         % Numerical integration method {'euler','rk1','rk2','rk4'}
    'study_dir', study_dir,...  % Where to save simulation results and code
    'tspan', [0 time_end],...   % Time vector of simulation, [beg end], in milliseconds
    'verbose_flag', 1,...       % Whether to display process info, 0 or 1
};


% -------------------------------------------------------------------------
%% 2. Assemble the model specification
% -------------------------------------------------------------------------
spec = assembleCH12Spec(numCellsScaleFactor);

% -------------------------------------------------------------------------
%% 3. Run the simulation!
% -------------------------------------------------------------------------

data = dsSimulate(spec,'vary',vary,simulator_options{:});

dsPlot(data);
% dsPlot(data,'plot_type','rastergram');
% dsPlot(data,'plot_type','power');

