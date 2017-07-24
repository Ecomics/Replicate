library(glmnet)
library(e1071)
library(infotheo)
library(ROCR)
library(caret)

getExponentialData <- function(a) {
	meta<-read.table("Dataset/Meta.txt",header=T,sep="\t")
    w<-NULL
    for (i in 1:nrow(a)) {
        gphase<-as.character(meta[match(a[i,"ID"],meta$ID),"Growth.Phase"])
        if (!is.na(gphase) && (gphase == "exponential" || gphase == "mid-exponential" || gphase == "exponential (predicted)"))
			w<-append(w,i)
    }
    return(a[w,])
}

readTranscriptome <- function(f) {
	a<-NULL
	if (f == "Dataset/WrongEcomics.csv") {
		a<-read.table(f,header=T,sep=",")
		meta<-read.table("Dataset/Meta.txt",header=T,sep="\t")
		cond<-NULL
		for (i in 1:nrow(a)) {
			cond<-append(cond,as.character(meta$Cond[match(a[i,"ID"],meta$ID)]))
		}
		a<-as.data.frame(cbind(cond,a))
		colnames(a)[1]<-"Cond"
	} else {
		a<-read.table(f,header=T,sep="\t")
	}
	return(a)
}

normalizeOmics <- function(data,option) {
    l<-NULL
    a<-NULL
    d<-NULL
    if (option == "factor") {
        for (i in 1:ncol(data)) {
            if (is.factor(data[,i]))
            	l<-append(l,i)
        }
        a<-data[,l]
        d<-data[,-c(l)]
    } else {
        d<-data
    }
	d.n<-apply(d,2,function(x) (x-min(x))/(max(x)-min(x))) 
    colnames(d.n)<-colnames(d)
    d.n<-d.n[,!is.nan(d.n[1,])]
    if (option == "factor") {
    	d.n<-cbind(a,d.n)
    	colnames(d.n)<-colnames(data)
    }
    return(d.n)
}

drawCV <- function(f,o,type) {
	a<-readTranscriptome(f)
	a<-getExponentialData(a)
	a<-normalizeOmics(a,"factor")
	ucond<-unique(a[,"Cond"])
	genes<-grep("^m.b|^b",colnames(a))
	cv<-NULL
	feature<-NULL
	meta<-read.table("Dataset/Meta.Medium.txt",header=T,sep="\t")
	for (i in 1:length(ucond)) {
		m<-which(ucond[i]==a[,"Cond"])
		if (length(m) == 1)
			next
		n<-apply(a[m,genes],2,function(x) sd(x)/mean(x))
		cv<-append(cv,mean(na.omit(n)))
		t<-unlist(strsplit(as.character(ucond[i]),"[.]"))
		if (type == "FigS5")
			feature<-append(feature,t[1])
		else if (type == "FigS10a")
			feature<-append(feature,as.character(meta$Description[match(t[2],meta$ID)]))
		else if (type == "FigS10b" && t[1] == "MG1655" && t[3] == "none" && t[4] == "na_WT")
			feature<-append(feature,as.character(meta$Base.Medium[match(t[2],meta$ID)]))
		else if (type == "FigS12")
			feature<-append(feature,t[3])
	}
	
	t<-table(feature)
	p<-names(t)[t>1]
	p2<-NULL
	for (i in 1:length(p)) {
		p2<-append(p2,which(p[i]==feature))
	}
	z<-list(V1=feature[p2],V2=as.numeric(cv[p2]))
	z$V1<-with(z,reorder(V1,V2,mean))
	if (type == "FigS5" || type == "FigS10a")
		pdf(o,height=4,width=12)
	else if (type == "FigS10b")
		pdf(o,height=3,width=5)
	else if (type == "FigS12")
		pdf(o,height=4,width=9)
	boxplot(V2~V1,data=z,col="#5CA4A9",las=2)
	dev.off()
}

