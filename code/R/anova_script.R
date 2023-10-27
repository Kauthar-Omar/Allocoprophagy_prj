# Inputs
# a data frame with sampleIDs, prop_host_read, sex, material, fasted, phenotyping center
#your_data 
load('/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/comp_tab_all_deep.RData')

# Define the covariates
covariates=c("Sex", "Material", "Fasting_state", "Phenotyping_center")
# seemed like sex wasn't really relevant, consider the possibility of excluding it
# 1. Do with all covariates together
# 2. Do with each one of the covariates alone - can just loop on `covariates`
# 3. Do for pairs of covariates, e.g. covariates = c("material", "fasted"); then covariates = ("fasted", "phenotyping_center") etc. 

# Calculate ANOVA

anova_total=data.frame()

# To do the anova, at each time you define the formula where:
# the independent variable (prop_host_read) is a function (~) of the covariates (e.g. sex + material + fasted + phenotyping_center)
formula <- as.formula(paste("Proportion_Host_Reads_From_Paired_Trimmed ~", paste(covariates, collapse = " + ")))
# Get the results form the anova
#anova.data <- summary(aov(formula, data = comp_tab_all_deep))

# From results we are interested in the 1st table 
#anova.data=anova.data[[1]]
# Basically you should get a table that tells you how much of the variation you see in the proportion of reads is explained by the sex, material... 
# and by residual (that is other unknown factors)
# Look at the F and P.val, when the F is > 0 means it's relevant and that covariate explains part of the variation between groups

# Here we calculate the R_squared - tells how much the proportion is explained by each category
#anova.data$R2=anova.data$`Sum Sq`/sum(anova.data$`Sum Sq`)


my_anova <- function(indep_var, covariates, comp_tab_all_deep){
  formula <- as.formula(paste(indep_var, " ~", paste(covariates, collapse = " + ") ) )
  #formula <- as.formula(paste("Proportion_Host_Reads_From_Paired_Trimmed ~", paste(covariates, collapse = " + ") ) )
  anova.data <- aov(formula, data = comp_tab_all_deep)
  #anova.data <- summary(aov(formula, data = comp_tab_all_deep))
  #anova.data=anova.data[[1]]
  #anova.data$R2=anova.data$`Sum Sq`/sum(anova.data$`Sum Sq`)
  return(anova.data)
}

anova.data <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed",covariates, comp_tab_all_deep)

covariates2=c("Material", "Fasting_state", "Phenotyping_center")
anova.data2 <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed",covariates2, comp_tab_all_deep)

covariates3=c("Material", "Fasting_state", "Sex")
anova.data3 <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed",covariates2, comp_tab_all_deep)

anova.data4 <-my_anova("Proportion_Host_Reads_From_Paired_Trimmed","Fasting_state", comp_tab_all_deep)

anova.data5 <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed","Phenotyping_center", comp_tab_all_deep)

anova.data6 <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed","Material", comp_tab_all_deep)

anova.data7 <- my_anova("Proportion_Host_Reads_From_Paired_Trimmed","Sex", comp_tab_all_deep)

anova_total=rbind(anova.data, anova.data2, anova.data3, anova.data4, anova.data5 , anova.data6, anova.data7)

library(ggplot2)
library(ggpubr)

#install.packages('tidyverse')
library(tidyverse)
library(broom)

#install.packages('AICcmodavg')
library(AICcmodavg)

model.set <- list(anova.data, anova.data5 , anova.data6)
model.names <- c('anova.data', 'anova.data5' , 'anova.data6')

aictab(model.set, modnames = model.names)

par(mfrow=c(2,2))
plot(anova.data)

par(mfrow=c(2,2))
plot(anova.data5)

par(mfrow=c(2,2))
plot(anova.data6)


lm_alt = lm(comp_tab_all_deep$Proportion_Host_Reads_From_Paired_Trimmed ~ 1 + comp_tab_all_deep$Sex)

lm_null = lm(comp_tab_all_deep$Proportion_Host_Reads_From_Paired_Trimmed ~ 1)

