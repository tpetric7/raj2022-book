### Plural von Kunstwörtern

#### Programme laden


```r
library(tidyverse)
library(scales)
library(kableExtra)
```

#### Dateien laden

Für die Durchführung eines $\chi^2$-Tests solle eine Tabelle geladen werden, die Ergebnisse eines Experiments mit deutschen Kunstwörtern enthält, von denen slowenische Studierende der Germanistik den Plural bilden sollten. 


```r
# Branje datoteke je možno na več načinov
plural_subj1 = read.csv("data/plural_Subj_sum.csv", sep = ";")
plural_subj1 = read.csv2("data/plural_Subj_sum.csv")
plural_subj1 = read_csv2("data/plural_Subj_sum.csv")

# Pokaži prvih šest vrstic
head(plural_subj1) %>% knitr::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:right;"> SubjID </th>
   <th style="text-align:left;"> WordType </th>
   <th style="text-align:left;"> Genus </th>
   <th style="text-align:right;"> Sigstark </th>
   <th style="text-align:right;"> En </th>
   <th style="text-align:right;"> E </th>
   <th style="text-align:right;"> Er </th>
   <th style="text-align:right;"> S </th>
   <th style="text-align:right;"> Z </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> NoRhyme </td>
   <td style="text-align:left;"> Fem </td>
   <td style="text-align:right;"> 4.983333 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> NoRhyme </td>
   <td style="text-align:left;"> Masc </td>
   <td style="text-align:right;"> 4.600000 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> NoRhyme </td>
   <td style="text-align:left;"> Neut </td>
   <td style="text-align:right;"> 5.366667 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Rhyme </td>
   <td style="text-align:left;"> Fem </td>
   <td style="text-align:right;"> 3.836667 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Rhyme </td>
   <td style="text-align:left;"> Masc </td>
   <td style="text-align:right;"> 4.153333 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> Rhyme </td>
   <td style="text-align:left;"> Neut </td>
   <td style="text-align:right;"> 3.784167 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

#### Datensatz-Aggregation und Test

Zuerst müssen wir die Rohdaten in eine Tabelle umformen, so dass ein $\chi^2$-Test durchgeführt werden kann. Eine derartige Transformation eines Datensatzes wird oft als Aggregation bezeichnet (also eine Art von Zusammenfassung). In der neu gebildeten 2x2-Tabelle sind die Beobachtungsdaten (d.h. die Häufigkeiten oder Frequenzen) zu finden. Das Programm berechnet für uns die erwarteten Häufigkeiten (theoretischen Frequenzen) und bewertet dann, ob die Differenz zwischen den Stichproben statistisch signifikant ist.

Die statistischen Annahmen können folgendermaßen formuliert werden:   
- $H_0$: Die Versuchspersonen verwenden sowohl für Reimwörter als auch für Nicht-Reimwörter dieselben deutschen Pluralmarker. Der Worttyp hat demnach keinen Einfluss auf die Auswahl des Pluralmarkers.   
- $H_1$: Die Versuchspersonen verwenden für Reimwörter nicht dieselben deutschen Pluralmarker wie für Nicht-Reimwörterverschieden für die beiden Worttypen (Reimwort vs. Nicht-Reimwort). Der Worttyp hat demnach Einfluss auf die Auswahl des Pluralmarkers.   

Wenn der beim statistischen Test erhaltene p-Wert \< 0,05 ist (d.h. bei einer Fehlerwahrscheinlichkeit von weniger als 5%), dann gilt die alternative Hypothese $H_1$: die Differenz zwischen den beobachteten und den theoretisch erwarteten Häufigkeiten ist in diesem Fall statistisch signifikant, d.h. die Differenz ist nicht zufällig und bei 5% Fehlerwahrscheinlichkeit hinreichend groß.

Wenn der p-Wert jedoch p \> 0,05 ist, dann wird die Nullhypothese $H_0$ beibehalten. In diesem Fall wäre die Differenz nicht hinreichend groß und daher vermutlich zufällig entstanden (z.B. durch die geringe Größe der Stichproben oder die Auswahl der Stichprobendaten).

Im ersten statischen Test vergleichen wir die Häufigkeiten der Pluralmarker *--e* und *--s* miteinander.   


```r
# Povzemamo ("aggregate")
# Ergebnisse summieren
p = plural_subj1 %>% 
  group_by(WordType) %>% 
  summarise(Sigstark = mean(Sigstark),
            En = sum(En), E = sum(E), Er = sum(Er), 
            S = sum(S), Z = sum(Z)) 

