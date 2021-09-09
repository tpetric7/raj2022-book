### Höflichkeit und Grundfrequenz


```r
library(tidyverse)
library(scales)
# detach("package:rlang", unload=TRUE)
```

Datensatz von: Bodo Winter

Thema: Politeness and Pitch (F0)

(cf. <http://www.bodowinter.com/tutorial/bw_LME_tutorial1.pdf>)

(cf. <https://bodowinter.com/tutorial/bw_LME_tutorial.pdf>)

Gliederung unserer quantitativen Analyse

1\. Laden der Datei

2\. Kennenlernen der Daten und Säubern

3\. Hypothesen

4\. Test und Ergebnisse

5\. Schluss

#### Datei laden


```r
# politeness <- read.csv("/cloud/project/data/politeness_data.csv")
politeness <- read.csv("data/politeness_data.csv")
```

#### Kennenlernen der Daten und Säubern

Welche Variablen enthält die Datei?


```r
head(politeness)
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


```r
glimpse(politeness)
```

```
## Rows: 84
## Columns: 5
## $ subject   <chr> "F1", "F1", "F1", "F1", "F1", "F1", "F1", "F1", "F1", "F1", ~
## $ gender    <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", ~
## $ scenario  <int> 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 1, 1, 2, 2, 3, 3, ~
## $ attitude  <chr> "pol", "inf", "pol", "inf", "pol", "inf", "pol", "inf", "pol~
## $ frequency <dbl> 213.3, 204.5, 285.1, 259.7, 203.9, 286.9, 250.8, 276.8, 231.~
```

Am Experiment nahmen 6 Versuchspersonen teil (F1, ..., M7). Von jeder Versuchsperson (subject) haben wir 14 Messpunkte (n = 14).


```r
politeness %>% 
  count(subject)
```

```
##   subject  n
## 1      F1 14
## 2      F2 14
## 3      F3 14
## 4      M3 14
## 5      M4 14
## 6      M7 14
```

Versuchspersonen: je 3 sind weiblich bzw. männlich.


```r
politeness %>% 
  count(subject, gender)
```

```
##   subject gender  n
## 1      F1      F 14
## 2      F2      F 14
## 3      F3      F 14
## 4      M3      M 14
## 5      M4      M 14
## 6      M7      M 14
```

Pro Verhaltensweise stehen uns 42 Messpunkte zur Verfügung, um unsere (unten folgende) Hypothese zu überprüfen.


```r
politeness %>% 
  count(attitude)
```

```
##   attitude  n
## 1      inf 42
## 2      pol 42
```

Berechnen wir mal die Grundfrequenz!


```r
politeness %>% 
  mean(frequency)
```

```
## [1] NA
```

`NA`: In unserer Datenreihe fehlt eine Frequenz. Wir entfernen diese Datenzeile, um die durchschnittliche Frequenz mit `mean()` zu berechnen.


```r
politeness %>% 
  drop_na(frequency) %>%
  summarise(av_freq = mean(frequency))
```

```
##    av_freq
## 1 193.5819
```

Wir haben gerade die Durchschnittsfrequenz für alle Versuchspersonen berechnet. Berechnen wir sie nun getrennt nach weiblichen und männlichen Versuchspersonen!


```r
politeness %>% 
  drop_na(frequency) %>%
  group_by(gender) %>% 
  summarise(av_freq = mean(frequency))
```

```
## # A tibble: 2 x 2
##   gender av_freq
##   <chr>    <dbl>
## 1 F         247.
## 2 M         139.
```

Erwartungsgemäß ist der Durchschnittswert bei Frauen höher als bei Männern: Frauen haben meist eine höhere Stimme als Männer.

Ein Blick auf die Durchschnittsfrequenzen bei höflicher und informeller Sprechweise: In unserer Stichprobe mit 6 Versuchspersonen (je 14 Frequenzmessungen) zeigt sich ein Unterschied von etwa 18,2 Hz, und zwar 202,59 - 184,36.


```r
politeness %>% 
  drop_na() %>% 
  group_by(attitude) %>% 
  summarise(avg_freq = mean(frequency),
            sd_freq = sd(frequency))
```

```
## # A tibble: 2 x 3
##   attitude avg_freq sd_freq
##   <chr>       <dbl>   <dbl>
## 1 inf          203.    66.9
## 2 pol          184.    63.6
```


```r
# politeness %>% 
#   drop_na %>% 
#   transmute(attitude, frequency) %>% 
#   mutate(attitude = str_replace(attitude, "pol", "1"),
#          attitude = str_replace(attitude, "inf", "0")) %>% 
#   mutate(attitude = parse_number(attitude))
```

#### Hypothesen

-   H0: Der durchschnittliche Grundfrequenzverlauf (F0) bei höflichem oder informellem Sprechverhalten (attitude) ist gleich.

-   H1: Der durchschnittliche Grundfrequenzverlauf (F0) bei höflichem Sprechverhalten unterscheidet sich vom informellen.

Nach unserem bisherigen Wissen erwarten wir, dass unsere Daten die Hypothese H1 bestätigen werden.

Das überprüfen wir zunächst mit einem t-Test, anschließend mit einer linearen Regression.

#### t-Test

Zunächst ein Blick auf die Durchschnittsfrequenzen bei höflicher und informeller Sprechweise. In unserer Stichprobe mit 6 Versuchspersonen (je 14 Frequenzmessungen) zeigt sich ein Unterschied von etwa 18,2 Hz.

Gemäß Hypothese H1 ist der Unterschied nicht zufällig entstanden, sondern kann auf die Gesamtpopulation deutscher Sprecher verallgemeinert werden.

Nicht so gemäß Hypothese H0: Der Mittelwertunterschied zwischen den Stichproben kann zufällig entstanden sein, denn wenn wir eine andere Stichprobe genommen hätten, wäre der Unterschied vielleicht gleich Null gewesen.

Mit statistischen Tests können wir diese beiden Hypothesen überprüfen. Einer davon ist der t-Test.


```r
politeness %>% 
  drop_na() %>% 
  group_by(attitude) %>% 
  summarise(avg_freq = mean(frequency),
            sd_freq = sd(frequency))
```

```
## # A tibble: 2 x 3
##   attitude avg_freq sd_freq
##   <chr>       <dbl>   <dbl>
## 1 inf          203.    66.9
## 2 pol          184.    63.6
```

Der t-Test bestätigt H1 nicht (p \> 0,05):


```r
t.test(frequency ~ attitude, data = politeness, paired = F, var.equal = T)
```

```
## 
## 	Two Sample t-test
## 
## data:  frequency by attitude
## t = 1.2718, df = 81, p-value = 0.2071
## alternative hypothesis: true difference in means between group inf and group pol is not equal to 0
## 95 percent confidence interval:
##  -10.29058  46.75458
## sample estimates:
## mean in group inf mean in group pol 
##          202.5881          184.3561
```


```r
pol = politeness$frequency[politeness$attitude == "pol"]
inf = politeness$frequency[politeness$attitude == "inf"]
t.test(pol, inf)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  pol and inf
## t = -1.2726, df = 80.938, p-value = 0.2068
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -46.73684  10.27285
## sample estimates:
## mean of x mean of y 
##  184.3561  202.5881
```


```r
polite <- politeness %>% 
  select(attitude, frequency) %>% 
  filter(attitude == "pol") %>% 
  select(-attitude)

informal <- politeness %>% 
  select(attitude, frequency) %>% 
  filter(attitude == "inf") %>% 
  select(-attitude)

t.test(polite, informal)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  polite and informal
## t = -1.2726, df = 80.938, p-value = 0.2068
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -46.73684  10.27285
## sample estimates:
## mean of x mean of y 
##  184.3561  202.5881
```

#### Lineare Regression

Die lineare Regression hat den großen Vorteil, dass man mehr als eine unabhängige Variable (Prädiktor) verwenden kann, um die Hypothese zu testen. Wir wählen Geschlecht (gender) und Sprechverhalten (attitude) als unabhängige Variablen, der Grundfrequenzverlauf (frequency) ist die abhängige Variable.


```r
politeness %>% 
  drop_na %>% 
  lm(frequency ~ attitude + gender, data = .) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = frequency ~ attitude + gender, data = .)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -82.409 -26.561  -4.262  24.690 100.140 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  256.762      6.756  38.006   <2e-16 ***
## attitudepol  -19.553      7.833  -2.496   0.0146 *  
## genderM     -108.349      7.833 -13.832   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 35.68 on 80 degrees of freedom
## Multiple R-squared:  0.7109,	Adjusted R-squared:  0.7037 
## F-statistic: 98.38 on 2 and 80 DF,  p-value: < 2.2e-16
```

Die lineare Regression bestätigt die Hypothese H1: F(2;80 = 98,38; p \< 0,001). Die Versuchspersonen sprechen demnach in einer anderen Tonlage, wenn sie höflich sprechen, und zwar um ca. 19,5 Hz tiefer als wenn sie informell sprechen (p = 0,0146).

Außerdem bestätigt die lineare Regression (erwartungsgemäß) auch, dass die männlichen Versuchspersonen mit einer tieferen Stimme sprechen als die weiblichen, und zwar um durchschnittlich 108 Hz. Der R\^2-Wert beträgt 0,71 (d.h. etwa 71%). Das bedeutet, dass mit dem Regressionsergebnis ca. 71% der Variabilität unserer Daten erklärt wird.


```r
politeness %>% 
  ggplot(aes(attitude, frequency, group = attitude, fill = attitude)) +
  geom_boxplot() +
  facet_wrap(~ gender) +
  geom_hline(yintercept = c(202.5), lty = 3) +
  geom_hline(yintercept = c(184.3), lty = 2) +
  geom_jitter(width = 0.2)
```

<img src="08-politeness_files/figure-html/unnamed-chunk-18-1.svg" width="672" />


```r
m <- lm(frequency ~ attitude*gender, data = politeness)
library(effects)
allEffects(m)
```

```
##  model: frequency ~ attitude * gender
## 
##  attitude*gender effect
##         gender
## attitude        F        M
##      inf 260.6857 144.4905
##      pol 233.2857 132.9800
```

```r
plot(allEffects(m), multiline=TRUE, grid=TRUE, rug=FALSE, as.table=TRUE)
```

<img src="08-politeness_files/figure-html/unnamed-chunk-19-1.svg" width="672" />

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)


```r
library(parameters)
library(see)
p1 = plot(parameters(m)) +
  ggplot2::labs(title = "A Dot-and-Whisker Plot")
p1
```

<img src="08-politeness_files/figure-html/unnamed-chunk-20-1.svg" width="672" />


```r
library(performance)
check <- check_normality(m)
```

```
## OK: residuals appear as normally distributed (p = 0.396).
```

```r
## Warning: Non-normality of residuals detected (p = 0.016).

p2 = plot(check, type = "qq")
p2
```

<img src="08-politeness_files/figure-html/unnamed-chunk-21-1.svg" width="672" />


```r
library(performance)
check <- check_normality(m, effects = "fixed")
```

```
## OK: residuals appear as normally distributed (p = 0.396).
```

```r
## Warning: Non-normality of residuals detected (p = 0.016).

p2a = plot(check, type = "pp")
p2a
```

<img src="08-politeness_files/figure-html/unnamed-chunk-22-1.svg" width="672" />


```r
library(effectsize)
library(see)

m <- aov(frequency ~ attitude*gender, data = politeness)

p3 = plot(omega_squared(m))
p3
```

<img src="08-politeness_files/figure-html/unnamed-chunk-23-1.svg" width="672" />


```r
p4 = ggplot(politeness, aes(x = attitude, y = frequency, color = gender)) +
  geom_point2() +
  theme_modern()
p4
```

<img src="08-politeness_files/figure-html/unnamed-chunk-24-1.svg" width="672" />


```r
p4 = ggplot(politeness, 
            aes(x = attitude, y = frequency, fill = gender)) +
  geom_violin() +
  theme_modern(axis.text.angle = 45) +
  scale_fill_material_d(palette = "ice")

p4
```

<img src="08-politeness_files/figure-html/unnamed-chunk-25-1.svg" width="672" />


```r
p5 = ggplot(politeness, 
            aes(x = attitude, y = frequency, fill = gender)) +
  geom_violindot(fill_dots = "black") +
  geom_jitter(width = 0.05) +
  theme_modern() +
  scale_fill_material_d()
p5
```

<img src="08-politeness_files/figure-html/unnamed-chunk-26-1.svg" width="672" />


```r
plots(p1,p2,p3,p4, 
      n_columns = 2, 
      tags = paste0("B", 1:4))
```

<img src="08-politeness_files/figure-html/unnamed-chunk-27-1.svg" width="672" />


```r
library(bayestestR)
library(rstanarm)
library(see)

set.seed(123)
m <- stan_glm(frequency ~ attitude*gender, data = politeness, refresh = 0)
result <- hdi(m, ci = c(0.5, 0.75, 0.89, 0.95))
plot(result)
```

<img src="08-politeness_files/figure-html/unnamed-chunk-28-1.svg" width="672" />

#### Schluss

Die Regressionsanalyse hat H1 bestätigt, d.h. die Grundfrequenz beim höflichen Sprechen unterscheidet sich vom informellen Sprechen. Beim höflichen Sprechen sprachen die Versuchspersonen mit einer durchschnittlich 19,5 Hz tieferen Stimme (bei den weiblichen Versuchspersonen ca. 27 Hz, bei den männlichen mehr als 11 Hz).
