# Buchstaben in Romanen

## Packages


```r
library(tidyverse)
library(tidytext)
library(scales)
library(readtext)
library(rmarkdown)
# library(qdap) # syllable_count and syllable_sum
# library(quanteda) # nsyllable(tokens(txt))
```

Im *Wikipedia*-Artikel zum Thema [Buchstabenhäufigkeit](https://de.wikipedia.org/wiki/Buchstabenh%C3%A4ufigkeit) gibt die folgende Tabelle Auskunft über die Häufigkeit von Buchstaben in einer Stichprobe von deutschen Texten. Die Umlaute werden in dieser Tabelle als jeweils zwei Monophthonge gezählt. 


```r
library(readxl)
buchstabenhaeufigkeit <- 
  read_xlsx("data/wikipedia_buchstabenhaeufigkeit_deutsch.xlsx")
buchstabenhaeufigkeit %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Platz"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Buchstabe"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Relative Häufigkeit"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"1.","2":"E","3":"17,40 %"},{"1":"2.","2":"N","3":"9,78 %"},{"1":"3.","2":"I","3":"7,55 %"},{"1":"4.","2":"S","3":"7,27 %"},{"1":"5.","2":"R","3":"7,00 %"},{"1":"6.","2":"A","3":"6,51 %"},{"1":"7.","2":"T","3":"6,15 %"},{"1":"8.","2":"D","3":"5,08 %"},{"1":"9.","2":"H","3":"4,76 %"},{"1":"10.","2":"U","3":"4,35 %"},{"1":"11.","2":"L","3":"3,44 %"},{"1":"12.","2":"C","3":"3,06 %"},{"1":"13.","2":"G","3":"3,01 %"},{"1":"14.","2":"M","3":"2,53 %"},{"1":"15.","2":"O","3":"2,51 %"},{"1":"16.","2":"B","3":"1,89 %"},{"1":"17.","2":"W","3":"1,89 %"},{"1":"18.","2":"F","3":"1,66 %"},{"1":"19.","2":"K","3":"1,21 %"},{"1":"20.","2":"Z","3":"1,13 %"},{"1":"21.","2":"P","3":"0,79 %"},{"1":"22.","2":"V","3":"0,67 %"},{"1":"23.","2":"<U+1E9E>","3":"0,31 %"},{"1":"24.","2":"J","3":"0,27 %"},{"1":"25.","2":"Y","3":"0,04 %"},{"1":"26.","2":"X","3":"0,03 %"},{"1":"27.","2":"Q","3":"0,02 %"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Die ersten fünf Buchstaben haben einen Anteil von etwa der Hälfte, die häufigsten zehn Buchstaben decken etwa drei Viertel der relativen Buchstabenhäufigkeit in deutschen Texten ab. 

Eine weitere Tabelle zeigt die Häufigkeit der Buchstaben in Texten aus einem Briefkorpus (Briefe aus den Jahren 1996-2004). In diesem Fall sind auch die Frequenzen der Umlaute erhoben worden. Die zehn häufigsten Buchstaben im Briefkorpus decken sich zum großen Teil mit denen im vorher gezeigten. 


```r
library(readxl)
buchstabenhaeufigkeit_briefe <- 
  read_xlsx("data/wikipedia_buchstabenhaeufigkeit_briefkorpus.xlsx")
buchstabenhaeufigkeit_briefe %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Platz"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Buchstabe"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Absolute Häufigkeit"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Relative Häufigkeit"],"name":[4],"type":["chr"],"align":["left"]}],"data":[{"1":"1.","2":"E","3":"16040","4":"16,11 %"},{"1":"2.","2":"N","3":"10288","4":"10,33 %"},{"1":"3.","2":"I","3":"9011","4":"9,05 %"},{"1":"4.","2":"R","3":"6693","4":"6,72 %"},{"1":"5.","2":"T","3":"6312","4":"6,34 %"},{"1":"6.","2":"S","3":"6203","4":"6,23 %"},{"1":"7.","2":"A","3":"5577","4":"5,60 %"},{"1":"8.","2":"H","3":"5177","4":"5,20 %"},{"1":"9.","2":"D","3":"4156","4":"4,17 %"},{"1":"10.","2":"U","3":"3680","4":"3,70 %"},{"1":"11.","2":"C","3":"3384","4":"3,40 %"},{"1":"12.","2":"L","3":"3226","4":"3,24 %"},{"1":"13.","2":"G","3":"2924","4":"2,94 %"},{"1":"14.","2":"M","3":"2784","4":"2,80 %"},{"1":"15.","2":"O","3":"2312","4":"2,32 %"},{"1":"16.","2":"B","3":"2176","4":"2,19 %"},{"1":"17.","2":"F","3":"1701","4":"1,71 %"},{"1":"18.","2":"W","3":"1383","4":"1,39 %"},{"1":"19.","2":"Z","3":"1351","4":"1,36 %"},{"1":"20.","2":"K","3":"1329","4":"1,33 %"},{"1":"21.","2":"V","3":"912","4":"0,92 %"},{"1":"22.","2":"P","3":"841","4":"0,84 %"},{"1":"23.","2":"Ü","3":"636","4":"0,64 %"},{"1":"24.","2":"Ä","3":"511","4":"0,51 %"},{"1":"25.","2":"Ö","3":"363","4":"0,36 %"},{"1":"26.","2":"<U+1E9E>","3":"189","4":"0,19 %"},{"1":"27.","2":"J","3":"186","4":"0,19 %"},{"1":"28.","2":"X","3":"112","4":"0,11 %"},{"1":"29.","2":"Q","3":"73","4":"0,07 %"},{"1":"30.","2":"Y","3":"56","4":"0,06 %"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

In einem anderen *Wikipedia*-Artikel mit dem Titel [Frekvence črk](https://sl.wikipedia.org/wiki/Frekvence_%C4%8Drk) werden die relativen Häufigkeiten der Buchstaben in slowenischen belletristischen Texten tabellarisch dargestellt und einigen anderen Sprachen gegenübergestellt. In dieser Tabelle fällt auf, dass die Graphme der Vollvokale *a* und *o* einen deutliche höheren Rang einnehmen als in den beiden Tabellen für deutsche Texte. Ähnlich wie in den Tabellen für die deutschen Texte ist wiederum, dass die Vokalgrapheme *e* und *i* zu den häufigsten gehören. Unter den Konsonantgraphemen sind auch hier *n, s, r* und *t* stark vertreten. 


```r
library(readxl)
buchstabenhaeufigkeit_slov <- 
  read_xlsx("data/wikipedia_frekvence_crk.xlsx")
buchstabenhaeufigkeit_slov %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["črka"],"name":[1],"type":["chr"],"align":["left"]},{"label":["relativna frekvenca v slo. leposlovju"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"e","2":"10,707 %"},{"1":"a","2":"10,466 %"},{"1":"o","2":"9,084 %"},{"1":"i","2":"9,042 %"},{"1":"n","2":"6,328 %"},{"1":"l","2":"5,266 %"},{"1":"s","2":"5,053 %"},{"1":"r","2":"5,010 %"},{"1":"j","2":"4,675 %"},{"1":"t","2":"4,329 %"},{"1":"v","2":"3,764 %"},{"1":"k","2":"3,704 %"},{"1":"d","2":"3,390 %"},{"1":"p","2":"3,374 %"},{"1":"m","2":"3,305 %"},{"1":"z","2":"2,103 %"},{"1":"b","2":"1,939 %"},{"1":"u","2":"1,879 %"},{"1":"g","2":"1,638 %"},{"1":"č","2":"1,483 %"},{"1":"h","2":"1,047 %"},{"1":"š","2":"0,996 %"},{"1":"c","2":"0,662 %"},{"1":"ž","2":"0,646 %"},{"1":"f","2":"0,110 %"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


Wir stellen uns die Aufgabe, die Buchstabenhäufigkeit in von uns ausgewählten Texten literarischer Prosa tabellarisch zusammenzustellen und mit denen im Wikipedia-Artikel zu vergleichen. In den folgenden Abschnitten beschäftigen wir uns mit der Häufigkeit von Vokalgraphemen, Konsonantengraphemen, Konsonantenverbindungen und Silben in tabellarischer und graphischer Form. 


## Datensatz lesen

Die *readtext()*-Funktion erlaubt Einlesen von mehreren Dateien auf einfache Art und Weise.
Mit *docvarsfrom* erhalten wird eine neue Spalte in der Tabelle, die wir mit der Funktion *rename()* umbenennen.
Mit *encoding = "UTF-8"* teilen wir dem Programm mit, wie der Text kodiert ist (Code Page).


```r
novels_txt = readtext("data/books/*.txt", 
                      docvarsfrom = "filenames", 
                      encoding = "UTF-8") %>% 
  rename(title = docvar1)
novels_txt
```

```
## readtext object consisting of 2 documents and 1 docvar.
## # Description: df [2 x 3]
##   doc_id      text                title  
##   <chr>       <chr>               <chr>  
## 1 prozess.txt "\"Der Prozes\"..." prozess
## 2 tom.txt     "\"Tom Sawyer\"..." tom
```


## Buchstaben extrahieren

### aus Liste

Der reguläre Ausdruck *[a-zA-Z]* extrahiert nur Buchstaben des englischen Alphabets, *[:alpha:]* extrahiert dagegen auch nicht-englische Buchstaben, z.B. deutsche oder slowenische Sonderzeichen. Zahlen und andere spezielle Zeichen (z.B. Interpunktion) werden auf diese Weise nicht extrahiert.

Regex *{1}* (= default) extrahiert Einzelbuchstaben. Bei Verwendung von *{2}* werden jeweils zwei aufeinander folgende Buchstaben extrahiert.

Die Funktion *tolower()* sorgt dafür, dass Großbuchstaben in Kleinbuchstaben umgewandelt werden. Falls zwischen großen und kleinen Buchstaben unterschieden werden soll, entfernen wir diese Funktion aus dem Programmkode.


```r
letters = tolower(novels_txt$text) %>% str_extract_all(pattern = "[:alpha:]{1}")
letters[[1]][1:10]
```

```
##  [1] "d" "e" "r" "p" "r" "o" "z" "e" "s" "s"
```

```r
letters[[2]][1:9]
```

```
## [1] "t" "o" "m" "s" "a" "w" "y" "e" "r"
```


### aus Datensatz

Tabellen und Graphiken erstellen ist leichter, wenn wir die Texte in Datensätze umwandeln, und zwar mit der Funktion *as.data.frame()*.


```r
novels = as.data.frame(novels_txt)
```


Mit der Funktion *unnest_tokens()* können wir auch Buchstaben isolieren und anschließend auszählen.


```r
library(tidytext)

novels_character <- novels %>%
  unnest_tokens(character, text, token = "characters", to_lower = TRUE, drop = T)

head(novels_character)
```

```
##        doc_id   title character
## 1 prozess.txt prozess         d
## 2 prozess.txt prozess         e
## 3 prozess.txt prozess         r
## 4 prozess.txt prozess         p
## 5 prozess.txt prozess         r
## 6 prozess.txt prozess         o
```

## Buchstaben zählen

Mit *count()* können wir die Häufigkeit einer Variable (hier: der Buchstaben) auszählen.


```r
novels_character %>% 
  count(character, sort = TRUE) %>% head(3)
```

```
##   character      n
## 1         e 114769
## 2         n  70151
## 3         i  52767
```

Der tidytext-Tokenizer hat nicht nur Buchstaben, sondern auch Zahlen extrahiert. Da wir nur an der Häufigkeit von Buchstaben interessiert sind, filtern wir die Zahlen und andere Zeichen heraus. Dazu verwenden wir die Funktionen *filter()* und zusätzlich *str_detect()*, da wir für diese Aufgabe einen regulären Ausdruck nutzen wollen.


```r
novels_character %>% 
  filter(str_detect(character, "[:alpha:]")) %>% 
  count(character, sort = T) %>% head(3)
```

```
##   character      n
## 1         e 114769
## 2         n  70151
## 3         i  52767
```


Ein paar Zeichen, die nicht zum deutschen Alphabet gehören und mit dem vorherigen Programm-Schritt nicht herausfiltern konnten, werden im nächsten Schritt ebenfalls herausgefiltert.

Wir speichern das Ergebnis als neue Tabelle mit dem Namen *char_freq*. Die zehn häufigsten Buchstaben in dieser Tabelle decken sich mit denen in den beiden eingangs gezeigten Tabellen aus dem Wikipedia-Artikel über Buchstabenhäufigkeit, insbesondere mit der, die auf einem Briefkorpus beruhte. 


```r
char_freq = novels_character %>% 
  filter(str_detect(character, "[:alpha:]")) %>% 
  filter(!str_detect(character, "é|á")) %>% 
  count(character, sort = T)

library(DT)
char_freq %>% 
    DT::datatable(fillContainer = FALSE, filter = "top",
                options = list(pageLength = 10))
```

```{=html}
<div id="htmlwidget-f4b55f7723a1a8f60543" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-f4b55f7723a1a8f60543">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"44\" data-max=\"114769\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"],["e","n","i","r","s","t","a","h","d","u","c","l","g","m","o","b","w","f","k","z","ü","v","ä","ß","p","ö","j","y","q","x"],[114769,70151,52767,47937,42610,42057,39825,38600,33683,26309,24770,24434,21247,18532,15270,13261,13068,11021,10054,8725,5224,5003,3801,3594,3584,2045,1757,347,67,44]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>character<\/th>\n      <th>n<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true}},"evals":[],"jsHooks":[]}</script>
```

Insgesamt haben wir 30 Buchstaben des deutschen Alphabets in den Romanen unterschieden.
Aus wie vielen Buchstaben des deutschen Alphabets bestehen die Romane? Die Summe erhalten wir mit der Funktion *summarise()* - fast 700 Tausend.


```r
char_freq %>% 
  summarise(total = sum(n))
