#### Lineare Regression

Politeness data (B. Winter tutorial)

Programme laden


```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
```

```
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.3     v dplyr   1.0.7
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   2.0.1     v forcats 0.5.1
```

```
## Warning: package 'readr' was built under R version 4.1.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


Datei laden


```r
# LOAD
rm(list=ls(all=TRUE)) # clear memory
polite <- read.csv("data/politeness_data.csv", dec=".")
```

Ansicht der Datenlage


```r
head(polite)
```

```
##   subject gender scenario attitude frequency
## 1      F1      F        1      pol     213.3
## 2      F1      F        1      inf     204.5
## 3      F1      F        2      pol     285.1
## 4      F1      F        2      inf     259.7
## 5      F1      F        3      pol     203.9
## 6      F1      F        3      inf     286.9
```

Variablen festlegen


```r
polite$frequency = as.numeric(polite$frequency)
polite$scenario = as.factor(polite$scenario)
polite$subject = as.factor(polite$subject)
polite$gender = as.factor(polite$gender)
polite$attitude = as.factor(polite$attitude)
```

Kontraste für den statistischen Test setzen


```r
# In this session we use contr. sum contrasts
options(contrasts=c('contr.sum', 'contr.poly'))
options("contrasts")
```

```
## $contrasts
## [1] "contr.sum"  "contr.poly"
```

Kontraste zurücksetzen


```r
# To reset default settings run: 
options(contrasts=c('contr.treatment', 'contr.poly')) 
# (all afex functions should be unaffected by this)

# # Setting contrasts of chosen variables only
# contrasts(polite$attitude) <- contr.treatment(2, base = 1)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)


```r
boxplot(frequency ~ attitude*gender, 
        col=c("red","green"), data = polite)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-7-1.svg" width="672" />

Bild speichern


```r
# 1. Open jpeg file
jpeg("pictures/politeness_boxplot.jpg", 
     width = 840, height = 535)
# 2. Create the plot
boxplot(frequency ~ attitude*gender, 
        col=c("red","green"), data = polite) 
# 3. Close the file
dev.off()
```

```
## svg 
##   2
```


```r
# Open a pdf file
pdf("pictures/politeness_boxplot.pdf") 
# 2. Create a plot
boxplot(frequency ~ attitude*gender, 
        col=c("red","green"), data = polite) 
# Close the pdf file
dev.off() 
```

```
## svg 
##   2
```



```r
# Inspect relationships between pairs of variables
# library(MASS)
```

Inspect relationships between pairs of variables


```r
library(psych)
```

```
## 
## Attaching package: 'psych'
```

```
## The following objects are masked from 'package:ggplot2':
## 
##     %+%, alpha
```

```r
pairs.panels(polite[c(2,4,5)])
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-11-1.svg" width="672" />

Ordinary Least Squares Regression (OLS)


```r
# model 1
m <- lm(frequency ~ gender + attitude + subject + scenario, data = polite)
summary(m)
```

```
## 
## Call:
## lm(formula = frequency ~ gender + attitude + subject + scenario, 
##     data = polite)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -53.673 -16.686   1.039  12.027  86.630 
## 
## Coefficients: (1 not defined because of singularities)
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  225.150     10.020  22.470  < 2e-16 ***
## genderM     -129.857      9.606 -13.518  < 2e-16 ***
## attitudepol  -19.794      5.585  -3.544 0.000707 ***
## subjectF2     26.150      9.606   2.722 0.008179 ** 
## subjectF3     18.700      9.606   1.947 0.055592 .  
## subjectM3     66.800      9.606   6.954 1.52e-09 ***
## subjectM4     41.854      9.807   4.268 6.09e-05 ***
## subjectM7         NA         NA      NA       NA    
## scenario2     25.017     10.376   2.411 0.018537 *  
## scenario3     31.025     10.376   2.990 0.003847 ** 
## scenario4     42.508     10.376   4.097 0.000111 ***
## scenario5     14.408     10.376   1.389 0.169351    
## scenario6      1.405     10.629   0.132 0.895227    
## scenario7      3.117     10.376   0.300 0.764783    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 25.42 on 70 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.8716,	Adjusted R-squared:  0.8496 
## F-statistic: 39.61 on 12 and 70 DF,  p-value: < 2.2e-16
```



