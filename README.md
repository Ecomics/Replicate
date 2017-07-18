## Welcome to Ecomics Replication Station.

The page is for anyone who wants to replicate the results published in Kim et al. 2016. 

### Dependencies

- [R 3.4.0 or above](https://www.r-project.org/)
- [ggplot2](http://ggplot2.org/)

### Replication of Published Results

## Fig S5.

```R
source("run.R")
drawCV("Dataset/CorrectEcomics.txt","FigS5.CorrectEcomics.pdf")
drawCV("Dataset/WrongEcomics.csv","FigS5.WrongEcomics.pdf")
```

### Support or Contact

If you have any questions on this page, please contact Minseung Kim (msgkim@ucdavis.edu).
