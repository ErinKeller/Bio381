### Morgan Southgate Presentation - EcoSimR
### 19 April 2017
### ELk

### Introduction
# looks at null model analysis of ecological data
# species co-occurence analysis, size analysis, evaluate niches, etc.
# History
# Diamond (1975) - 1) forbidden species combinations due to interspecific competition 2) checkerboard pairs particular pairs may never co-occur due to interspecific comp
# Connor & Simberloff (1979) - introduced null models 
# presence/absence matrix - columns = sites rows = species

# co-occurence indices
# checker - # species to have a perfect checkerboard distribution
# c score - 
#V ratio - measures variability in the number of species/site
# combo index - count of the number of unique species combinations

# null model algorithms 
# 3 constraints^2 dimensions of a matrix -> 9 basic models


install.packages("EcoSimR")
library("MASS")
library("reshape2")

# read in associated species data 
sppDat <- read.table("AssociatedSppData_Serp.csv",header=TRUE,sep=",",stringsAsFactors = FALSE)
head(sppDat)

# reshape data using dcast function in reshape2 package
library(reshape2)
PA <- dcast(sppDat,formula=SpeciesName~SitePatch)
head(PA)

dim(PA)

library(EcoSimR)
library(MASS)
# Run null model with SIM9 algorithm & CHECKER index
adMod1 <- cooc_null_model(PA,algo= "sim9",metric="checker",nReps=1000,suppressProg=T)

# Summary and plots
summary(adMod1)

mean(adMod1$Sim)

plot(adMod1,type="hist")

plot(adMod1,type="cooc")

plot(adMod1,type="burn_in")

# Run null model with SIM2 algorithm and C score index
adMod4 <- cooc_null_model(PA,algo= "sim2",metric="c_score",nReps=1000)

# Summary and plots
summary(adMod4)
plot(adMod4,type="hist")
plot(adMod4,type="cooc")

