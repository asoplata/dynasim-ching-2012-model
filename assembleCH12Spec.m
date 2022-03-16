function specification = assembleCH12Spec(numCellsScale)
%ASSEMBLECH12SPEC - Construct and connect the cortex of the (Ching et al., 2012) model
%
% assembleCH12Spec builds a (Ching et al., 2012)-type DynaSim specification,
% including both its populations and connections from the many mechanism files
% contained in the 'models/' subdirectory.
%
% Inputs:
%   'numCellsScale': number to multiply each cell population size
%                    by aka the proportion; use any non-negative Real number.
%                    To run the full model, use 1. If one wishes to run a
%                    smaller model, use a smaller proportion like 0.2.
%                    Likewise, for a network twice as large, use 2.0.
%
% Outputs:
%   'specification': DynaSim specification structure for the (Ching
%                    et al., 2012) model.
%
% Dependencies:
%   - This has only been tested on MATLAB version 2017a.
%
% References:
%   - Ching S, Purdon PL, Vijayan S, Kopell NJ, Brown EN. A
%   neurophysiological-metabolic model for burst suppression. Proceedings of
%   the National Academy of Sciences. 2012;109: 3095–3100.
%   doi:10.1073/pnas.1121461109
%
% Author: Austin Soplata
% Copyright (C) 2018 Austin Soplata, Boston University, USA
% -------------------------------------------------------------------------

eqns={
  'dv/dt=(@current)/Cm'
  'Cm = 1'    % uF/cm^2
  'spike_threshold = -25'
  'monitor v.spikes(spike_threshold)'
  'vIC = -68'    % mV
  'vNoiseIC = 50' % mV
  'v(0) = vIC+vNoiseIC*rand(1,Npop)'
};

%% Synaptic connection parameters
% TODO normalized????
gei=2.0;   % PY->FS, AMPA synaptic maximal conductance in mS/cm^2
gie=0.64; % FS->PY, GABAa synaptic maximal conductance in mS/cm^2
gii=1.0; % FS->FS, GABAa synaptic maximal conductance in mS/cm^2
gee=0.1;   % PY->FS, AMPA synaptic maximal conductance in mS/cm^2

%% Specification object creation
% M-current isn't used in this model? not sure why it was here
%     'iM_CH12',...
specification=[];
specification.populations(1).name='PY';
specification.populations(1).size=round(numCellsScale*10);
specification.populations(1).equations=eqns;
specification.populations(1).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_CH12',...
    'iK_CH12',...
    'iLeak_CH12',...
    'iKATP_CH12',...
    };

specification.populations(2).name='FS';
specification.populations(2).size=round(numCellsScale*4);
specification.populations(2).equations=eqns;
specification.populations(2).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_CH12',...
    'iK_CH12',...
    'iLeak_CH12',...
    };

% Intracortical connectivity
specification.connections(1).direction='PY->PY';
specification.connections(1).mechanism_list={'iAMPA_CH12'};
specification.connections(1).parameters={'gAMPA',gee};

specification.connections(2).direction='PY->FS';
specification.connections(2).mechanism_list={'iAMPA_CH12'};
specification.connections(2).parameters={'gAMPA',gei};

specification.connections(3).direction='FS->PY';
specification.connections(3).mechanism_list={'iGABAa_CH12'};
specification.connections(3).parameters={'gGABAa',gie};

specification.connections(4).direction='FS->FS';
specification.connections(4).mechanism_list={'iGABAa_CH12'};
specification.connections(4).parameters={'gGABAa',gii};