# izpis tabele
knitr::kable(p)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> WordType </th>
   <th style="text-align:right;"> Sigstark </th>
   <th style="text-align:right;"> En </th>
   <th style="text-align:right;"> E </th>
   <th style="text-align:right;"> Er </th>
   <th style="text-align:right;"> S </th>
   <th style="text-align:right;"> Z </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> NoRhyme </td>
   <td style="text-align:right;"> 4.087337 </td>
   <td style="text-align:right;"> 1528 </td>
   <td style="text-align:right;"> 2169 </td>
   <td style="text-align:right;"> 302 </td>
   <td style="text-align:right;"> 307 </td>
   <td style="text-align:right;"> 26 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rhyme </td>
   <td style="text-align:right;"> 3.916109 </td>
   <td style="text-align:right;"> 1425 </td>
   <td style="text-align:right;"> 2172 </td>
   <td style="text-align:right;"> 561 </td>
   <td style="text-align:right;"> 244 </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
</tbody>
</table>

```r
# Izberemo tri stolpce
q = p %>% select(WordType, E, S)

# Razlika med deleži množinskih pripon E in S (npr. Bal-e oder Bal-s)
chisq.test(q[,-1]) # prvi stolpec naj se ne upošteva, zato [, -1]
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  q[, -1]
## X-squared = 6.2424, df = 1, p-value = 0.01247
```

#### Naslednji preizkus(i)

Wir machen noch einen $\chi^2$-Test mit einer 2x2-Tabelle, und zwar
mit den Pluralmarkern *--e* und *--er* durchgeführt.   


```r
# Izberemo tri stolpce za naslednji preizkus
q = p %>% select(WordType, E, Er)

# Razlika med deleži množinskih pripon E in Er (npr. Bal-e oder Bal-er)
chisq.test(q[,-1]) # prvi stolpec naj se ne upošteva, zato [, -1]
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  q[, -1]
## X-squared = 64.106, df = 1, p-value = 1.179e-15
```

#### Tabela 2 x 3

Der $\chi^2$-Test kann auch mit größeren Tabellen durchgeführt werden, z.B. mit einer 2x3-Tabelle. Dies ermöglicht den Vergleich von mehr als zwei Stichproben.   

Der $\chi^2$-Test kann statistisch signifikante Unterschiede zwischen Stichproben melden, kann aber leider nicht darüber Auskunft oben, welche Stichprobe sich von den übrigen unterscheidet.   


```r
# Izberemo tri stolpce za naslednji preizkus
q = p %>% select(WordType, Er, E, S)

# Razlika med deleži množinskih pripon E in Er (npr. Bal-e oder Bal-er)
chisq.test(q[,-1]) # prvi stolpec naj se ne upošteva, zato [, -1]
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  q[, -1]
## X-squared = 78.148, df = 2, p-value < 2.2e-16
```

#### Zweite Version

Es gibt verschiedene Wege, um die Rohdaten in eine Tabelle umzuformen, die für die Durchführung eines $\chi^2$-Tests geeignet ist. Hier folgt eine weitere Aggregationsvariante mit Hilfe von `tidyverse`-Funktionen. 
Zuerst gruppieren wir die Rohdaten nach der Spalte, in der die Versuchspersonen eingetragen sind. Dann lassen wir die Summe der ausgewählten Pluralmarker berechnen:


```r
(p = plural_subj1 %>% 
  group_by(WordType) %>% 
  summarise(En = sum(En), E = sum (E))
)
```

```
## # A tibble: 2 x 3
##   WordType    En     E
##   <chr>    <dbl> <dbl>
## 1 NoRhyme   1528  2169
## 2 Rhyme     1425  2172
```

Falls p \< 0,05 ist, gilt $H_1$ (die Stichproben unterscheiden sich). Falls p \> 0,05 ist, gilt $H_0$ (kein signifikanter Unterschied zwischen Stichproben).   


```r
(chi = chisq.test(p[,-1])
)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  p[, -1]
## X-squared = 2.1535, df = 1, p-value = 0.1422
```

Zum Schluss werfen wir noch einen Blick auf beobachtete und erwartete Häufigkeiten: 


```r
tabelle <- as_tibble(cbind(chi$observed, chi$expected)) %>%
    # Spalte wieder hinzufügen
   mutate(Wordtyp = unlist(p[,1])) %>%
   # auf deutsch
   mutate(Wordtyp = str_replace(Wordtyp, "NoRhyme", "Nicht-Reimwort"), 
          Wordtyp = str_replace(Wordtyp, "Rhyme", "Reimwort")) %>%
   # erwartete Werte, wenn H0 richtig ist
   rename(En_erwartet = V3, E_erwartet = V4) %>% 
   # Reihenfolge der Variablen verändern
   select(Wordtyp, En, E, En_erwartet, E_erwartet)

tabelle %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Wordtyp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["En"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["E"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["En_erwartet"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["E_erwartet"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"Nicht-Reimwort","2":"1528","3":"2169","4":"1496.743","5":"2200.257"},{"1":"Reimwort","2":"1425","3":"2172","4":"1456.257","5":"2140.743"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
