### Modalkonstruktionen 

In diesem Abschnitt wird die Vorkommenshäufigkeit (token frequency) der slowenischen Modalkonstruktionen *morati + Infinitiv* und *biti + treba + Infinitiv* in einer Auswahl von slowenischen Texten miteinander verglichen. Der statistische Vergleich wird mit dem $\chi^2$-Test durchgeführt. 

#### Packages


```r
library(tidyverse)
library(scales)
library(janitor)
library(readxl)
```

#### Datei laden

Bei Recherchen auf dem slowenischen *Gigafida*-Portal wurden Gebrauchsfrequenzen (Tokenfrequenzen) von zwei Modalkonstruktionen ermittelt, und zwar:   
- *morati + Infinitiv* und   
- *biti + treba + Infinitive*.   

Die erste Tabelle mit den Gebrauchsfrequenzen laden wir von der Festplatte: 


```r
naklonska <- read_xlsx("data/morati_treba.xlsx") %>% 
  clean_names()
naklonska
```

```
## # A tibble: 2 x 3
##   vrsta_besedila  treba  morati
##   <chr>           <dbl>   <dbl>
## 1 Časniki        550572 1501540
## 2 Drugo          169349  530345
```

Die zweite Tabelle zeigt die Distribution der beiden Modalkonstruktionen in fünf Funktionalstilen.


```r
naklonska2 <- read_xlsx("data/morati_treba.xlsx", 
                        sheet = "List2") %>% clean_names()
naklonska2
```

```
## # A tibble: 5 x 3
##   vrsta_besedila    treba  morati
##   <chr>             <dbl>   <dbl>
## 1 Časopisi         389479 1086280
## 2 Revije           161093  415260
## 3 Internet         124996  376433
## 4 Stvarna besedila  30998   98981
## 5 Leposlovje        13355   54931
```

Die Modalkonstruktion *morati + Infinitiv* wird ca. dreimal so häufig verwendet wie *biti + treba + Infinitiv*.

#### Graphische Darstellung

Die graphischen Darstellungen zeigen eher geringe Distributionsunterschiede.


```r
naklonska %>%
  pivot_longer(treba:morati, names_to = "konstruktion", 
               values_to = "freq") %>% 
  ggplot(aes(konstruktion, freq, fill = vrsta_besedila)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Modalkonstruktion", y = "Gebrauchsfrequenz", 
       fill = "Vrsta besedila")
```

<img src="06-Modalkonstruktionen_chisq3_files/figure-html/unnamed-chunk-4-1.svg" width="672" />

Die Modalkonstruktion *morati + Infinitiv* scheint in den alltagssprachlich näherstehenden Funktionalstilen Belletristik (leposlovje), Internet und Sachtexten (stvarna besedila) etwas häufiger belegt zu sein als die Modalkonstruktion *biti + treba + Infinitiv*, dafür aber in Zeitungen (Časopisi) etwas seltener.


```r
naklonska2 %>%
  pivot_longer(treba:morati, names_to = "konstruktion", 
               values_to = "freq") %>% 
  ggplot(aes(konstruktion, freq, fill = vrsta_besedila)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Modalkonstruktion", y = "Gebrauchsfrequenz", 
       fill = "Vrsta besedila")
```

<img src="06-Modalkonstruktionen_chisq3_files/figure-html/unnamed-chunk-5-1.svg" width="672" />

#### Chi-Quadrat-Test

Linguistische Annahme: Die Modalkonstruktion *morati + Infinitiv* ist weniger markiert (natürlicher) als die Modalkonstruktion *biti + treba + Infinitiv*.    

Formale Begründung: Die erste Konstruktion ist kürzer und daher ökonomischer als die zweite.   
Semantische Begründung: Die erste Konstruktion ist semantisch weniger spezifisch als die zweite.   
Dies sollte dazu führen, dass die erste Konstruktion in einer größeren Anzahl von Kontexten erscheint als die zweite.   

Die statistischen Annahmen lassen sich folgendermaßen formulieren:    
$H_0$: Die beiden Modalkonstruktionen kommen in denselben Funktionalstilen vor.    
$H_1$: Die beiden Modalkonstruktionen kommen nicht in denselben Funktionalstilen vor.

Der erste $\chi^2$-Test zeigt, dass die beiden Stichproben (*morati* vs. *treba*) unabhängig voneinander sind. Dies bestätigt der geringe p-Wert (p \< 0,001), der unterhalb dem Grenzwert von p = 0,05 (5%) liegt. Damit können wir die Nullhypothese ($H_0$) verwerfen und die alternative Hypothese ($H_1$) akzeptieren. Die beiden Modalkonstruktionen kommen demnach nicht im gleichen Maße in denselben Funktionalstilen vor.


```r
chisq.test(naklonska[ , -1])
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  naklonska[, -1]
## X-squared = 1862.9, df = 1, p-value < 2.2e-16
```

Der zweite $@chi³2$-Test, der mit den Zahlenwerten der zweiten Tabelle durchgeführt wird, bestätigt Hypothese $H_1$. Die Distribution der beiden Modalkonstruktionen unterscheidet sich. Die graphische Darstellung deutet an, dass dies vor allem am vergleichsweise selteneren Gebrauch der (natürlicheren) Modalkonstruktion *morati + Infinitiv* in publizistischen Texten liegen könnte. Nach unser Annahme wird die (weniger natürliche) Modalkonstruktion *biti + treba + Infinitiv* häufiger in weniger natürlichen Textsorten mit dem Merkmal [+Distanz] eingesetzt.


```r
chisq.test(naklonska2[ , -1])
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  naklonska2[, -1]
## X-squared = 3292, df = 4, p-value < 2.2e-16
```