```

```
##    total
## 1 694556
```

Es ist nun wirklich Zeit, mal ein Bild zu malen! 
Dazu verwenden wir das Programm (library) *ggplot2*, das im Programmbündel *tidyverse* enthalten ist.

Das Diagramm zeigt sehr deutlich, dass gewaltige Häufigkeitsunterschiede im deutschen Alphabet bestehen.


```r
char_freq %>% 
  mutate(character = fct_reorder(character, n)) %>% # Sortieren nach Frequenz
  ggplot(aes(n, character, fill = character)) +
  geom_col() +
  theme(legend.position = "none")
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-13-1.svg" width="10" height="8" />

Eine bessere Vorstellung von den Zahlenverhältnissen erhalten wir, wenn wir die mehrstelligen Zahlenwerte in Prozente umwandeln.


```r
library(scales)
char_freq %>% 
  mutate(Prozent = n / sum(n)) %>% # Umwandlung in Prozente
  ungroup() %>% 
  mutate(character = fct_reorder(character, Prozent)) %>% # Sortieren nach Prozenten
  ggplot(aes(Prozent, character, fill = character)) +
  geom_col() +
  theme(legend.position = "none") +
  scale_x_continuous(labels = percent_format(
    decimal.mark = ",", accuracy = 1)) # Prozent-Format
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-14-1.svg" width="10" height="8" />

Getrennte tabellarische Darstellung für die Texte:


```r
novels_character %>% 
  group_by(doc_id) %>% 
  count(character, sort = TRUE) %>% 
  pivot_wider(names_from = doc_id, values_from = n) %>% 
  DT::datatable(fillContainer = FALSE, filter = "top",
                options = list(pageLength = 10))