```r
# model 2
m <- lm(frequency ~ gender + attitude, data=polite)
summary(m)
```

```
## 
## Call:
## lm(formula = frequency ~ gender + attitude, data = polite)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -82.409 -26.561  -4.262  24.690 100.140 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  256.762      6.756  38.006   <2e-16 ***
## genderM     -108.349      7.833 -13.832   <2e-16 ***
## attitudepol  -19.553      7.833  -2.496   0.0146 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 35.68 on 80 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.7109,	Adjusted R-squared:  0.7037 
## F-statistic: 98.38 on 2 and 80 DF,  p-value: < 2.2e-16
```



```r
library(effects)
```

```
## Loading required package: carData
```

```
## lattice theme set by effectsTheme()
## See ?effectsTheme for details.
```

```r
allEffects(m)
```

```
##  model: frequency ~ gender + attitude
## 
##  gender effect
## gender
##        F        M 
## 247.1035 138.7549 
## 
##  attitude effect
## attitude
##      inf      pol 
## 203.2408 183.6875
```



```r
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-15-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)


```r
# Save plot of the effects to disk
# 1. Open jpeg file
jpeg("pictures/politeness_lineplot.jpg", 
     width = 840, height = 535)
# 2. Create the plot
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
# 3. Close the file
dev.off()
```

```
## svg 
##   2
```



```r
# model 3 (with interaction)
m <- lm(frequency ~ gender*attitude, data=polite)
summary(m)
```

```
## 
## Call:
## lm(formula = frequency ~ gender * attitude, data = polite)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -78.486 -27.383  -0.986  20.570  96.020 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)          260.686      7.784  33.491   <2e-16 ***
## genderM             -116.195     11.008 -10.556   <2e-16 ***
## attitudepol          -27.400     11.008  -2.489   0.0149 *  
## genderM:attitudepol   15.890     15.664   1.014   0.3135    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 35.67 on 79 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.7147,	Adjusted R-squared:  0.7038 
## F-statistic: 65.95 on 3 and 79 DF,  p-value: < 2.2e-16
```



```r
library(effects)
allEffects(m)
```

```
##  model: frequency ~ gender * attitude
## 
##  gender*attitude effect
##       attitude
## gender      inf      pol
##      F 260.6857 233.2857
##      M 144.4905 132.9800
```



```r
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-19-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-3.png)


```r
# Save plot of the effects to disk
# 1. Open jpeg file
jpeg("pictures/politeness_effects.jpg", 
     width = 840, height = 535)
# 2. Create the plot
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
# 3. Close the file
dev.off()
```

```
## svg 
##   2
```



```r
# Open a pdf file
pdf("pictures/politeness_effects.pdf") 
# 2. Create a plot
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
# Close the pdf file
dev.off() 
```

```
## svg 
##   2
```



```r
# plot diagnostic diagrams
par(mfrow = c(3,2))
plot(m, which = 1) # variance of residuals vs. fitted values?
plot(m, which = 2) # normal distributed residuals?
plot(m, which = 3) # variance of residuals standardized
plot(m, which = 4) # Cook's distance (outliers / influencing data points?)
plot(m, which = 5) # Leverage vs. standardized variance of residuals
plot(m, which = 6) # Cook's distance vs. Leverage
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-22-1.svg" width="672" />

```r
par(mfrow = c(1,1))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-4.png)


