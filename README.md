# DynaSim mechanism files for simulating (Ching et al., 2012)

DynaSim-compatible mechanism files for simulation of the cortex of (Ching et
al., 2012).

Adding these mechanism files and associated functions into where you keep your
mechanism files for [DynaSim](https://github.com/DynaSim/DynaSim), e.g.
`/your/path/to/dynasim/models`, should enable you to simulate the computational
cortex from:

    Ching S, Purdon PL, Vijayan S, Kopell NJ, Brown EN. A
    neurophysiological-metabolic model for burst suppression. Proceedings of
    the National Academy of Sciences. 2012;109: 3095–3100.
    doi:10.1073/pnas.1121461109

This is NOT intended as a bit-perfect reproduction of the original model, but
rather just an open-source, adequate reproduction of the overall qualitative
results.

## Install and Usage

The easiest way to get started with this is:
1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
   including adding it to your MATLAB path.
2. Run `git clone https://github.com/asoplata/dynasim-ching-2012-model` or
   download this code's repo
   (https://github.com/asoplata/dynasim-ching-2012-model) into
   `'/your/path/to/dynasim/models'`, i.e. the `'models'` subdirectory of your
   copy of the DynaSim repo.
3. Start MATLAB, and run the main runscript `runCH12model.m`.

## References

1. Ching S, Purdon PL, Vijayan S, Kopell NJ, Brown EN. A
   neurophysiological-metabolic model for burst suppression. Proceedings of the
   National Academy of Sciences. 2012;109: 3095–3100.
   doi:10.1073/pnas.1121461109
