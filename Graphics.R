# Basic graphics

###################################################
# use "0" matrix entries for no plot
# use multiple matrix entries for expanded plot regions

layout(matrix(c(1,1,1,2,0,3),nrow=2,byrow=TRUE))
layout.show(3)

my.layout(6)

###################################################
# use all of this to combine graphic elements

# set up plotting regions

par(opar)
layout(matrix(c(2,0,1,3),nrow=2,byrow=TRUE),
       heights=c(1,8),widths=c(8,1))
layout.show(3)

########################################################
# create some skewed data and sort it
x <- sort(rgamma(100,shape=2,scale=1))
y <- sort(rgamma(100,shape=2,scale=1),decreasing=TRUE)

########################################################
# generate the basic scatterplot
par(mar=c(4,5,0,0))
plot(x,y,ann=FALSE,cex=2,pch=21,bg="cornflowerblue")

par(mar=c(0,5,0,0))
#par(bty="n")
#par(xaxt="n")


boxplot(x,names=FALSE,horizontal=TRUE,col="cornflowerblue")
par(mar=c(4,0,0,0))

#par(yaxt="n")
boxplot(y,names=FALSE, horizontal=FALSE,col="cornflowerblue")


par(opar)
set.seed(102)

####################################################
# create a stochastic increasing time series

x <- 1:1000
y <- rgamma(1000,shape=2,scale=1) + 0.01*x

###################################################
# select a time slice for plotting
slice <- 300:450

# create the main graph

par(mar=c(5,6,1,1))
plot(x[slice],y[slice],xlim=range(slice),col="gray",type="l",
     xlab="Time",ylab="Temperature",
     font.lab=2,cex.lab=1.5,las=1,ylim=range(y[slice]))

##################################################################
#add par commands to strip margins, overplot, and place the inset

par(new=TRUE) # overlay existing plot
par(mar=c(0,0,0,0)) # strip out the margins for the inset plot
par(fig=c(0.4,0.7,0.80,0.94)) # fig shrinks and places relative to figure region to range specified in parentheses 

#################################################################
# separately create the inset graph

plot(x,y,type="l",ann=FALSE)
rect(slice[1],-1,slice[length(slice)],1000,col="gray",border=NA)
box()
lines(x,y)

###############################################
# adjusting colors for transparency
# first, with no adjustment
x1 <- rnorm(100,0,1)
x2 <- rnorm(100,2,1)

hist(x1,xlim=range(c(x1,x2)),ylim=c(0,35),
     col="red",breaks=seq(-4,6,by=0.5))
par(new="TRUE")

hist(x2,xlim=range(c(x1,x2)), ylim=c(0,35),
     axes=FALSE,ann=FALSE,
     col="blue",breaks=seq(-4,6,by=0.5))

par(opar)

# now adjust the blue to 50% transparency
my.blue <- adjustcolor("blue",alpha.f=0.5)

hist(x1,xlim=range(c(x1,x2)),ylim=c(0,35),
     col="red",breaks=seq(-4,6,by=0.5))

par(new="TRUE")

hist(x2,xlim=range(c(x1,x2)), ylim=c(0,35),
     axes=FALSE,ann=FALSE,col=my.blue,
     breaks=seq(-4,6,by=0.5)) # my.blue not in quotes! otherwise recognized as character string


par(mar=c(5,6,4,2)+0.1)
par(pty="s")

# create data
x <- 1:100
Exp <- 50 + x*0.1
Con.High <- Exp + 5 + rnorm(100)
Con.Low <- Exp - 5 + rnorm(100)
One.Run <- Exp + rnorm(100,0,2)

# create plot
plot(Exp~x,type="l",
     xlab= "Time Step",
     ylab="Populatioh Size (N)",
     lty="dashed",
     ylim=range(One.Run,Exp,Con.High,Con.Low),
     cex.lab=1.5,las=1,cex.axis=1.5)

# add polygon and overplot the lines
polygon(c(x,rev(x)),c(Con.Low,rev(Con.High)),col="thistle",border=NA)
lines(x,Exp,lty="solid",col="purple",lwd=1.5)
lines(x,One.Run)