```r
# Change of estimates if one datapoint is removed from the model
d <- dfbetas(m)
head(d) %>% as.data.frame %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["(Intercept)"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["genderM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["attitudepol"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["genderM:attitudepol"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"4.628647e-16","2":"-4.518405e-16","3":"-0.090392640","4":"0.063521473","_rn_":"1"},{"1":"-3.646937e-01","2":"2.578774e-01","3":"0.257877355","4":"-0.181217733","_rn_":"2"},{"1":"6.358180e-17","2":"-2.139049e-16","3":"0.237209532","4":"-0.166693867","_rn_":"3"},{"1":"-6.291782e-03","2":"4.448962e-03","3":"0.004448962","4":"-0.003126412","_rn_":"4"},{"1":"6.068721e-17","2":"-1.784827e-17","3":"-0.133232266","4":"0.093626093","_rn_":"5"},{"1":"1.679279e-01","2":"-1.187430e-01","3":"-0.118742974","4":"0.083444057","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>



```r
# plot the dfbetas (are there any outliers or data points with high influence?)
par(mfrow = c(1,3))
plot(d[,1], col = "orange")
plot(d[,2], col = "blue")
plot(d[,3], col = "purple")
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-24-1.svg" width="672" />

```r
par(mfrow = c(1,1))
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-5.png)

#### Regression mit gemischten Effekten
(Mixed effects Regression)


```r
# The variables 'subject' and 'scenario' have been chosen as random effects
library(afex)
```



```r
# random intercepts model
m <- lmer(frequency ~ gender + 
            (1|subject) + (1|scenario), 
          REML=F, data=polite)