showConditions <- function(b) {
	cond<-NULL
	meta<-read.table("Dataset/Meta.Medium.txt",header=T,sep="\t")
    for (i in 1:nrow(b)) {
	   	t<-unlist(strsplit(as.character(b[i,"Cond"]),"[.]"))
	   	bmedium<-as.character(meta$Base.Medium[which(t[2]==meta$ID)])
	   	cond<-rbind(cond,t)
	}
	return(cond)
}

findImportantGenes <- function(f) {
	b<-readTranscriptome(f)
	#b.exp<-getExponentialData(b) # get exponential data
	#b.norm<-normalizeOmics(b.exp,"factor")
	b.norm<-b
	c<-b.norm
    p<-read.table("Dataset/Phenome.txt",header=T,sep="\t")
    
    m<-NULL
	gr<-NULL
    for (i in 1:nrow(p)) {
    	w<-which(as.character(p$Cond[i])==as.character(c$Cond))
		gr<-append(gr,rep(p$p.GR[i],length(w)))
		m<-append(m,w)
    }
	c.selected<-c[m,grep("^m.b|^b",colnames(c))]
	ag<-as.matrix(cbind(c.selected,gr))
	model<-cv.glmnet(ag[,-ncol(ag)],ag[,ncol(ag)],alpha=1)
	best.lambda<-which(model$lambda.min==model$lambda)
	w<-model$glmnet.fit$beta[,best.lambda]!=0
	return(model$glmnet.fit$beta[w,best.lambda])
}

reproduceTable1 <- function(f) {
	table1<-c("b2054","b2446","b3251","b2583","b1907","b0941","b0985","b4291","b1583","b1059")
	features<-findImportantGenes(f)
	results<-gsub("m.b","b",showTopFeatures(features))
	for (result in results) {
		cat(result,"\n")
	}
	cat("Among top 10 genes, you have ",length(intersect(table1,results))," genes in common.\n")
	rest_genes<-setdiff(table1,results)
	for (rest_gene in rest_genes) {
		cat(rest_gene," is in rank of ",which(names(features[order(-abs(features))])==rest_gene),"\n")
	}
}

showTopFeatures <- function(features) {
	return(names(features[order(-abs(features))[1:10]]))
}

predictGrowthPhase <- function(f) {
	d<-readTranscriptome(f)
    meta<-read.table("Dataset/Meta.txt",header=T,sep="\t")
    sidx<-na.omit(match(meta[meta$Growth.Phase=="stationary" | meta$Growth.Phase == "early-stationary","ID"],as.character(d[,"ID"])))
    eidx<-na.omit(match(meta[meta$Growth.Phase=="mid-exponential" | meta$Growth.Phase == "exponential","ID"],as.character(d[,"ID"])))
    uidx<-na.omit(match(meta[meta$Growth.Phase=="expoential (predicted)" | meta$Growth.Phase=="non-exponential (predicted)","ID"],as.character(d[,"ID"])))
    
    test_d<-d[c(sidx,sample(eidx,length(sidx))),-c(1,2)]
    test_y<-rep(c(0,1),c(length(sidx),length(sidx)))
    real_d<-d[uidx,-c(1,2)]

    nfold<-3
    folds<-createFolds(test_y,k=nfold)
    for (i in 1:nfold) {
        mi<-NULL
        for (j in 1:ncol(test_d)) {
                dd<-discretize(test_d[-folds[[i]],j],"equalwidth",3)
                mi<-append(mi,mutinformation(dd,test_y[-folds[[i]]]))
        }
        pm<-tune(svm,as.matrix(test_d[-folds[[i]],order(-mi)[1:50]]),as.matrix(test_y[-folds[[i]]]),probability=TRUE)
        py<-predict(pm$best.model,as.matrix(test_d[folds[[i]],order(-mi)[1:50]]),decision.values=TRUE,probability=TRUE)
        pred<-prediction(attributes(py)$decision.values, test_y[folds[[i]]])
        auc<-performance(pred,'auc')
        cat("Fold ",i," - AUC: ",auc@y.values[[1]],"\n")
        pr<-performance(pred,"prec","rec");
		aupr <-trap.rule.integral(pr@x.values[[1]][-1],pr@y.values[[1]][-1])
		cat("Fold ",i," - AUPR: ",aupr,"\n")
    }
}