```

```{=html}
<div id="htmlwidget-c788a78ce45501bb689a" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-c788a78ce45501bb689a">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"60978\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"53791\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42"],["e","n","i","r","t","s","a","h","d","u","c","l","g","m","o","b","w","f","k","z","ü","v","ä","p","ß","ö","j","y","q","x","0","1","4","7","2","5","3","6","8","9","é","á"],[60978,36237,28426,25884,21751,21690,20817,20095,17247,12636,12691,12463,11563,9252,7426,6936,6398,5882,5576,4552,2983,2862,2119,1635,1894,1009,734,8,26,6,1,2,1,1,1,1,1,1,1,1,1,null],[53791,33914,24341,22053,20306,20920,19008,18505,16436,13673,12079,11971,9684,9280,7844,6325,6670,5139,4478,4173,2241,2141,1682,1949,1700,1036,1023,339,41,38,3,3,3,3,2,2,null,1,1,null,1,1]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>character<\/th>\n      <th>prozess.txt<\/th>\n      <th>tom.txt<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"columnDefs":[{"className":"dt-right","targets":[2,3]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true}},"evals":[],"jsHooks":[]}</script>
```

Getrennte graphische Darstellung für die Texte:



```r
library(scales)
novels_character %>% 
  group_by(doc_id) %>% 
  count(character, sort = TRUE) %>% 
  mutate(Prozent = n / sum(n)) %>% # Umwandlung in Prozente
  ungroup() %>% 
  mutate(character = fct_reorder(character, Prozent)) %>% # Sortieren nach Prozenten
  filter(Prozent > 0.0001) %>% 
  ggplot(aes(Prozent, character, fill = character)) +
  geom_col() +
  theme(legend.position = "none") +
  facet_wrap(~ doc_id, scales = "free")
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-16-1.svg" width="10" height="8" />

```r
  scale_x_continuous(labels = percent) # Prozent-Format
```

```
## <ScaleContinuousPosition>
##  Range:  
##  Limits:    0 --    1
```


## Vokale

Betrachten wir zunächst nur die Buchstaben, die Vokale symbolisieren!
Zu diesem Zweck bilden wir eine Vokalliste. Zwischen den Vokalen setzen wir das "oder"-Zeichen ein: den *logischen Operator* "|".


```r
vokale = "a|e|i|o|u|ä|ö|ü|y"
```

Die Vokalliste "vokale" verwenden wir mit den Funktionen *filter()* und *str_detect()*.


