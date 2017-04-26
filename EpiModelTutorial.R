### Brand Ogbunugafor Lecture
### 21 March 2017
### ELK

# Downloaded and loaded EpiModel package
install.packages("EpiModel", dependencies = TRUE)
library(EpiModel)

# deterministic, compartmental models (DCMs)
param <- param.dcm(inf.prob = 0.2, act.rate = 0.25) # epidemic model parameters entered # inf.prob is the probability of arguments # act.rate is the rate of acts (transmission events over time)
init <- init.dcm(s.num = 500, i.num = 1) # init.dcm is the initial state of the system 
control <- control.dcm(type = "SI", nsteps = 500) # structural model controls such as time intervals and model type

# inputting parameters, initial conditions, controls into dcm and saved as mod which is the output of dcm
mod <- dcm(param, init, control)

# printing mod gives the model output
# mod
# EpiModel Simulation
# =======================
#   Model class: dcm
# 
# Simulation Summary
# -----------------------
#   Model type: SI
# No. runs: 1
# No. time steps: 500
# No. groups: 1
# 
# Model Parameters
# -----------------------
#   inf.prob = 0.2
# act.rate = 0.25
# 
# Model Output
# -----------------------
#   Variables: s.num i.num si.flow num

# graphing mod
plot # compartments are discrete disease states and flows are transmission from disase states 
# i.num is the infected population size at each time step
# si.flow is the numebr of people moving from susceptible to infected (i.e. infection rate)

#Determining the size of copartments at a particular time step (in this case, 150)
# gives the summary at this time step in terms of total of susceptible and infected individuals
# summary(mod, at = 150)
# EpiModel Summary
# =======================
#   Model class: dcm
# 
# Simulation Summary
# -----------------------
#   Model type: SI
# No. runs: 1
# No. time steps:
#   No. groups: 1
# 
# Model Statistics
# ------------------------------
#   Time: 150	 Run: 1 
# ------------------------------ 
#   n    pct
# Suscept.  112.845  0.225
# Infect.   388.155  0.775
# Total     501.000  1.000
# S -> I      4.311     NA
# ------------------------------ 

##################################################################
# SIR model with demography
# adding birth and death rates, recovery rate, state-specific death rate
# di.rate is teh death rate of infected individuals 
# init.dcm is the number of initially recovered individuals 
param <- param.dcm(inf.prob = 0.2, act.rate = 1, rec.rate = 1/20,
                   b.rate = 1/95, ds.rate = 1/100, di.rate = 1/80, dr.rate = 1/100)
init <- init.dcm(s.num = 1000, i.num = 1, r.num = 0)

# plotting this model
# popfrac=FALSE plots compartment size
par(mar = c(3.2, 3, 2, 1), mgp = c(2, 1, 0), mfrow = c(1, 2))
plot(mod, popfrac = FALSE, alpha = 0.5,
     lwd = 4, main = "Compartment Sizes")
plot(mod, y = "si.flow", lwd = 4, col = "firebrick",
     main = "Disease Incidence", leg = "n")
control <- control.dcm(type = "SIR", nsteps = 500, dt = 0.5)
mod <- dcm(param, init, control)

# summary of this model
par(mfrow = c(1, 1))
comp_plot(mod, at = 50, digits = 1) # makes a flow chart 
