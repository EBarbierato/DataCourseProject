# DataCourseProject
Getting and Cleaning Data Course Project

The script, run_analysis.R, works as follows:

1) The first part initializes some constants (used later) and declare the usage of the reshape2 library. This is necessary since the script uses the melt and  dcast functions;
2) If the zip file does not exists in the local directory (you must use the setwd command from the RStudio prompt if you want to change location), then it is downloaded;
3) if the data folder does not exist, the zip file is decompressed;
4) For each dataset, both the activities and the features information are loaded;
5) Both the dataset are loaded, but only partially. Only the columns related to the mean and standard deviation are considered, the others are ignored;
6) For both the datasets, the datete regarding the subjects and the activities are loaded;
7) The columns obtained earlier are merged with the columns of each dataset;
8) At this poijnt, the two datasets can be merged;
9) The interesting columns (activities and subjects) are converted in factors;
10) The output file is stored. Its content concerns the mean calculated for each variable referred to (Subject, Activity);
11) A message reminding that the calculation is ended is produced, together with the created file.