```r
library(scales)
char_freq %>% 
  filter(str_detect(character, vokale)) %>% 
  mutate(Prozent = n / sum(n)) %>% # Umwandlung in Prozente
  ungroup() %>% 
  mutate(character = fct_reorder(character, Prozent)) %>% # Sortieren nach Prozenten
  ggplot(aes(Prozent, character, fill = character)) +
  geom_col() +
  theme(legend.position = "none") +
  labs(y = "Vokale", x = "Häufigkeit in Romanen") +
  scale_x_continuous(labels = percent_format(accuracy = 1), 
                     breaks = seq(0, 0.50, 0.05)) # Prozent-Format
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-18-1.svg" width="10" height="8" />

Am häufigsten kommt der Buchstabe "e" in den Romanen vor (fast 45%-iger Anteil unter den Vokalen!), am seltensten "y", welches im Wesentlichen in Fremd- und Lehnwörtern auftritt.


## Konsonanten

Welche Buchstaben, die Konsonanten symbolisieren, kommen am häufigsten vor?
Zum Filtern verwenden wir wiederum die Vokalliste, dieses Mal allerdings mit Negationszeichen "!".


```r
library(scales)
char_freq %>% 
  filter(!str_detect(character, vokale)) %>% # Negationszeichen, daher Konsonanten beibehalten
  mutate(Prozent = n / sum(n)) %>% # Umwandlung in Prozente
  ungroup() %>% 
  mutate(character = fct_reorder(character, Prozent)) %>% # Sortieren nach Prozenten
  ggplot(aes(Prozent, character, fill = character)) +
  geom_col() +
  theme(legend.position = "none") +
  labs(y = "Konsonanten", x = "Häufigkeit in Romanen") +
  scale_x_continuous(labels = percent_format(accuracy = 1), breaks = seq(0, 0.50, 0.02)) # Prozent-Format und Einheiten
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-19-1.svg" width="10" height="8" />

Der Buchstabe "n" kommt in den Romanen am häufigsten vor, gefolgt von den Buchstaben: "r, s, t, h, d".
Selten sind die Buchstaben: "x, q, p, ß, v".


## Vokal-Konsonant-Verhältnis

Welches Zahlenverhältnis besteht zwischen den Vokalen und Konsonanten?

21 konsonantische Buchstaben und 9 vokalische Buchstaben. Pro Silbe sind in den deutschen Texten 1 Vokal und ungefähr 2 Konsonanten zu erwarten, also Silbenstrukturen wie z.B. KVK, KKV, VKK.


```r
bs_ratio = char_freq %>% 
  mutate(buchstabe = ifelse(str_detect(character, vokale), "Vokal", "Konsonant")) %>% 
  count(buchstabe) %>% 
  mutate(Prozent = n / sum(n))
  
bs_ratio
```

```
##   buchstabe  n Prozent
## 1 Konsonant 21     0.7
## 2     Vokal  9     0.3
```

Der höhere Anteil der Konsonanten entspricht der größeren Konsonantenmenge.


```r
ggplot(bs_ratio, aes(x = "", y = Prozent, fill = buchstabe)) +
  geom_col(color = "black", size = 2) +
  coord_polar(theta = "y", start = -0 * pi / 180) +
  # scale_fill_discrete(labels = c("Konsonanten", "Vokale")) +
  scale_fill_manual(labels = c("Konsonanten", "Vokale"), 
                               values = c("#9E9AC8", "#6A51A3")) +
  theme(legend.position = "top", axis.text.y = element_blank(),
        axis.ticks = element_blank()) +
  labs(y = "", x = "Anteil % in Romanen") +
  scale_x_discrete(NULL, expand = c(0, 0)) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1), 
    breaks = seq(0, 1, 0.1)) # Prozent-Format und Einheiten
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-21-1.svg" width="10" height="8" />

Diese Zahlenwerte und -verhältnisse bilden einen möglichen Ausgangspunkt für intra- oder interlinguale Vergleiche. 


## Anzahl der Silben

Wie viele Silben kommen in den Romanen schätzungsweise vor und wie viele Buchstaben pro Silbe? Die genaue Bestimmung der Silbenanzahl für eine bestimmte Sprache kann aufgrund zahlreicher Besonderheiten ziemlich kompliziert sein. Die Anzahl der Silben schätzen wir daher mit einer Funktion des Programms *nsyllable* (Alternatives Programm: *qdap*). 

Da wir die Silbenzählfunktion nur ein einziges Mal bemühen, rufen wir sie in der unten sichtbaren Form auf: *nsyllable::nsyllable(buchstabenfolge)*.


```r
novels_words = novels %>%
  unnest_tokens(word, text, token = "words", to_lower = TRUE, drop = T) %>% 
  mutate(syllables = nsyllable::nsyllable(as.character(word), language = "en")) %>% 
  mutate(letters = nchar(word))
  
novels_words %>% head(100) %>% 
  DT::datatable(fillContainer = FALSE, filter = "top",
                options = list(pageLength = 6))
```

```{=html}
<div id="htmlwidget-c2a87616e6d698077889" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-c2a87616e6d698077889">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"disabled\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"disabled\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"6\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"17\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"],["prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt","prozess.txt"],["prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess","prozess"],["der","prozess","by","franz","kafka","aligned","by","bilingual","texts.com","fully","reviewed","der","prozess","franz","kafka","1","verhaftung","gespräch","mit","frau","grubach","dann","fräulein","brüstner","jemand","mußte","josef","k","verleumdet","haben","denn","ohne","daß","er","etwas","böses","getan","hätte","wurde","er","eines","morgens","verhaftet","die","köchin","der","frau","grubach","seiner","zimmervermieterin","die","ihm","jeden","tag","gegen","acht","uhr","früh","das","frühstück","brachte","kam","diesmal","nicht","das","war","noch","niemals","geschehen","k","wartete","noch","ein","weilchen","sah","von","seinem","kopfkissen","aus","die","alte","frau","die","ihm","gegenüber","wohnte","und","die","ihn","mit","einer","an","ihr","ganz","ungewöhnlichen","neugierde","beobachtete","dann","aber","gleichzeitig"],[1,2,1,1,2,2,1,3,2,2,2,1,2,1,2,null,3,1,3,1,2,1,2,1,2,2,2,1,3,2,1,2,1,1,2,1,2,1,2,1,2,2,3,1,1,1,1,2,2,6,1,1,2,1,2,1,1,null,1,null,2,1,2,1,1,1,1,2,3,1,3,1,1,2,1,1,2,3,1,1,2,1,1,1,3,2,1,1,1,3,2,1,1,1,4,3,4,1,2,3],[3,7,2,5,5,7,2,9,9,5,8,3,7,5,5,1,10,8,3,4,7,4,8,8,6,5,5,1,10,5,4,4,3,2,5,5,5,5,5,2,5,7,9,3,6,3,4,7,6,17,3,3,5,3,5,4,3,4,3,9,7,3,7,5,3,3,4,7,9,1,7,4,3,8,3,3,6,10,3,3,4,4,3,3,9,6,3,3,3,3,5,2,3,4,14,9,11,4,4,12]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>doc_id<\/th>\n      <th>title<\/th>\n      <th>word<\/th>\n      <th>syllables<\/th>\n      <th>letters<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":6,"columnDefs":[{"className":"dt-right","targets":[4,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[6,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
```
Insgesamt (d.h. kumulativ gesehen) fast 139 Tausend Silben in den Romanen. Diese Zahl bietet einen möglichen Ausgangspunkt für Textvergleiche.


```r
novels_words %>% 
  count(syllables) %>% 
  summarise(Silben = sum(n))
