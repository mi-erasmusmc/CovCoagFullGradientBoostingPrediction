Instructions To Build Package
===================

- Open the package project (file ending with '.Rproj') by double clicking it
- Install any missing dependancies for the package by using the renv.lock file in the package:
```r
# If you don't have renv as an R library you need to install it:
install.packages("renv")

# renv will create an environemnt with all the R libraries and versions that
# were used by the original study developer (this is handy if the study needs to be run 
# in the future when new versions are available and may have different code that 
# causes a study to break)

# Build the local library into the project (takes a while):
renv::init()

# (When not in RStudio, you'll need to restart R now)

```
- Build the package by clicking the R studio 'Install and Restart' button in the build tab (top right)

- NOTE: When sharing a package on github make sure to remove the renv folder and delete the renv activation in the .rProfile file first.


