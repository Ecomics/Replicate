## Welcome to Ecomics Replication Station.

The page is for anyone who wants to replicate the results published in Kim et al. 2016. 

### Dependencies

- [R 3.4.0 or above](https://www.r-project.org/)
- [ggplot2](http://ggplot2.org/)
- [glmnet](https://cran.r-project.org/web/packages/glmnet/index.html)

### Replication of Published Results

First execute R and in the R console, type the apropriate commands below.

#### 1) Reproduce Fig S5.

```R
source("run.R")
drawCV("Dataset/CorrectEcomics.txt","FigS5.CorrectEcomics.pdf","FigS5")
drawCV("Dataset/WrongEcomics.csv","FigS5.WrongEcomics.pdf","FigS5")
```

#### 2) Reproduce Fig S10a.

```R
source("run.R")
drawCV("Dataset/CorrectEcomics.txt","FigS10a.CorrectEcomics.pdf","FigS10a")
drawCV("Dataset/WrongEcomics.csv","FigS10a.WrongEcomics.pdf","FigS10a")
```

#### 3) Reproduce Fig S12.

```R
source("run.R")
drawCV("Dataset/CorrectEcomics.txt","FigS12.CorrectEcomics.pdf","FigS12")
drawCV("Dataset/WrongEcomics.csv","FigS12.WrongEcomics.pdf","FigS12")
```

#### 4) Reproduce Table 1

```
source("run.R")
reproduceTable1("Dataset/CorrectEcomics.txt")
reproduceTable1("Dataset/WrongEcomics.csv")
```

### Support or Contact

If you have any questions on this page, please contact Minseung Kim (msgkim@ucdavis.edu).