```

```
##   Silben
## 1 138811
```

Die meisten Wortformen in den Romanen bestehen aus einer Silbe (fast 60%) oder zwei Silben (fast 30%). Das ist typisch für deutsche Texte. Kurze Funktionswörter (meist eine Silbe) kommen wesentlich häufiger vor als andere Wortklassen (Substantive, Verben, Adjektive, Adverbien).


```r
novels_words %>% 
  count(syllables) %>% 
  mutate(Prozent = n / sum(n)) %>% 
  ggplot(aes(syllables, Prozent, fill = factor(syllables))) +
  geom_col() +
  theme(legend.position = "none") +
  labs(x = "Silben") +
  scale_y_continuous(
    labels = percent, 
    breaks = seq(0, 0.75, 0.1)) # Prozent-Format und Einheiten
```

```
## Warning: Removed 1 rows containing missing values (position_stack).
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-24-1.svg" width="10" height="8" />

Berücksichtig man lediglich distinktive Wortformen (also keine Wortwiederholungen), dann ergibt sich die folgende Verteilung, in der die Zweisilber (mehr als 30%) und Dreisilber (fast 30%) den größten Anteil haben.


```r
novels_words %>% 
  distinct(word, .keep_all = T) %>%
  count(syllables) %>% 
  mutate(Prozent = n / sum(n)) %>% 
  ggplot(aes(syllables, Prozent, fill = factor(syllables))) +
  geom_col() +
  theme(legend.position = "none") +
  labs(x = "Silben") +
  scale_y_continuous(
    labels = percent, 
    breaks = seq(0, 0.75, 0.1)) # Prozent-Format und Einheiten
```

```
## Warning: Removed 1 rows containing missing values (position_stack).
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-25-1.svg" width="10" height="8" />


## Mittlere Wortlänge

Wir können die Wortlänge in geschriebenen Texten auf zumindest zwei grundlegende Arten messen:
- die Anzahl der Silben pro Wort(form),
- die Anzahl der Buchstaben pro Wort(form).

Die durchschnittliche Anzahl der Silben und Buchstaben pro Wort (distinkte Wortformen !) in den Romanen ist in der folgenden Tabelle zu sehen: 
- neben den Mittelwerten (Avg_Silben, Avg_Buchstaben) 
- auch die  Standardabweichungen vom entsprechenden Mittelwert (Stdev_Silben, Stdev_Buchstaben). 
Die Mittelwerte oder arithmetischen Mittel können mit der Programmfunktion *mean()* berechnet werden, die Standardabweichungen mit der Funktion *sd()*.
Die Standardabweichungen sind notwendig zur Feststellung nicht-zufälliger Unterschiede zwischen den Stichproben (d.h. den Romanen).
Bei der Berechnung der Mittelwerte und Standardabweichungen geben wir dem Programm auch die Instruktion, etwaige leere Datenzeilen (*NA*) herauszufiltern, und zwar mit Hilfe von *na.rm = TRUE*. Wird dies unterlassen, kann dies dazu führen, dass ein Mittelwert bzw. Standardabweichung nicht berechnet werden kann. 

In der folgenden Tabelle werden nur distinktive Wortformen (Types) berücksichtigt, d.h. als ob jede Wortform nur einmal pro Roman vorkommt.


```r
novels_words %>% 
  group_by(title) %>% 
  distinct(word, .keep_all = T) %>%
  add_count(word) %>% 
  summarise(Avg_Silben = mean(syllables, na.rm = TRUE),
            Stdev_Silben = sd(syllables, na.rm = TRUE),
            Avg_Buchstaben = mean(letters, na.rm = TRUE),
            Stdev_Buchstaben = sd(letters, na.rm = TRUE)) %>% 
    DT::datatable(fillContainer = TRUE, filter = "top",
                options = list(pageLength = 4))
