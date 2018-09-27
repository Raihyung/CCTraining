## Group x Time ANOVA examining training effects on the mean degree of networks

dat <- read.csv("Degree.csv", sep = ",", header = FALSE) # load degree 
demo <- read.csv("Demo.csv", sep = ",", header = TRUE) # load demographic

library(ggplot2); library(reshape); library(nlme)

participant <- 1:51
group <- demo$group
combined <- cbind(participant, group, dat)

pval <- c()

fpnpre <- 2+46*0
fpnpost <- 2+46*1
conpre <- 2+46*2
conpost <- 2+46*3
dmnpre <- 2+46*4
dmnpost <- 2+46*5
cbnpre <- 2+46*6
cbnpost <- 2+46*7


# Group x Time ANOVA across network densities
for (i in 1:46) {
  
  final <- combined[,c(1,2,i+conpre,i+conpost)]  # or fpnpre/fpnpost, dmnpre/dmnpost, cbnpre/cbnpost
  head(final)
  
  colnames(final) <- c("participant", "group", "pre", "post")
  df <- melt(final, id = c("participant", "group"), measured = c("pre", "post"))
  
  colnames(df) <- c("participant", "group", "time", "value")
  head(df)
  
  baseline <- lme(value ~ 1, random = ~1|participant/time, data = df, method = "ML")
  timeM <- update(baseline, .~. + time)
  groupM <- update(timeM, .~. + group)
  time_group <- update(groupM, .~. + time:group)
  
  pval[i] <- anova(baseline, timeM, groupM, time_group)$p[4]
  
  plot(pval)
  
}




