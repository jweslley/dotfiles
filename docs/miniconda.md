

## Install Python packages

```
conda install numpy scipy pandas matplotlib hdf5 pillow scikit-learn jupyterlab tensorflow-gpu=1.8 keras
conda install -c conda-forge feather-format
```

## Install R packages

```
conda install -c r r-essentials
```

## Create new environment

```
conda create -n myenv python
```

## Activate environment

```
conda activate myenv
```

## Install python packages

```
conda install numpy scipy pandas scikit-learn jupyterlab
```

## Export environment

```
conda env export > environment.yml --no-builds
```

