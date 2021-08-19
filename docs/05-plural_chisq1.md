
### Plural von Kunstwörtern

#### Naložimo programe


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

```r
library(scales)
```

```
## 
## Attaching package: 'scales'
```

```
## The following object is masked from 'package:purrr':
## 
##     discard
```

```
## The following object is masked from 'package:readr':
## 
##     col_factor
```

```r
library(kableExtra)
```

```
## 
## Attaching package: 'kableExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     group_rows
```

#### Preberemo podatkovni niz z diska


```r
# Branje datoteke je možno na več načinov
plural_subj1 = read.csv("data/plural_Subj_sum.csv", sep = ";")
plural_subj1 = read.csv2("data/plural_Subj_sum.csv")
plural_subj1 = read_csv2("data/plural_Subj_sum.csv")
```

```
## i Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.
```

```
## Rows: 738 Columns: 9
```

```
## -- Column specification --------------------------------------------------------
## Delimiter: ";"
## chr (2): WordType, Genus
## dbl (7): SubjID, Sigstark, En, E, Er, S, Z
```

```
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
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

#### Povzetek in Hi-kvadrat test

Podatkovni niz preoblikujemo in povzemamo (agregacija). 
Za preizkus ustvarimo tabelo 2 x 2 z opazovanimi pogostnostmi (frekvencami).
Program izračuna pričakovane pogstnosti in zatem še ocenjuje, ali je razlika med vzorcema statistično značilna.

H0: Preizkusne osebe uporabljajo množinske pripone ne glede na besedni tip (Rhyme / Non-Rhyme).
H1: Preizkusne osebe uporabljajo množinske pripone z ozirom na besedni tip (Rhyme / Non-Rhyme).

Če je p-vrednost < 0,05 (tj. 5%), potem obvelja H1: razlika med opazovanimi in pričakovanimi pogostnostmi je statistično značilna (tj. da ni naključna in dovolj velika ob upoštevanju napake). 

Če p > 0,05, potem obdržimo H0: razlika med opazovanimi pogostnostmi je naključna.


```r
# Povzemamo ("aggregate")
# Ergebnisse summieren
p = plural_subj1 %>% 
  group_by(WordType) %>% 
  summarise(Sigstark = mean(Sigstark),
            En = sum(En), E = sum(E), Er = sum(Er), S = sum(S), Z = sum(Z)) 

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

Možno je tudi testiranje treh ali več vzorcev, vendar nam test ne pove, kateri vzorec je različen od drugega.


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

Ergebnisse summieren:


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

Chi-Quadrat-Test
Falls p < 0,05: es gilt H1 (Stichproben unterscheiden sich).
Falls p > 0,05: es gilt H0 (kein Unterschied zwischen Stichproben).


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

Beobachtete vs. erwartete Werte:


```r
tabelle <- as_tibble(cbind(chi$observed, chi$expected)) %>%
   mutate(Wordtyp = unlist(p[,1])) %>% # Spalte wieder hinzufügen
   mutate(Wordtyp = str_replace(Wordtyp, "NoRhyme", "Nicht-Reimwort"), # auf deutsch
          Wordtyp = str_replace(Wordtyp, "Rhyme", "Reimwort")) %>% # auf deutsch
   rename(En_erwartet = V3, E_erwartet = V4) %>%  # erwartete Werte, wenn H0 richtig ist
   select(Wordtyp, En, E, En_erwartet, E_erwartet) # Reihenfolge der Variablen verändern
```

```
## Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if `.name_repair` is omitted as of tibble 2.0.0.
## Using compatibility `.name_repair`.
```

```r
tabelle %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Wordtyp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["En"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["E"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["En_erwartet"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["E_erwartet"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"Nicht-Reimwort","2":"1528","3":"2169","4":"1496.743","5":"2200.257"},{"1":"Reimwort","2":"1425","3":"2172","4":"1456.257","5":"2140.743"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
