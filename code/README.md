My code directory is divided into 3:
- [qsub](code/qsub): This folder comprises of the first part steps of the analysis which were qsub scripts i.e., a script file for submission of jobs on the CRG cluster that uses Univa Grid Engine batch queuing system.
- [bash](code/bash): This includes some idependant bash scripts that were not written as part of the qsub scripts. They are however run and scheduled from the qsub scripts.
- [R](code/R): Comprises of R code that was used to perform the last part of the analysis i.e part of code for the mbmixture scripts, all statistical analysis done in the study and scripts for plotting the results.
- An additional folder [notebooks](https://github.com/Kauthar-Omar/Allocoprophagy_prj/tree/main/notebooks) contains an Rmarkdown file with code on the accessing effect of experimental factors on proportion of the host (rat) read analysis.

- #### Analysis workflow diagram

- <img width="652" alt="Screenshot 2023-11-14 at 10 36 06" src="https://github.com/Kauthar-Omar/Allocoprophagy_prj/assets/57720624/be1f059e-7be0-4ae4-804a-3f52a1b23498">
