# Konnektoren

## Pakete


```r
library(tidyverse)
library(scales)
library(janitor)
library(readtext)
library(quanteda)
library(quanteda.textmodels)
library(quanteda.textstats)
library(quanteda.textplots)
library(tidytext)
library(readxl)
library(writexl)
library(udpipe)
```

## Text einlesen


```r
txt = readtext("data/books/*.txt", encoding = "UTF-8")
txt
```

```
## readtext object consisting of 2 documents and 0 docvars.
## # Description: df [2 x 2]
##   doc_id      text               
##   <chr>       <chr>              
## 1 prozess.txt "\"Der Prozes\"..."
## 2 tom.txt     "\"Tom Sawyer\"..."
```

## UDPipe laden


```r
library(udpipe)
destfile = "german-gsd-ud-2.5-191206.udpipe"

if(!file.exists(destfile)){
   sprachmodell <- udpipe_download_model(language = "german")
   udmodel_de <- udpipe_load_model(sprachmodell$file_model)
   } else {
  file_model = destfile
  udmodel_de <- udpipe_load_model(file_model)
}
```

## Text annotieren

https://universaldependencies.org/


```r
# Na začetku je readtext prebral besedila, shranili smo jih v spremenljivki "txt".
x <- udpipe_annotate(udmodel_de, x = txt$text, trace = TRUE)
```

```
## 2022-03-20 18:42:49 Annotating text fragment 1/2
## 2022-03-20 18:45:55 Annotating text fragment 2/2
```

```r
# # samo prvo besedilo:
# x <- udpipe_annotate(udmodel_de, x = txt$text[1], trace = TRUE)

x <- as.data.frame(x)
```



```r
# write_rds(x, "data/prozess_tom_udpiped.rds")
# x = read_rds("data/prozess_tom_udpiped.rds")
```

## Wortklassen und Konnektoren


```r
tabela = x %>% 
  group_by(doc_id) %>% 
  count(upos) %>% 
  filter(!is.na(upos),
         upos != "PUNCT")
head(tabela) %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["doc_id"],"name":[1],"type":["chr"],"align":["left"]},{"label":["upos"],"name":[2],"type":["chr"],"align":["left"]},{"label":["n"],"name":[3],"type":["int"],"align":["right"]}],"data":[{"1":"doc1","2":"ADJ","3":"5284"},{"1":"doc1","2":"ADP","3":"6350"},{"1":"doc1","2":"ADV","3":"8387"},{"1":"doc1","2":"AUX","3":"4390"},{"1":"doc1","2":"CCONJ","3":"2425"},{"1":"doc1","2":"DET","3":"8050"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
vezniki = tabela %>% 
  filter(upos %in% c("CCONJ", "SCONJ")) %>% 
  mutate(prozent = n/sum(n)) %>% 
  pivot_wider(id_cols = upos, 
              names_from = doc_id, values_from = n:prozent)
head(vezniki) %>% rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["upos"],"name":[1],"type":["chr"],"align":["left"]},{"label":["n_doc1"],"name":[2],"type":["int"],"align":["right"]},{"label":["n_doc2"],"name":[3],"type":["int"],"align":["right"]},{"label":["prozent_doc1"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["prozent_doc2"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"CCONJ","2":"2425","3":"3270","4":"0.5897374","5":"0.7161629"},{"1":"SCONJ","2":"1687","3":"1296","4":"0.4102626","5":"0.2838371"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>



```r
konnektoren = x %>% 
  mutate(token = str_to_lower(token)) %>% 
  group_by(doc_id, token) %>% 
  filter(!is.na(upos),
         upos != "PUNCT") %>% 
  filter(upos %in% c("CCONJ", "SCONJ")) %>% 
  count(upos, sort = T)
```



```r
connectors = x %>% 
  mutate(token = str_to_lower(token)) %>% 
  group_by(token) %>% 
  filter(!is.na(upos),
         upos != "PUNCT") %>% 
  filter(upos %in% c("CCONJ", "SCONJ")) %>% 
  count(upos, sort = T)
```



```r
connectors %>% filter(upos == "CCONJ") %>% pull(token) %>% head(50)
```

```
##  [1] "und"                 "aber"                "oder"               
##  [4] "denn"                "sondern"             "wie"                
##  [7] "als"                 "weder"               "doch"               
## [10] "noch"                "schrie"              "kroch"              
## [13] "desto"               "um"                  "woher"              
## [16] "du"                  "entweder"            "hatte"              
## [19] "sowie"               "statt"               ",aber"              
## [22] ",und"                "sowohl"              "irgendwie"          
## [25] "unnötigerweise"      ",denn"               ",nun"               
## [28] "aschfahl"            "aß"                  "ausnahmsweise"      
## [31] "besinn"              "brauch"              "daß"                
## [34] "dazu"                "dennoch"             "genau"              
## [37] "hoch"                "insbesondere"        "kund"               
## [40] "laß"                 "manch"               "ob"                 
## [43] "sinn"                "stahl"               "such"               
## [46] "unvorsichtigerweise" "verzeih"             "wieder"             
## [49] "wozu"
```


```r
connectors %>% filter(upos == "SCONJ") %>% pull(token) %>% head(50)
```

```
##  [1] "daß"         "wenn"        "als"         "wie"         "da"         
##  [6] "denn"        "während"     "ob"          "bis"         "weil"       
## [11] "obwohl"      "indem"       "laß"         "nachdem"     "damit"      
## [16] "sobald"      "ehe"         "ohne"        "solange"     "soweit"     
## [21] "bevor"       "das"         "aber"        "seit"        "seitdem"    
## [26] "strich"      "gleich"      "begann"      "falls"       "vergaß"     
## [31] "worum"       "halb"        "hätt"        "maß"         "sehe"       
## [36] "statt"       "warum"       "wohl"        ",das"        ",denn"      
## [41] ",ich"        "befahl"      "bestrich"    "dann"        "dasaß"      
## [46] "dass"        "fern"        "fortwährend" "fühl"        "gebührend"
```

Wir können auch Listen mit neben- und unterordnenden Konjunktionen sowie Konjunktionaladverbien aus dem Internet abrufen. Dann können wir sie genauer zählen. 

<!-- Z medmrežja lahko tudi potegnemo sezname prirednih in podrednih veznikov ter vezniških prislovov (Konjunktionaladverbien). -->
<!-- Potem jih lahko natančneje preštejemo -->

case_when
str_detect(seznam_prirednih_konektorjev, "...|...|...")
str_detect(seznam_podrednih_konektorjev, "...|...|...")
str_detect(seznam_prislovnih_konektorjev, "...|...|...")