m0 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: frequency ~ gender + (1 | subject) + (1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    816.7    828.8   -403.4    806.7       78 
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.49969 -0.57100 -0.06373  0.60229  2.86559 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 191.2    13.83   
##  subject  (Intercept) 409.6    20.24   
##  Residual             751.9    27.42   
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  246.986     13.481    7.676  18.321  1.3e-07 ***
## genderM     -108.236     17.588    5.939  -6.154 0.000877 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##         (Intr)
## genderM -0.651
```



```r
m <- lmer(frequency ~ gender + attitude + 
          (1|subject) + (1|scenario), 
          REML=F, data=polite)
m1 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: frequency ~ gender + attitude + (1 | subject) + (1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    807.1    821.6   -397.6    795.1       77 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -2.2958 -0.6456 -0.0776  0.5448  3.5121 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 205.2    14.33   
##  subject  (Intercept) 417.0    20.42   
##  Residual             637.4    25.25   
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  256.847     13.827    8.500  18.576 3.53e-08 ***
## genderM     -108.517     17.571    5.929  -6.176 0.000866 ***
## attitudepol  -19.722      5.547   70.920  -3.555 0.000677 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM
## genderM     -0.635       
## attitudepol -0.201  0.004
```



```r
m <- lmer(frequency ~ gender*attitude + 
            (1|subject) + (1|scenario), 
          REML=F, data=polite)
m2 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: frequency ~ gender * attitude + (1 | subject) + (1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    807.1    824.0   -396.6    793.1       76 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -2.1678 -0.5559 -0.0628  0.5103  3.3903 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 205.0    14.32   
##  subject  (Intercept) 418.8    20.47   
##  Residual             620.0    24.90   
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##                     Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)          260.686     14.086    9.140  18.506 1.48e-08 ***
## genderM             -116.195     18.392    7.094  -6.318 0.000376 ***
## attitudepol          -27.400      7.684   70.881  -3.566 0.000655 ***
## genderM:attitudepol   15.568     10.943   70.925   1.423 0.159229    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM atttdp
## genderM     -0.653              
## attitudepol -0.273  0.209       
## gndrM:tttdp  0.192 -0.293 -0.702
```

Vergleich der Modelle:


```r
anova(m0,m1,m2)
```

```
## Data: polite
## Models:
## m0: frequency ~ gender + (1 | subject) + (1 | scenario)
## m1: frequency ~ gender + attitude + (1 | subject) + (1 | scenario)
## m2: frequency ~ gender * attitude + (1 | subject) + (1 | scenario)
##    npar    AIC    BIC  logLik deviance   Chisq Df Pr(>Chisq)    
## m0    5 816.72 828.81 -403.36   806.72                          
## m1    6 807.10 821.61 -397.55   795.10 11.6178  1  0.0006532 ***
## m2    7 807.11 824.04 -396.55   793.11  1.9963  1  0.1576796    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



```r
# politeness affected pitch (χ2(1)=11.62, p=0.00065), 
# lowering it by about 19.7 Hz ± 5.6 (standard errors) 

# random slopes model
m <- lmer(frequency ~ gender + 
            (attitude + 1|subject) + (attitude + 1|scenario), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
m00 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: frequency ~ gender + (attitude + 1 | subject) + (attitude + 1 |  
##     scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    819.6    841.4   -400.8    801.6       74 
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.09487 -0.64641 -0.08678  0.60655  3.00531 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr 
##  scenario (Intercept) 231.844  15.226        
##           attitudepol 410.086  20.251   -0.40
##  subject  (Intercept) 378.484  19.455        
##           attitudepol   5.443   2.333   1.00 
##  Residual             628.656  25.073        
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  253.370     13.437    7.714  18.856  9.9e-08 ***
## genderM     -112.488     17.470    5.932  -6.439 0.000694 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##         (Intr)
## genderM -0.650
## optimizer (nloptwrap) convergence code: 0 (OK)
## boundary (singular) fit: see ?isSingular
```



```r
m <- lmer(frequency ~ gender + attitude + 
          (attitude + 1|subject) + (attitude + 1|scenario), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
m01 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: 
## frequency ~ gender + attitude + (attitude + 1 | subject) + (attitude +  
##     1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    814.9    839.1   -397.4    794.9       73 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -2.1946 -0.6690 -0.0789  0.5256  3.4251 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr
##  scenario (Intercept) 182.083  13.494       
##           attitudepol  31.244   5.590   0.22
##  subject  (Intercept) 392.344  19.808       
##           attitudepol   1.714   1.309   1.00
##  Residual             627.890  25.058       
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  257.991     13.528    7.600  19.071 1.08e-07 ***
## genderM     -110.806     17.510    5.936  -6.328 0.000759 ***
## attitudepol  -19.747      5.922    7.062  -3.335 0.012354 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM
## genderM     -0.647       
## attitudepol -0.105  0.003
## optimizer (nloptwrap) convergence code: 0 (OK)
## boundary (singular) fit: see ?isSingular
```



```r
m <- lmer(frequency ~ gender + attitude + 
            (attitude + 1|subject), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
library(effects)
allEffects(m)
```

```
##  model: frequency ~ gender + attitude
## 
##  gender effect
## gender
##        F        M 
## 247.9156 138.0861 
## 
##  attitude effect
## attitude
##      inf      pol 
## 203.2497 183.8414
```



```r
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-36-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-6.png)


```r
m <- lmer(frequency ~ gender + attitude + 
            (attitude + 1|scenario), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
library(effects)
allEffects(m)
```

```
##  model: frequency ~ gender + attitude
## 
##  gender effect
## gender
##        F        M 
## 247.1051 138.4961 
## 
##  attitude effect
## attitude
##      inf      pol 
## 203.2424 183.4286
```



```r
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-39-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-7.png)


```r
m <- lmer(frequency ~ gender*attitude + 
            (attitude + 1|subject) + (attitude + 1|scenario), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
m02 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: 
## frequency ~ gender * attitude + (attitude + 1 | subject) + (attitude +  
##     1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    814.9    841.5   -396.4    792.9       72 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -2.0680 -0.5620 -0.0360  0.4953  3.3021 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr
##  scenario (Intercept) 185.5388 13.6213      
##           attitudepol  36.4691  6.0390  0.14
##  subject  (Intercept) 400.9123 20.0228      
##           attitudepol   0.8331  0.9127  1.00
##  Residual             609.1686 24.6813      
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##                     Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)          260.686     13.753    7.594  18.955 1.14e-07 ***
## genderM             -116.195     18.036    6.060  -6.442 0.000636 ***
## attitudepol          -27.400      7.969   21.583  -3.438 0.002394 ** 
## genderM:attitudepol   15.516     10.874   58.553   1.427 0.158919    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM atttdp
## genderM     -0.656              
## attitudepol -0.194  0.159       
## gndrM:tttdp  0.153 -0.234 -0.673
## optimizer (nloptwrap) convergence code: 0 (OK)
## boundary (singular) fit: see ?isSingular
```

Vergleich der Modelle:


```r
anova(m00,m01,m02)
```

```
## Data: polite
## Models:
## m00: frequency ~ gender + (attitude + 1 | subject) + (attitude + 1 | scenario)
## m01: frequency ~ gender + attitude + (attitude + 1 | subject) + (attitude + 1 | scenario)
## m02: frequency ~ gender * attitude + (attitude + 1 | subject) + (attitude + 1 | scenario)
##     npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)   
## m00    9 819.61 841.37 -400.80   801.61                        
## m01   10 814.90 839.09 -397.45   794.90 6.7082  1   0.009597 **
## m02   11 814.89 841.50 -396.45   792.89 2.0023  1   0.157060   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



```r
library(lmerTest)
s <- step(m)
```



```r
s
```

```
## Backward reduced random-effect table:
## 
##                                       Eliminated npar  logLik    AIC     LRT Df
## <none>                                             11 -396.45 814.89           
## attitude in (attitude + 1 | subject)           1    9 -396.46 810.92  0.0279  2
## attitude in (attitude + 1 | scenario)          2    7 -396.55 807.11  0.1827  2
## (1 | subject)                                  0    6 -410.45 832.90 27.7921  1
## (1 | scenario)                                 0    6 -402.35 816.71 11.6007  1
##                                       Pr(>Chisq)    
## <none>                                              
## attitude in (attitude + 1 | subject)   0.9861435    
## attitude in (attitude + 1 | scenario)  0.9126813    
## (1 | subject)                          1.351e-07 ***
## (1 | scenario)                         0.0006593 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Backward reduced fixed-effect table:
## Degrees of freedom method: Satterthwaite 
## 
##                 Eliminated  Sum Sq Mean Sq NumDF  DenDF F value    Pr(>F)    
## gender:attitude          1  1254.8  1254.8     1 70.925  2.0239 0.1592288    
## gender                   0 24310.7 24310.7     1  5.929 38.1404 0.0008664 ***
## attitude                 0  8057.2  8057.2     1 70.920 12.6408 0.0006768 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Model found:
## frequency ~ gender + attitude + (1 | subject) + (1 | scenario)
```



```r
library(LMERConvenienceFunctions)

m <- lmer(frequency ~ gender + attitude + 
            (attitude + 1|subject) + (attitude + 1|scenario), 
          REML=F, data=polite)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
m01 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: 
## frequency ~ gender + attitude + (attitude + 1 | subject) + (attitude +  
##     1 | scenario)
##    Data: polite
## 
##      AIC      BIC   logLik deviance df.resid 
##    814.9    839.1   -397.4    794.9       73 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -2.1946 -0.6690 -0.0789  0.5256  3.4251 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr
##  scenario (Intercept) 182.083  13.494       
##           attitudepol  31.244   5.590   0.22
##  subject  (Intercept) 392.344  19.808       
##           attitudepol   1.714   1.309   1.00
##  Residual             627.890  25.058       
## Number of obs: 83, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  257.991     13.528    7.600  19.071 1.08e-07 ***
## genderM     -110.806     17.510    5.936  -6.328 0.000759 ***
## attitudepol  -19.747      5.922    7.062  -3.335 0.012354 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM
## genderM     -0.647       
## attitudepol -0.105  0.003
## optimizer (nloptwrap) convergence code: 0 (OK)
## boundary (singular) fit: see ?isSingular
```



```r
# Check model asumptions
mcp.fnc(m)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-47-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-8.png)


```r
fligner.test(frequency ~ attitude, polite)
```

```
## 
## 	Fligner-Killeen test of homogeneity of variances
## 
## data:  frequency by attitude
## Fligner-Killeen:med chi-squared = 0.21737, df = 1, p-value = 0.6411
```



```r
fligner.test(frequency ~ gender, polite)
```

```
## 
## 	Fligner-Killeen test of homogeneity of variances
## 
## data:  frequency by gender
## Fligner-Killeen:med chi-squared = 0.7388, df = 1, p-value = 0.39
```



```r
shapiro.test(polite$frequency)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  polite$frequency
## W = 0.94456, p-value = 0.001347
```



```r
which(is.na(polite$frequency)) 
```

```
## [1] 39
```



```r
# delete NA from data frame in row 39
polite1 <- polite[-39,]

# Remove outliers
freqout <- romr.fnc(m, polite1, trim=2.5)
```

```
## n.removed = 1 
## percent.removed = 1.204819
```



```r
freqout$n.removed
```

```
## [1] 1
```



```r
freqout$percent.removed
```

```
## [1] 1.204819
```



```r
freqout <- freqout$data
attach(freqout)
```



```r
# update model
m <- lmer(frequency ~ gender + attitude + 
            (attitude + 1|subject) + (attitude + 1|scenario), 
          REML=F, data=freqout)
```

```
## boundary (singular) fit: see ?isSingular
```



```r
m01 <- m
summary(m)
```

```
## Linear mixed model fit by maximum likelihood . t-tests use Satterthwaite's
##   method [lmerModLmerTest]
## Formula: 
## frequency ~ gender + attitude + (attitude + 1 | subject) + (attitude +  
##     1 | scenario)
##    Data: freqout
## 
##      AIC      BIC   logLik deviance df.resid 
##    790.9    815.0   -385.5    770.9       72 
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.49611 -0.56183 -0.04681  0.55860  2.73929 
## 
## Random effects:
##  Groups   Name        Variance  Std.Dev. Corr
##  scenario (Intercept) 205.28012 14.3276      
##           attitudepol   0.01369  0.1170  1.00
##  subject  (Intercept) 410.89205 20.2705      
##           attitudepol   0.11135  0.3337  1.00
##  Residual             518.42987 22.7691      
## Number of obs: 82, groups:  scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error       df t value Pr(>|t|)    
## (Intercept)  258.411     13.640    7.931  18.946 6.91e-08 ***
## genderM     -111.647     17.423    5.936  -6.408 0.000711 ***
## attitudepol  -22.391      5.045   68.398  -4.438 3.39e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) gendrM
## genderM     -0.639       
## attitudepol -0.164  0.008
## optimizer (nloptwrap) convergence code: 0 (OK)
## boundary (singular) fit: see ?isSingular
```



```r
# Re-Check model asumptions
mcp.fnc(m)
```

<img src="09-politeness_mixed_effects_files/figure-html/unnamed-chunk-58-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-9.png)


```r
fligner.test(frequency ~ attitude, freqout)
```

```
## 
## 	Fligner-Killeen test of homogeneity of variances
## 
## data:  frequency by attitude
## Fligner-Killeen:med chi-squared = 0.34994, df = 1, p-value = 0.5541
```



```r
fligner.test(frequency ~ gender, freqout)
```

```
## 
## 	Fligner-Killeen test of homogeneity of variances
## 
## data:  frequency by gender
## Fligner-Killeen:med chi-squared = 0.25815, df = 1, p-value = 0.6114
```



```r
shapiro.test(freqout$frequency)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  freqout$frequency
## W = 0.9441, p-value = 0.001373
```