anova(lm_alt)

?anova

t.test(comp_tab_all_deep[comp_tab_all_deep$Sex = 'Male','Proportion_Host_Reads_From_Paired_Trimmed'],comp_tab_all_deep[comp_tab_all_deep$Sex = 'Female','Proportion_Host_Reads_From_Paired_Trimmed'])

?aov


x <- c(2.9, 3.0, 2.5, 2.6, 3.2) # normal subjects
y <- c(3.8, 2.7, 4.0, 2.4)      # with obstructive airway disease
z <- c(2.8, 3.4, 3.7, 2.2, 2.0)

kruskal.test(list(x, y, z))


formula4 <- as.formula(paste("Proportion_Host_Reads_From_Paired_Trimmed ~ Fasting_state"))
?kruskal.test
?kruskal.test.default
?kruskal.test.formula
kruskal.data1 <- kruskal.test(formula, data = comp_tab_all_deep)
#kruskal.data4 <-  kruskal.data4[[1]]
#anova.data4$R2=anova.data4$`Sum Sq`/sum(anova.data4$`Sum Sq`)
test2 <- data.frame(H = kruskal.data4$statistic, df = kruskal.data4$parameter, p.value = kruskal.data4$p.value, row.names = "Fasting_state")

kruskal_total=data.frame()

my_kruskal <- function(indep_var, covariates, data) {
  formula <- as.formula(paste(indep_var, " ~", paste(covariates, collapse = " + ") ) )
  kruskal.data <- kruskal.test(formula, data = data)
  kruskal_dataframe <- data.frame(H = kruskal.data$statistic, df = kruskal.data$parameter, p.value = kruskal.data$p.value, row.names = covariates)
  return(kruskal_dataframe)
}

kruskal.data1 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed",comp_tab_all_deep$"s+m+f+p", comp_tab_all_deep)

covariates2=c("Material", "Fasting_state", "Phenotyping_center")
kruskal.data2 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed",comp_tab_all_deep$"s+m+f", comp_tab_all_deep)

covariates3=c("Material", "Fasting_state")
kruskal.data3 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed",comp_tab_all_deep$"s+m", comp_tab_all_deep)

kruskal.data4 <-my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed","Fasting_state", comp_tab_all_deep)

kruskal.data5 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed","Phenotyping_center", comp_tab_all_deep)

kruskal.data6 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed","Material", comp_tab_all_deep)

kruskal.data7 <- my_kruskal("Proportion_Host_Reads_From_Paired_Trimmed","Sex", comp_tab_all_deep)

kruskal_total=rbind(kruskal.data1, kruskal.data4, kruskal.data5 , kruskal.data6, kruskal.data7)


# Define the covariates
covariates <- c("Sex", "Material", "Fasting_state")

# Create a subset of the data with the required variables
subset_data <- comp_tab_all_deep[c("Proportion_Host_Reads_From_Paired_Trimmed", covariates)]

# Perform Kruskal-Wallis test for each covariate
kruskal_data <- lapply(covariates, function(covariate) {
  kruskal.test(subset_data$Proportion_Host_Reads_From_Paired_Trimmed ~ subset_data[[covariate]])
})

# Access the results for each covariate
for (i in seq_along(covariates)) {
  cat("Covariate:", covariates[i], "\n")
  print(kruskal_data[[i]])
  cat("\n")
}


covariates=c("Sex", "Material", "Fasting_state", "Phenotyping_center")

# Create a new combined factor variable
comp_tab_all_deep$s_m_f_p <- interaction(comp_tab_all_deep[covariates], drop = TRUE)

# Perform Kruskal-Wallis test using the combined grouping variable
kruskal.data <- kruskal.test(Proportion_Host_Reads_From_Paired_Trimmed ~ s_m_f_p, data = comp_tab_all_deep)

kruskal.data1 <- data.frame(H = kruskal.data$statistic, df = kruskal.data$parameter, p.value = kruskal.data$p.value, row.names = "s_m_f_p")

# Print the resul
print(kruskal_data)

