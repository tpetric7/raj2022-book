# Stichprobentests

## Nominalskalierte Größen

**Chi-Quadrat-Test** ($\chi^2$-Test):    
Der $\chi^2$-Test ist einer der grundlegenden statistischen Tests zum Vergleich von nominalskalierten Kategorien, z.B.

-   *biologisches Geschlecht*: Frauen vs. Männer;   
-   *Größe*: klein vs. groß;   
-   *Texte*: Text A vs. Text B vs. Text C ...   

Mit dem $\chi^2$-Test testen wir, ob eine *beobachtete* Verteilung der Daten der *erwarteten* Verteilung entspricht. Der Test funktioniert auf allen Skalenniveaus. Es gibt aber verschiedene Anwendungsspielarten:   

- als *Anpassungstest* (z.B. ist ein Merkmal normalverteilt?);   
- als *Homogenitätstest* (z.B. ähneln sich Frauen und Männer bezüglich eines Merkmals, etwa ob sie rauchen oder nicht?);   
- als *Unabhängigkeitstest* (z.B. ist der Dieselverbrauch unabhängig von elektronischer Regulierung des Motors oder nicht?).   

Ein Beispiel aus einem empfehlenswerten Video aus [Kurzes Tutorium Statistik](https://www.youtube.com/watch?v=MCmZ-HXSZ4A), in dem der $@chi³2$-Test und seine Anwendungen erklärt werden. Im Beispiel geht es um den $@chi³2$-*Anpassungstest*:   

Eine Firma verkauft Armbanduhren in vier Farben (blau, grün, gelb, rot). Im letzten Monat wurden 1000 Stück verkauft. Ein Verkaufsleiter behauptet, dass die Nachfrage nach der Uhr in allen vier Farben gleich gut sei. Das können wir mit dem $\chi^2$-Test überprüfen. Wenn die Behauptung des Verkaufsleiters stimmt, dann **erwarten** wir, dass 250 blaue Uhren, 250 grüne Uhren, 250 gelbe Uhren und 250 rote Uhren verkauft wurden - dass also *Gleichverteilung* der *erwarteten Häufigkeiten* vorliegt (250 + 250 + 250 + 250). Also ein Viertel der verkauften Uhren war blau, ein Viertel war gelb, ein Viertel war rot und ein Viertel war grün.   

Wären die (**beobachteten**) Verkaufszahlen im vergangenen Monat (unserer Stichprobe) 245 + 252 + 254 + 249, dann würde der $@chi^2$-Test bestätigen, dass Gleichverteilung der Uhrfarben vorliegt und damit die Hypothese $H_0$ bestätigen. Die Unterschiede sind ja gering. Wenn aber die beobachteten Verkaufszahlen in unserer Stichprobe 60 + 320 + 100 + 520 wären, dann würde der $@chi^2$-Test die Gleichverteilung der Farben nicht bestätigen und die Nullhypothese $H_0$ verwerfen.   

Die Statistikexpertin erhält vom Verkaufsleiter die tatsächlichen Verkaufszahlen: 300 blaue Urhen + 200 gelbe Uhren + 400 rote Uhren + 100 grüne Uhren wurden im vergangenen Monat verkauft. Kann man das noch immer als Gleichverteilung der Farben auffassen?   

Wir verwenden die folgende Teststatistik:   
- Wir *subtrahieren* die jeweilige erwartete Häufikgeit von der beobachteten und erhalten somit Differenzen;   
- dann *quadrieren* wir jede *Differenz*, so dass wir nur mit positiven Zahlenwerten zu tun haben;    
- dann *dividieren* wir jede der *quadrierten Differenzen* mit der *erwarteten* Häufigkeit (hier: 250) und erhalten somit Quotienten;   
- dann *addieren* wir die *Quotienten* und erhalten somit den *empirischen* $@chi^2$-Wert (im Beispiel beträgt dieser 200).   

$$
\frac{(300 - 250)^2}{250} + \frac{(200 - 250)^2}{250} + \frac{(400 - 250)^2}{250} + \frac{(100 - 250)^2}{250} = 200 = \chi^2_{empirisch}
$$

Das **Test- oder Signifikanzniveau** (auch **Irrtumswahrscheinlichkeit** genannt) wird gewöhnlich auf 5% festgelegt (p = 0,05). Die Wahrscheinlichkeit, dass wir fälschlicherweise die Nullhypothese verwerfen, soll demnach bei diesem Testniveau höchstens 5% betragen.    

Da die Warscheinlichkeit ein Viertel pro Uhrfarbe beträgt (250 von 1000; siehe oben), liegt eine *Binomialverteilung* vor. Bei ausreichend großen Stichproben (wie der hier vorliegenden) kann man diese durch die *Normalverteilung* ersetzen. Mit der Normalverteilung lässt sich einfacher rechnen.    

Da wir in unserer Teststatistik die erwarteten Häufigkeiten von den beobachteten abziehen und danach dividieren, wird die Normalverteilung zum Nullpunkt des Koordinatensystems verschoben. Die Werte der Teststatistik werden durch diesen Rechenvorgang *normalisiert*.   

Durch Quadrieren der Differenzen erreichen wir, dass wir keine negativen Werte mehr erhalten können. Alle Werte sind damit positiv und befinden sich im ersten Quadranten des Koordinatensystems. Da wir mehrere Terme addieren (hier sind es 4) und damit potentiell mehrere Zufallsvariablen in die Summe einbeziehen, kann die *Verteilungskurve* verschiedene Formen annehmen. Das Ergebnis ist eine $\chi^2$-Verteilung. Diese Verteilung sagt uns, welche Werte die Teststatistik mit welcher Wahrscheinlichkeit annehmen wird, wenn die Nullhypothese $H_0$ stimmt. Danach sind die Werte in der Nähe des Koordinatenursprungs (der Null) wahrscheinlich. Die meisten Werte unserer Teststatistik sollten gemäß der Nullhypothese in diesem Bereich, dem *Annahmebereich*, liegen. Werte, die weit entfernt von der Null (dem Koordinatenursprung) vorkommen, sind weniger wahrscheinlich. Sie liegen im *Ablehnungsbereich* (Verwerfungsbereich).   

Eine grundlegende Bedingung für die Anwendung des $\chi^2$-Tests ist, dass die erwarteten Häufigkeiten nicht kleiner als fünf sein dürfen: $Freq_{erwartet}\geq{5}$. In unserem Beispiel ist das der Fall (hier: 250).    

In unserem Beispiel haben wir vier Summenterme, die die Gesamtsumme 1000 (Uhren) ergeben müssen. Die ersten drei Summen könnten vom Zufall abhängen, die letzte ist dagegen immer die Differenz zur Gesamtsumme (hier: 1000). In unserem Beispiel gibt es demnach nur drei Größen (Summen), die frei variieren können. In unserem Beispiel liegen demnach drei *Freiheitsgrade* vor. Das ist notwendig zu wissen, falls man (noch) mit Tabellen arbeitet und wenn man sich sicher sein möchte, dass man den Test richtig durchgeführt hat. Bei drei Freiheitsgraden und einem *Signifikanzniveau* von 5% beträgt der *kritische* $\chi^2$-Wert (*Schwellenwert* für die Annahme bzw. Ablehnung der Nullhypothese) etwa 7,815. Wenn die Nullhypothese stimmt, dann beträgt unsere Teststatistik mit 95%-iger Wahrscheinlichkeit höchstens 7,815. Unser empirischer $\chi^2$-Wert beträgt jedoch 200 und ist damit größer als der Schwellenwert (kritische Wert). Das bedeutet, dass wir die Nullhypothese verwerfen und die alternative Hypothese $H_1$ annehmen. 

**Zusammenfassung**   
Frage: Werden die Uhrfarben gleichhäufig verkauft?   
Hypothese $H_0$: Die Farben werden gleichhäufig verkauft.   
Hypothese $H_1$: Die Farben werden NICHT gleichhäufig verkauft.   
Testverteilung: $\chi^2$-Verteilung.   
Testniveau: $\alpha = 5%$   
Teststatistik:    

$$
\chi^2_{emp} = \Sigma{\frac{(Freq_{beobachtet} - Freq_{erwartet})^2}{Freq_{erwartet}}}
$$

*Ergebnis* (im obigen Beispiel):   
Die Nachfrage nach den verschiedenfarbigen Uhren ist NICHT gleichmäßig verteilt: $\chi^2_{empirisch} > \chi^2_{erwartet}$ bei 3 Freiheitsgraden und 5%-iger Irrtumswahrscheinlichkeit. Wir lehnen die Nullhypothese damit ab und akzeptieren die alternative Hypothese. 


### Lange und kurze Kommentare

Die Verwendung des $@chi³2$-Tests im sprachlichen Bereich wollen wir zunächst am Beispiel eines erfundenen Datensatzes kennen lernen.

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> neugeschriebener_satz </th>
   <th style="text-align:right;"> kurzer_kommentar_a </th>
   <th style="text-align:right;"> ausf_a_lhrlicher_kommentar </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> inkorrekt </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> korrekt </td>
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
</tbody>
</table>

Im Datensatz wird zwischen langen und kurzen Kommentaren einer Lehrerin unterschieden und die jeweilige Anzahl sprachlicher Fehler von Schülern in ihren Aufsätzen. Geklärt werden soll die Frage, welche Wirkung lange und kurze Kommentare der Lehrerin auf die Anzahl der sprachlichen Fehler hatten.

#### Programme


```r
library(tidyverse)
library(janitor)
library(scales)
library(rmarkdown)
library(kableExtra)
```

#### Kurzversion:

Wie sinnvoll sind lange bzw. kurze Kommentare einer Lehrerin zu sprachlichen Fehlern in Essays?


```r
library(tidyverse)
library(janitor)

# Datei laden und die Variablennamen vereinheitlichen
kommentare = read.delim("data/chisq_kommentare.txt", sep = "\t") %>% 
  clean_names()

head(kommentare)
```

```
##   neugeschriebener_satz kurzer_kommentar_a ausf_a_lhrlicher_kommentar
## 1             inkorrekt                 13                         29
## 2               korrekt                 67                         55
```

```r
library(janitor)
# Chi-Quadrat-Test
chisq.test(kommentare[,-1])
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  kommentare[, -1]
## X-squared = 6.2551, df = 1, p-value = 0.01238
```

Ergebnis: Wir verwerfen die Hypothese H0 und nehmen die Hypothese H1 an: zwischen kurzen und langen Kommentaren besteht ein nicht zufälliger Unterschied.

#### Längere Version

##### Datei laden

Eine Lehrerin möchte wissen, ob es effektiver ist, wenn sie am Rand der Schüleressays kurze oder ausführlichere Kommentare zu den Fehlern der Schüler_innen notiert. Sie vergleicht somit zwei Schülergruppen (Schüler_innen mit kurzen vs. langen Kommentaren) und zwei Beurteilungskategorien (korrekte vs. inkorrekte Äußerungen in den Essays).


```r
library(tidyverse)

# von github laden
kommentare = read.delim(
  "https://raw.githubusercontent.com/tpetric7/tpetric7.github.io/main/data/chisq_kommentare.txt",
  sep = "\t", fileEncoding = "UTF-8")

library(janitor)

# Variablennamen konsequent schreiben
kommentare = kommentare %>% 
  clean_names()

# Von der Festplatte laden
kommentare = read.delim("data/chisq_kommentare.txt", sep = "\t", fileEncoding = "UTF-8") %>% 
  clean_names()
head(kommentare) %>% knitr::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> neugeschriebener_satz </th>
   <th style="text-align:right;"> kurzer_kommentar </th>
   <th style="text-align:right;"> ausfuhrlicher_kommentar </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> inkorrekt </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> korrekt </td>
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 55 </td>
  </tr>
</tbody>
</table>

##### Chi-Quadrat-Test

Stichproben: kurzer Kommentar vs. langer Kommentar

-   H0: Zwischen den beiden Stichproben besteht kein signifikanter Unterschied (Unterschiede zufällig).
-   H1: Zwischen den beiden Stichproben besteht ein signifikanter Unterschied (Unterschiede nicht zufällig).


```r
library(janitor)
chisq.test(kommentare[,-1])
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  kommentare[, -1]
## X-squared = 6.2551, df = 1, p-value = 0.01238
```

Wir verwerfen H0 und nehmen H1 an: zwischen kurzen und langen Kommentaren besteht ein nicht zufälliger Unterschied.

##### Graphische Darstellung


```r
library(tidyverse)
library(scales)

kom_lang = kommentare %>% 
  as_tibble() %>% 
  pivot_longer(kurzer_kommentar:ausfuhrlicher_kommentar, 
               names_to = "Kommentar",
               values_to = "Fehler") %>% 
  mutate(pct = Fehler/sum(Fehler))

kom_lang %>% knitr::kable()
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> neugeschriebener_satz </th>
   <th style="text-align:left;"> Kommentar </th>
   <th style="text-align:right;"> Fehler </th>
   <th style="text-align:right;"> pct </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> inkorrekt </td>
   <td style="text-align:left;"> kurzer_kommentar </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 0.0792683 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> inkorrekt </td>
   <td style="text-align:left;"> ausfuhrlicher_kommentar </td>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:right;"> 0.1768293 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> korrekt </td>
   <td style="text-align:left;"> kurzer_kommentar </td>
   <td style="text-align:right;"> 67 </td>
   <td style="text-align:right;"> 0.4085366 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> korrekt </td>
   <td style="text-align:left;"> ausfuhrlicher_kommentar </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 0.3353659 </td>
  </tr>
</tbody>
</table>

```r
kom_lang  %>%  ggplot(aes(Kommentar, pct, fill = neugeschriebener_satz)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Neugeschriebener Satz", y = "",
       title = "Wirksamkeit kurzer und langer Kommentare")
```

<img src="04-kommentare_chisq_long_files/figure-html/unnamed-chunk-6-1.svg" width="672" />
