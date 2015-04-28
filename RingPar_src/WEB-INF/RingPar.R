################################################################################
# Copyright (C) 2009+ Aleksandr B. Sahakyan (aleksahak[at]cantab.net).         #
#                                                                              #
# License: You may redistribute this source code (or its components) and/or    #
#   modify/translate it under the terms of the GNU General Public License      #
#   as published by the Free Software Foundation; version 2 of the License     #
#   (GPL2). You can find the details of GPL2 in the following link:            #
#   https://www.gnu.org/licenses/gpl-2.0.html                                  #
################################################################################

IsThisWebServer=TRUE

#principalterm  = "NSC" ## or "ANSC"  -- the term for which the fittings are required
#nucleus        = "H"         ## or "C", "N", or "O" -- nucleus type to get parameters for
#adjacency      = "ALL"       ## or "ALL", "NONH", "NONHbondedH", "hbonded", "adj" or "spatial" -- arrangement types
#depmode        = "RCEF"      ## or "RC" or "EF"
#method         = "HM"        ## or "P"           -- ring current model to be used

#fittingmode    = "joint"     ## or "separate"
#donotprintcorline = FALSE  ##


####
if(principalterm=="NSC"){Principal.term = "RingCurNS"} else {Principal.term = "RingCurNSA"}
####
if(depmode=="RCEF"){Dep.mode.ind <- "RCEF"; Dep.mode="RCEF"}
if(depmode=="RC")  {Dep.mode.ind <-   "RC"; Dep.mode="NOEF" }
if(depmode=="EF")  {Dep.mode.ind <-   "EF"; Dep.mode="NORC" }
####
if(donotprintcorline==TRUE){
  corline        <- FALSE       ## or TRUE, wheather to plot correlation lines as well
} else {
  corline        <- TRUE 
}
####


prefix <- NULL ; if(IsThisWebServer==TRUE){prefix <- "../../../"} 
load(paste(prefix, "NuclAcid_df.Rdata", sep=""))    ## the dataframe for multiple fiting