```

```{=html}
<div id="htmlwidget-cc502a23cfbb4c1c7784" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-cc502a23cfbb4c1c7784">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"2.44014808720691\" data-max=\"2.59895301327886\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1.07231896430153\" data-max=\"1.11520707077877\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"8.32560032560032\" data-max=\"8.75313648460272\" data-scale=\"14\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"3.03924466546716\" data-max=\"3.16598504848814\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":true,"data":[["1","2"],["prozess","tom"],[2.59895301327886,2.44014808720691],[1.11520707077877,1.07231896430153],[8.75313648460271,8.32560032560033],[3.16598504848814,3.03924466546716]],"container":"<table class=\"display fill-container\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>title<\/th>\n      <th>Avg_Silben<\/th>\n      <th>Stdev_Silben<\/th>\n      <th>Avg_Buchstaben<\/th>\n      <th>Stdev_Buchstaben<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":4,"columnDefs":[{"className":"dt-right","targets":[2,3,4,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[4,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
```

Die durchschnittliche Anzahl der Silben und Buchstaben pro Wortform (Token), bei Berücksichtigung von Wortwiederholungen in den Romanen, ist in der folgenden Tabelle zu sehen. 


```r
novels_words %>% 
  group_by(title) %>% 
  summarise(Avg_Silben = mean(syllables, na.rm = TRUE),
            Stdev_Silben = sd(syllables, na.rm = TRUE),
            Avg_Buchstaben = mean(letters, na.rm = TRUE),
            Stdev_Buchstaben = sd(letters, na.rm = TRUE)) %>% 
    DT::datatable(fillContainer = TRUE, filter = "top",
                options = list(pageLength = 4))
```

```{=html}
<div id="htmlwidget-9844942399160d3b0e58" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-9844942399160d3b0e58">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1.56130740985975\" data-max=\"1.61334968218398\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0.817606898423074\" data-max=\"0.875273866110269\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"4.97530422866676\" data-max=\"5.04886011663923\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"2.6346514838852\" data-max=\"2.81831861481201\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":true,"data":[["1","2"],["prozess","tom"],[1.61334968218398,1.56130740985975],[0.875273866110269,0.817606898423074],[5.04886011663923,4.97530422866676],[2.81831861481201,2.6346514838852]],"container":"<table class=\"display fill-container\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>title<\/th>\n      <th>Avg_Silben<\/th>\n      <th>Stdev_Silben<\/th>\n      <th>Avg_Buchstaben<\/th>\n      <th>Stdev_Buchstaben<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":4,"columnDefs":[{"className":"dt-right","targets":[2,3,4,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[4,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
```

## Testen von Mittelwertunterschieden

### t-Test

Sind die berechneten Unterschiede zwischen den Mittelwerten relevant bzw. nicht-zufällig? Um diese Frage zu klären, kann man einen statistischen Test bemühen. Da wir lediglich zwei Samples (zwei Romanen) vergleichen wollen, kann uns ein parametrischer Test wie z.B. der t-Test Klarheit verschaffen. Wir verwenden die Programmfunktion *t.test()*.
Der t-Test bestätigt, dass "Der Prozess" im Durchschnitt etwas längere Wörter aufweist (2,59 Silben pro Wort gegenüber 2,44 Silben pro Wort in "Tom Sawyer") - wenn Anzahl distinktiver Wortformen verwendet.


```r
syls = novels_words %>% 
  group_by(title) %>% 
  distinct(word, .keep_all = T) %>%
  add_count(word) %>% 
  drop_na() %>% 
  dplyr::select(title, word, syllables) %>% 
  pivot_wider(names_from = title, values_from = syllables)

t.test(syls$prozess, syls$tom, var.equal = TRUE) # significant
```

```
## 
## 	Two Sample t-test
## 
## data:  syls$prozess and syls$tom
## t = 9.5813, df = 17554, p-value < 2.2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.1263172 0.1912927
## sample estimates:
## mean of x mean of y 
##  2.598953  2.440148
```

Wenn die Wiederholung von Wortformen berücksichtigt wird, bestätigt der t-Test ebenfalls einen signifikanten Unterschied zwischen den beiden Texten. Die durchschnittliche Anzahl der Wortsilben ist niedriger, da kürzere Wortformen (solche von Konjunktionen, Präpositionen, Artikeln und anderen Funktionswörtern) häufig vorkommen.

Schnelle Form des t-Tests:


```r
t.test(syllables ~ title, data = novels_words, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  syllables by title
## t = 11.37, df = 137403, p-value < 2.2e-16
## alternative hypothesis: true difference in means between group prozess and group tom is not equal to 0
## 95 percent confidence interval:
##  0.04307118 0.06101337
## sample estimates:
## mean in group prozess     mean in group tom 
##              1.613350              1.561307
```

Dasselbe Ergebnis, aber aufwendiger zu programmieren, um den Datensatz in die entsprechende Form zu bringen:


```r
prozess_syl <- novels_words %>% 
  filter(title == "prozess") %>% 
  dplyr::select(syllables) %>% 
  rename(prozess = syllables)
tom_syl <- novels_words %>% 
  filter(title == "tom") %>% 
  dplyr::select(syllables) %>% 
  rename(prozess = syllables)
  
t.test(prozess_syl, tom_syl, var.equal = T) # significant
```

```
## 
## 	Two Sample t-test
## 
## data:  prozess_syl and tom_syl
## t = 11.37, df = 137403, p-value < 2.2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.04307118 0.06101337
## sample estimates:
## mean of x mean of y 
##  1.613350  1.561307
```

Der nächste t-Test bestätigt ebenfalls, dass "Der Prozess" im Durchschnitt längere Wörter aufweist (8,79 Buchstaben pro Wort gegenüber 8.36 Buchstaben pro Wort in "Tom Sawyer".) Berücksichtigt wurden distinkte Wortformen (keine wiederholten Wortformen).


```r
lets = novels_words %>% 
  group_by(title) %>% 
  distinct(word, .keep_all = T) %>%
  add_count(word) %>% 
  drop_na() %>% 
  dplyr::select(title, word, letters) %>% 
  pivot_wider(names_from = title, values_from = letters)

t.test(lets$prozess, lets$tom, var.equal = T) # significant
```

```
## 
## 	Two Sample t-test
## 
## data:  lets$prozess and lets$tom
## t = 9.0317, df = 17554, p-value < 2.2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.3310081 0.5145045
## sample estimates:
## mean of x mean of y 
##  8.785878  8.363122
```

Wenn die Wiederholung von Wortformen berücksichtigt wird, bestätigt der t-Test wiederum einen signifikanten Unterschied zwischen den beiden Texten. Die durchschnittliche Anzahl der Buchstaben pro Wort ist niedriger, da kürzere Wortformen (solche von Konjunktionen, Präpositionen, Artikeln und anderen Funktionswörtern) häufig vorkommen.

Schnelle Form des t-Tests:


```r
t.test(letters ~ title, data = novels_words, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  letters by title
## t = 5.0147, df = 138809, p-value = 5.319e-07
## alternative hypothesis: true difference in means between group prozess and group tom is not equal to 0
## 95 percent confidence interval:
##  0.04480651 0.10230526
## sample estimates:
## mean in group prozess     mean in group tom 
##              5.048860              4.975304
```

Dasselbe Ergebnis, aber aufwendiger zu programmieren, um den Datensatz in die entsprechende Form zu bringen:


```r
prozess_let <- novels_words %>% 
  filter(title == "prozess") %>% 
  dplyr::select(letters) %>% 
  rename(prozess = letters)
tom_let <- novels_words %>% 
  filter(title == "tom") %>% 
  dplyr::select(letters) %>% 
  rename(prozess = letters)
  
t.test(prozess_let, tom_let, var.equal = TRUE) # significant
```

```
## 
## 	Two Sample t-test
## 
## data:  prozess_let and tom_let
## t = 5.0147, df = 138809, p-value = 5.319e-07
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.04480651 0.10230526
## sample estimates:
## mean of x mean of y 
##  5.048860  4.975304
```


### Lineare Regression

Hat man mehr als zwei Stichproben zu vergleichen, kann man eine lineare Regression durchführen, die auch das Testen von mehreren Einflussgrößen (Prädiktoren) erlaubt. 

Hier folgt eine Demonstration anhand des bereits gehabten Datensatzes mit zwei Stichproben (Romanen).
Die Ordinate im Koordinatensystem (Intercept, also der y-Abschnitt mit x = 0) ist bei zwei Stichproben gleich dem Mittelwert der ersten Stichprobe (title = "prozess"), d.h. 1,613350. Der geschätzte Mittelwert (Estimate) der zweiten Stichprobe (title = "tom") ist um den Wert 0,052042 niedriger, d.h. 1,613350 - 0,052042 = 1,561308 (Dezimalkommas statt Dezimalpunkte!).

Der R-Quadrat-Wert (R-squared) ist allerdings sehr klein, d.h. dass der Prädiktor "title" (Roman) nur einen Bruchteil der festgestellten Mittelwertvarianz (Veränderungen der Mittelwerte) zu erklären vermag. Möglicherweise gibt es andere Prädiktoren, die die Mittelwertvarianz besser erklären. 


```r
m <- lm(syllables ~ title, data = novels_words)
summary(m)
```

```
## 
## Call:
## lm(formula = syllables ~ title, data = novels_words)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.6133 -0.6133 -0.5613  0.4387  6.3867 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.613350   0.003183  506.85   <2e-16 ***
## titletom    -0.052042   0.004577  -11.37   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.8479 on 137403 degrees of freedom
##   (1406 observations deleted due to missingness)
## Multiple R-squared:  0.00094,	Adjusted R-squared:  0.0009327 
## F-statistic: 129.3 on 1 and 137403 DF,  p-value: < 2.2e-16
```

```r
anova(m)
```

```
## Analysis of Variance Table
## 
## Response: syllables
##               Df Sum Sq Mean Sq F value    Pr(>F)    
## title          1     93  92.937  129.28 < 2.2e-16 ***
## Residuals 137403  98778   0.719                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Graphische Darstellung: der Mittelwertunterschied ist gering (nur 0,05 Silben), aber aufgrund der großen Stichproben statistisch signifikant. Der Faktor "title" erklärt nur einen verschwinded kleinen Bruchteil der Mittelwertunterschiede.


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
##  model: syllables ~ title
## 
##  title effect
## title
##  prozess      tom 
## 1.613350 1.561307
```

```r
plot(allEffects(m))
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-35-1.svg" width="10" height="8" />

Ergebnisse in Tabellenform:


```r
summary(lm(syllables ~ title, data = novels_words)) %>% 
  broom::tidy() %>% 
    DT::datatable(fillContainer = TRUE, filter = "top",
                options = list(pageLength = 4))
```

```{=html}
<div id="htmlwidget-547bdffcc2553337830b" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-547bdffcc2553337830b">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"-0.0520422723243\" data-max=\"1.61334968218468\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0.003183071080932\" data-max=\"0.004577133472566\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"-11.3700578399633\" data-max=\"506.8531745487\" data-scale=\"14\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"1e-15\" data-scale=\"15\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":true,"data":[["1","2"],["(Intercept)","titletom"],[1.61334968218468,-0.0520422723242994],[0.00318307108093227,0.0045771334725653],[506.8531745487,-11.3700578399633],[0,6.07958976922604e-30]],"container":"<table class=\"display fill-container\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>term<\/th>\n      <th>estimate<\/th>\n      <th>std.error<\/th>\n      <th>statistic<\/th>\n      <th>p.value<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":4,"columnDefs":[{"className":"dt-right","targets":[2,3,4,5]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[4,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
```

Boxplot mit Jitterplot anhand des vollen Datensatzes: der Mittelwert ist hier der Median *median()* (d.h. ein Wert, der genau in der Mitte jeder Stichprobe liegt), das arithmetische Mittel / der Durchschnitt wird hier mit einem roten Quadrat symbolisiert. Der Median liegt in beiden Stichproben beim Wert 1, also weit unter dem jeweiligen Durchschnittswert. Dies zeigt, dass die Wortlängen nicht normalverteilt sind. Der Jitterplot veranschaulicht, dass der "Prozess" über mehr Wortformen mit 6, 7 oder 8 Silben verfügt.


```r
novels_words %>% 
  group_by(title) %>% 
  ggplot(aes(title, syllables, fill = title, group = title)) +
  geom_jitter(width = 0.4, alpha = 0.5, color = "gray70") +
  geom_boxplot(notch = FALSE, width = 0.8) +
  stat_summary(fun.y="mean", color = "red", shape = 15)+
  expand_limits(y = -1) +
  scale_y_continuous(breaks = seq(-1, 8, 1)) +
  theme(legend.position = "none") +
  labs(y = "Mittlere Wortlänge (in Silben)", x = "Roman")
```

```
## Warning: `fun.y` is deprecated. Use `fun` instead.
```

```
## Warning: Removed 1406 rows containing non-finite values (stat_boxplot).
```

```
## Warning: Removed 1406 rows containing non-finite values (stat_summary).
```

```
## Warning: Removed 1406 rows containing missing values (geom_point).
```

```
## Warning: Removed 2 rows containing missing values (geom_segment).
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-37-1.svg" width="10" height="8" />

Boxplot anhand der zusammengefassten Daten (Durchschnitt, Standardabweichung):


```r
df = novels_words %>% 
  group_by(title) %>% 
  summarise(Avg_Silben = mean(syllables, na.rm = TRUE),
            Stdev_Silben = sd(syllables, na.rm = TRUE),
            Avg_Buchstaben = mean(letters, na.rm = TRUE),
            Stdev_Buchstaben = sd(letters, na.rm = TRUE))

df %>% ggplot(aes(title, Avg_Silben, fill = title, group = title)) +
  geom_pointrange(aes(ymin = Avg_Silben - Stdev_Silben, ymax = Avg_Silben + Stdev_Silben),
               stat="identity") +
  theme(legend.position = "none") +
  labs(y = "Mittlere Wortlänge (in Silben)")
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-38-1.svg" width="10" height="8" />

```r
df %>% ggplot(aes(title, fill = title, group = title)) +
  geom_boxplot(aes(lower = Avg_Silben - Stdev_Silben, upper = Avg_Silben + Stdev_Silben,
                   middle = Avg_Silben,
                   ymin = Avg_Silben - 3*Stdev_Silben, ymax = Avg_Silben + 3*Stdev_Silben),
               stat="identity") +
  theme(legend.position = "none") +
  labs(y = "Mittlere Wortlänge (in Silben)")
```

<img src="19-Letter_frequency_files/figure-html/unnamed-chunk-38-2.svg" width="10" height="8" />

## Quanteda-Funktionen

Eine alternative Berechnung der Anzahl der Buchstaben pro Wort mit *quanteda* (ohne t-Test). 

Die Durchschnittswerte, die uns quanteda liefert, sind etwas höher als die tidyverse-Werte. Aber auch hier ist der Mittelwert für den "Prozess" höher als für "Tom Sawyer".


```r
library(quanteda)
library(quanteda.textstats)
corp = corpus(novels_txt)
stats = textstat_summary(corp)

stats %>% paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["document"],"name":[1],"type":["chr"],"align":["left"]},{"label":["chars"],"name":[2],"type":["int"],"align":["right"]},{"label":["sents"],"name":[3],"type":["int"],"align":["right"]},{"label":["tokens"],"name":[4],"type":["int"],"align":["right"]},{"label":["types"],"name":[5],"type":["int"],"align":["right"]},{"label":["puncts"],"name":[6],"type":["int"],"align":["right"]},{"label":["numbers"],"name":[7],"type":["int"],"align":["right"]},{"label":["symbols"],"name":[8],"type":["int"],"align":["right"]},{"label":["urls"],"name":[9],"type":["int"],"align":["right"]},{"label":["tags"],"name":[10],"type":["int"],"align":["right"]},{"label":["emojis"],"name":[11],"type":["int"],"align":["right"]}],"data":[{"1":"prozess.txt","2":"482722","3":"3845","4":"88010","5":"7907","6":"16380","7":"10","8":"0","9":"0","10":"0","11":"0","_rn_":"1"},{"1":"tom.txt","2":"460249","3":"4652","4":"85841","5":"9860","6":"18785","7":"9","8":"0","9":"0","10":"0","11":"0","_rn_":"2"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
stats %>% 
  group_by(document) %>% 
  transmute(buchstaben = (chars-puncts)/tokens) %>% paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["document"],"name":[1],"type":["chr"],"align":["left"]},{"label":["buchstaben"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"prozess.txt","2":"5.298739"},{"1":"tom.txt","2":"5.142811"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Die Durchschnittswerte unterscheiden sich in den Berechnungen (tidyverse vs. quanteda), was mit der verschiedenen Art der Tokenisierung und der Aussonderung von nicht relevanten Tokens und leeren Datenzeilen (NA) zu tun hat. 


## Konsonantenverbindungen

Welche Konsonantenverbindungen (Buchstabenverbindungen) kommen häufiger vor in den Texten?
Wir zerlegen die Texte im Korpus in kleinere Einheiten (mittels *tokens*()), aber dieses Mal in alphanumerische Zeichen (Buchstaben). 
Anschließend wenden wir *char_ngrams()*-Funktion an, mit der man Verknüpfungen von Zeichen feststellen kann.


```r
tok_ch = tokens(corp, what = "character", remove_punct = TRUE, remove_symbols = T, remove_numbers = T, remove_url = T, remove_separators = T)

ngrams_ch = char_ngrams(as.character(tok_ch), n = c(2,3,4), concatenator = "")
```

Wir wandeln die ngram-Liste in einen Datensatz um (mittels *tibble()*), was das Zählen mit einer *tidyverse*-Funktion ermöglicht.


```r
ngrams_char = ngrams_ch %>% 
  as_tibble() %>% 
  rename(cluster = value)

ngrams_char %>% 
  count(cluster, sort = TRUE) %>% 
  head(10) %>% 
    DT::datatable(fillContainer = FALSE, filter = "top",
                options = list(pageLength = 10))
```

```{=html}
<div id="htmlwidget-9fcaeec83937097e8564" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-9fcaeec83937097e8564">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"10119\" data-max=\"26084\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","fillContainer":false,"data":[["1","2","3","4","5","6","7","8","9","10"],["en","er","ch","te","ei","nd","de","ie","in","ic"],[26084,23737,22570,15489,14106,12972,12831,11753,11525,10119]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>cluster<\/th>\n      <th>n<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true}},"evals":[],"jsHooks":[]}</script>
```


to be continued ...


## Datensatz-Variante



```r
novels_words_char <- novels %>%
  unnest_tokens(word, text, token = "words", to_lower = TRUE, drop = T) %>% 
  mutate(Silben = nsyllable::nsyllable(as.character(word), language = "en")) %>% 
  unnest_tokens(character, word, token = "characters", to_lower = TRUE, drop = F) %>% 
  mutate(buchstabe = ifelse(str_detect(character, vokale), "Vokal", "Konsonant"))
  
head(novels_words_char) %>% 
  head(10) %>% 
  rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["doc_id"],"name":[1],"type":["chr"],"align":["left"]},{"label":["title"],"name":[2],"type":["chr"],"align":["left"]},{"label":["word"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Silben"],"name":[4],"type":["int"],"align":["right"]},{"label":["character"],"name":[5],"type":["chr"],"align":["left"]},{"label":["buchstabe"],"name":[6],"type":["chr"],"align":["left"]}],"data":[{"1":"prozess.txt","2":"prozess","3":"der","4":"1","5":"d","6":"Konsonant","_rn_":"1"},{"1":"prozess.txt","2":"prozess","3":"der","4":"1","5":"e","6":"Vokal","_rn_":"2"},{"1":"prozess.txt","2":"prozess","3":"der","4":"1","5":"r","6":"Konsonant","_rn_":"3"},{"1":"prozess.txt","2":"prozess","3":"prozess","4":"2","5":"p","6":"Konsonant","_rn_":"4"},{"1":"prozess.txt","2":"prozess","3":"prozess","4":"2","5":"r","6":"Konsonant","_rn_":"5"},{"1":"prozess.txt","2":"prozess","3":"prozess","4":"2","5":"o","6":"Vokal","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

