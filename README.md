## Welcome to Ecomics Replication Station.

The page is for anyone who wants to replicate the results published in [Kim et al. (2016)](https://www.nature.com/articles/ncomms13090)

### Dependencies

- [R 3.4.0 or above](https://www.r-project.org/)
- [ggplot2](http://ggplot2.org/)
- [glmnet](https://cran.r-project.org/web/packages/glmnet/index.html)
- e1071
- infotheo
- ROCR
- caret

### Replication of Published Results

Download the datasets from the link [here](https://www.dropbox.com/sh/lqzyd6dzmg1a2c4/AADHqUbNXzKyya_tNQOHN__Wa?dl=0) and name `transcriptome.no_avg.v8.txt`, `transcriptome.no_avg.v9.csv` as `CorrectEcomics.txt` and `WrongEcomics.csv`, respectively, placing them in the folder named `Dataset`.

First execute R and in the R console, type the apropriate commands below.

```R
source("run.R") # load functions
```

#### 1) Reproduce Fig. S5a.

The quick way to demonstrate the correct dataset and the wrong dataset is to check the percentage of profiles with MG1655 and BW25113. For this, type the following commands.  

```R
dataset.correct<-readTranscriptome("Dataset/CorrectEcomics.txt")
dataset.wrong<-readTranscriptome("Dataset/WrongEcomics.csv")
conds.correct<-showConditions(dataset.correct)
conds.wrong<-showConditions(dataset.wrong)
# percentage of profiles of MG1655 in the correct dataset
sum(na.omit(conds.correct[,1]=="MG1655"))/nrow(conds.correct)
# percentage of profiles of MG1655 in the wrong dataset
sum(na.omit(conds.wrong[,1]=="MG1655"))/nrow(conds.wrong)
# percentage of profiles of BW25113 in the correct dataset
sum(na.omit(conds.correct[,1]=="BW25113"))/nrow(conds.correct)
# percentage of profiles of BW25113 in the wrong dataset
sum(na.omit(conds.wrong[,1]=="BW25113"))/nrow(conds.wrong) 
```

And compare the numbers to what was reported in Section 3.2.2 in SOM in Kim et al.

#### 2) Reproduce Fig. S5b.

```R
drawCV("Dataset/CorrectEcomics.txt","FigS5.CorrectEcomics.pdf","FigS5")
drawCV("Dataset/WrongEcomics.csv","FigS5.WrongEcomics.pdf","FigS5")
```

#### 3) Reproduce Fig. S10a.

```R
drawCV("Dataset/CorrectEcomics.txt","FigS10a.CorrectEcomics.pdf","FigS10a")
drawCV("Dataset/WrongEcomics.csv","FigS10a.WrongEcomics.pdf","FigS10a")
```

#### 4) Reproduce Fig. S12.

```R
drawCV("Dataset/CorrectEcomics.txt","FigS12.CorrectEcomics.pdf","FigS12")
drawCV("Dataset/WrongEcomics.csv","FigS12.WrongEcomics.pdf","FigS12")
```

#### 5) Reproduce Table 1

```R
reproduceTable1("Dataset/CorrectEcomics.txt")
reproduceTable1("Dataset/WrongEcomics.csv")
```

#### 6) Reproduce Fig. S25.

```R
predictGrowthPhase("Dataset/CorrectEcomics.txt")
predictGrowthPhase("Dataset/WrongEcomics.csv")
```

#### 6) Reproduce Fig. S27.

Coming soon.

### Support or Contact

If you have any questions on this page, please contact Minseung Kim (msgkim@ucdavis.edu).