###############################################################################
###############################################################################
DoFit <- function(Principal.term="RingCurNS", Method="HM", Nucleus="H",Adjacency="NONH", Color.scheme=c("#0000CC20","#00CC0050","#FF000060"), Data=NuclAcid.df, Fitting.mode="joint", Dep.mode="XXXX",corline=TRUE, exacttype=NULL, pch=8, lwd=1){

  Method <- Method
  Nucltypes <- c("C2","C4","C5","C6","C8",
                 "C2","C4","C5","C6","C8",
                 "C2","C4","C5","C6",
                 "C2","C4","C5","C6",
                 "H2","H61","H62","H8",
                 "H1","H21","H22","H8",
                 "H3","H5","H6",
                 "H41","H42","H5","H6",
                 "N1","N3","N6","N7","N9",
                 "N1","N2","N3","N7","N9",
                 "N1","N3",
                 "N1","N3","N4",
                 "O6",
                 "O2","O4",
                 "O2")
  Basetypes <- c("A","A","A","A","A",
                 "G","G","G","G","G",
                 "U","U","U","U",
                 "C","C","C","C",
                 "A","A","A","A",
                 "G","G","G","G",
                 "U","U","U",
                 "C","C","C","C",
                 "A","A","A","A","A",
                 "G","G","G","G","G",
                 "U","U",
                 "C","C","C",
                 "G",
                 "U","U",
                 "C")
  rc.names <- c("GHM6.A", "GHM5.A",
                "GHM6.G", "GHM5.G",
                "GHM6.C", "GHM6.U",
                "GP6.A", "GP5.A",
                "GP6.G", "GP5.G",
                "GP6.C", "GP6.U")

  # B. The ring current geometric factors from each of the ring types but acting on 
  #    each of the nucleus type:
  #    GXXN.B.Nu2.B2 -- XX-method, N-ring size, B- basetype of ring current origin,
  #                     Nu2- nucleus type on which the ring current acts,
  #                     B2- the basetype which holds that Nu2 nucleus =>
  #                     Nu2 and B2 are the complete atom type specifications.
  rc.indnames <- NULL
  for(i in 1:length(Nucltypes)){
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM5.A.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM6.A.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP5.A.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP6.A.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM5.G.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM6.G.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP5.G.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP6.G.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM6.U.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP6.U.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GHM6.C.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
    eval(parse(text=paste("rc.indnames <- c(rc.indnames, 'GP6.C.",
                          Nucltypes[i],".",Basetypes[i],"')",sep="")))
  }; rm(i)

  # C. Initializing the electric fields specific to each of the atom type.
  #    Name convention: EF.Nu2.B2
  EF.terms <- NULL
  for(i in 1:length(Nucltypes)){
    eval(parse(text=paste("EF.terms <- c(EF.terms,   'EF.",
               Nucltypes[i],".",Basetypes[i],"')",sep="")))
  }; rm(i)

  # Filtering EF.terms according to the nucleus types:
  nuc.ind <- NULL
  split.EF.terms <- strsplit(EF.terms,"")
  for(i in 1:length(split.EF.terms)){
    if(split.EF.terms[[i]][4]==Nucleus){nuc.ind <- c(nuc.ind,i)}
  };rm(i)
  EF.terms <- EF.terms[nuc.ind]


  if(Adjacency=="NONH"){
    Data <- Data[-which(Data$Adjacency=="hbonded"),]
  }
  if(Adjacency=="hbonded"){
    Data <- Data[which(Data$Adjacency=="hbonded"),]
  }
  if(Adjacency=="adj"){
    Data <- Data[which(Data$Adjacency=="adj"),]
  }
  if(Adjacency=="spatial"){
    Data <- Data[which(Data$Adjacency=="spatial"),]
  }
  if(Adjacency=="NONHbondedH"){
    # removing only the nuclei in the hbonded states which participate in hydrogen bonding
    remove <- c(which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="H61"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="H62"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="N6"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="C6"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="N1"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="C2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="H2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="A" & Data$Nucleus=="N7"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="O6"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="C6"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="N1"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="H1"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="C2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="N2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="H21"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="H22"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="G" & Data$Nucleus=="N7"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="U" & Data$Nucleus=="N3"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="U" & Data$Nucleus=="H3"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="U" & Data$Nucleus=="O2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="U" & Data$Nucleus=="C2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="N4"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="H41"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="H42"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="C4"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="N3"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="C2"),
                which(Data$Adjacency=="hbonded" & Data$Pbase=="C" & Data$Nucleus=="O2"))
    Data <- Data[-remove,]
  }
 
  Data <- Data[which(Data$Atom==Nucleus),]

  if(!is.null(exacttype[1])){
    Data <- Data[which(Data$Nucleus==exacttype[1] & Data$Pbase==exacttype[2]),]
  }
  
  if(Method=="HM" & Fitting.mode=="joint"){
    rc.terms <- rc.names[1:6]
  }
  if(Method=="P" & Fitting.mode=="joint"){
    rc.terms <- rc.names[7:12]
  }
  if(Fitting.mode=="separate"){
   # # # #
   FUN.rcind <- function(i){
     line <- unlist(strsplit(i,""))
     if(line[2]==unlist(strsplit(Method,""))[1] & line[(which(line==".")+1)[2]]==Nucleus){
       return(i)
     } else {
       return(NA)
     }
   }
   # # # #
    # automatically accounts Nucleus and Method
    rc.terms <- sapply(rc.indnames, FUN.rcind, simplify=TRUE, USE.NAMES=FALSE)
    rc.terms <- rc.terms[!is.na(rc.terms)]
  }

  text <- paste("lmfit.",Nucleus," <- lm(",Principal.term,"~",sep="")
  
  if(Dep.mode!="NORC"){
    for(i in rc.terms){
      text <- paste(text,"+",i,sep="")
    };rm(i)
  }
  if(Dep.mode!="NOEF"){
    for(i in EF.terms){
      text <- paste(text,"+",i,sep="")
    }
  }
  text <- paste(text,"-1,data=Data,)",sep="")

  eval(parse(text=text))

  col <- sapply(as.character(Data$Adjacency),FUN=function(i){
                                              if(i=="adj"){
                                                return(Color.scheme[1])
                                              };
                                              if(i=="spatial"){
                                                return(Color.scheme[2])
                                              };
                                              if(i=="hbonded"){
                                                return(Color.scheme[3])
                                              }
                                             },
                                             simplify=TRUE, USE.NAMES=FALSE)

  x <- Data$RingCurNS
  xlab <- paste("DFT ",Principal.term,"s",sep="")
  eval(parse(text=paste("y <- lmfit.",Nucleus,"$fitted.values",sep="")))
  eval(parse(text=paste("SE <- sd(lmfit.",Nucleus,"$residuals)",sep="")))
  ylab <- paste("Fitted ",Principal.term,"s",sep="")
  main <- paste(Method,"_",Nucleus,"_",Adjacency,"_",Fitting.mode,"_",
                Dep.mode,"_",round(cor(x,y),3),"_",round(SE,3),sep="")


  plot(x=x, xlab=xlab, y=y, ylab=ylab, cex=0.5, pch=pch, col=col, main=main, lwd=lwd)
  if(corline==TRUE){     
    abline(lm(y~x), lty="dashed")
  }

  eval(parse(text=paste("lmfit <- lmfit.",Nucleus,sep="")))

  if(length(grep("coefficients.txt", dir()))==1){
    append <- TRUE
  } else {
    append <- FALSE
  }

  write(paste("#### FITTING INFO:   ",main,sep=""), file="coefficients.txt", append=FALSE) #or =append!
  write(paste(names(lmfit$coefficients), collapse="  "), file="coefficients.txt", append=TRUE)
  write(paste( lmfit$coefficients , collapse="  "), file="coefficients.txt", append=TRUE)
  write("  ",file="coefficients.txt", append=TRUE)
  write("  ",file="coefficients.txt", append=TRUE)
  
  #write(c("plot.jpg","coefficients.txt"), file="result_files.txt")
  return(lmfit)

}
###############################################################################
###############################################################################




#filename <- paste(Principal.term,"_",
#                  nucleus,"_",
#                  method,"_",
#                  fittingmode,"_",
#                  Dep.mode.ind,"_",
#                  adjacency,".jpg",sep="")
jpeg(quality=100, width=450, height=450, filename="plot.jpg")
  lmfit <- DoFit(Principal.term=Principal.term, Method=method, Nucleus=nucleus, 
  Adjacency=adjacency, Fitting.mode=fittingmode, Dep.mode=Dep.mode, pch=19, corline=FALSE)
dev.off()

