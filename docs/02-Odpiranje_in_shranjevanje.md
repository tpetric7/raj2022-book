# R & RStudio

## Programme

In diesem Kapitel verwenden wir die folgenden Programme und Programmbündel:


```r
library(tidyverse) # viele verschiedene tabellenorientierte Funktionen
library(readtext) # Texte lesen
library(readxl) # Excel-Tabellen lesen
library(writexl) # Excel-Tabellen schreiben
library(rmarkdown) # hier für besseres Tabellenformat
library(kableExtra) # für besseres Tabellenformat 
```

Načinov za odpiranje in shranjevanje datotek je veliko. Tule bom pokazal nekaj preprostih:

## Textdatei öffnen

Funkcija `read_lines()`: odpremo besedilo v izbrani mapi in ga shranimo v spremenljivki (npr. "besedilo").

Odpiranje besedila s spletnega naslova (url) je možen.


```r
library(tidyverse)
besedilo = read_lines("data/books/tom.txt")
```

## Mehrere Textdateien öffnen

Funkcija `readtext()`: če namesto imena datotek navedemo samo zvezdico + pripono datotek (npr. \*.txt) v izbrani mapi (npr. "data/books/"), potem bo program odprl vse besedilne datoteke s to pripono in to zbirko shranil v spremenljivki (npr. "besedila"). Program ustvari tabelo odprtih besedil.

`readtext()` odpira različne besedila z različnimi priponami: txt, csv, docx, pdf, xml, ...

Odpiranje besedila s spletnega naslova (`url`) je možen.


```r
library(readtext)
besedila = readtext("data/books/*.txt", encoding = "UTF-8")
besedila
```

```
## readtext object consisting of 2 documents and 0 docvars.
## # Description: df [2 x 2]
##   doc_id      text               
##   <chr>       <chr>              
## 1 prozess.txt "\"Der Prozes\"..."
## 2 tom.txt     "\"Tom Sawyer\"..."
```

## Tabelle öffnen

Funkcija `read_csv()` ali `read_csv2()` sta le dve izmed številnih funkcij za odpiranje preglednice s pripono *csv*.

Odpiranje besedila s spletnega naslova (`url`) je možen.


```r
library(tidyverse)
tabela = read_csv2("data/plural_Subj_sum.csv")
head(tabela) %>% 
  rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SubjID"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["WordType"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Genus"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Sigstark"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["En"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["E"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Er"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["S"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"NoRhyme","3":"Fem","4":"4.983333","5":"8","6":"4","7":"0","8":"0","9":"0"},{"1":"1","2":"NoRhyme","3":"Masc","4":"4.600000","5":"6","6":"6","7":"0","8":"0","9":"0"},{"1":"1","2":"NoRhyme","3":"Neut","4":"5.366667","5":"10","6":"2","7":"0","8":"0","9":"0"},{"1":"1","2":"Rhyme","3":"Fem","4":"3.836667","5":"3","6":"8","7":"0","8":"0","9":"1"},{"1":"1","2":"Rhyme","3":"Masc","4":"4.153333","5":"5","6":"5","7":"1","8":"0","9":"1"},{"1":"1","2":"Rhyme","3":"Neut","4":"3.784167","5":"3","6":"7","7":"1","8":"0","9":"1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

## Excel-Tabelle öffnen

Funkcija `read_xlsx()` ali `read_excel()` omogoča odpiranje Excelove preglednice s pripono *xlsx*.


```r
library(readxl)
excel = read_xlsx("data/S03_Vokalformanten_Diagramme.xlsx", sheet = "A1-4_alle")
head(excel) %>% 
  rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Studierende"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Phrase"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Wort"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Vokal"],"name":[4],"type":["chr"],"align":["left"]},{"label":["Vowel"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Dauer"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Länge"],"name":[7],"type":["chr"],"align":["left"]},{"label":["F1"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["F2"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["Sprecherin"],"name":[10],"type":["chr"],"align":["left"]},{"label":["L1_L2"],"name":[11],"type":["chr"],"align":["left"]}],"data":[{"1":"Monika","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"155","7":"lang","8":"296","9":"2750","10":"Deutsche","11":"L1"},{"1":"Metka","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"154","7":"lang","8":"269","9":"2752","10":"Deutsche","11":"L1"},{"1":"Adelina","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"155","7":"lang","8":"273","9":"2750","10":"Deutsche","11":"L1"},{"1":"Jasmina","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"152","7":"lang","8":"270","9":"2767","10":"Deutsche","11":"L1"},{"1":"Donna","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"66","7":"lang","8":"492","9":"2312","10":"Deutsche","11":"L1"},{"1":"Mateja","2":"Phrase 001","3":"bieten","4":"i:","5":"ii","6":"53","7":"lang","8":"1678","9":"2665","10":"Deutsche","11":"L1"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

## Datei speichern

Privzeto spodnji programi shranjujejo v obliki (codepage) `encoding = "UTF-8"` / `fileEncoding = "UTF-8"`.


```r
library(tidyverse)

# shranjevanje posamičnega besedila
write_lines(besedilo, "moje_besedilo.txt")

# shranjevanje tabele, v kateri je zbirka besedil
write_csv2(besedila, "moja_tabela_z_besedili.csv")

library(writexl)
# shranjevanje preglednice
write_xlsx(tabela, "moja_tabela.xlsx")

# shranjevanje tabele, v kateri je zibrka besedil
# Excel dovoljuje do 32767 znakov.
# ta zbirko presega to mejo, zato je ne moremo shraniti v Excelovi preglednici

# write_xlsx(besedila, "moja_tabela_z_besedili.xlsx")
```

Basic operations in R: \* Download (zip) files \* Extract compressed files to a folder \* Check & Create a folder or subfolders \* List & Read files in a folder

## Download


```r
download.file("https://github.com/tpetric7/tpetric7.github.io/archive/refs/heads/main.zip",
              "d:/Users/teodo/Downloads/tpetric7-master.zip")
```

## Check & create directory


```r
pot <- "d:/Users/teodo/Downloads/tpetric7-master"
exist <- dir.exists(pot)
exist
```

```
## [1] TRUE
```


```r
ifelse(exist == FALSE, 
       dir.create(pot, showWarnings = TRUE, recursive = TRUE), 
       "directory already exists")
```

```
## [1] "directory already exists"
```

## Unzip


```r
unzip("d:/Users/teodo/Downloads/tpetric7-master.zip", exdir = pot)
```

## Create subfolders


```r
subfolder_names <- c("a","b","c","d") 
for (i in 1:length(subfolder_names)){
  folder <- dir.create(paste0(pot, "/", subfolder_names[i]))
}
```

## List files


```r
seznam <- list.files(pot, pattern = "\\.txt$", recursive = TRUE, full.names = TRUE)
seznam
```

```
##  [1] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/BAWLR_utf8.txt"                                                                     
##  [2] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/prozess.txt"                                                                  
##  [3] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/tom.txt"                                                                      
##  [4] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/metamorph/metamorphosis.txt"                                     
##  [5] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/metamorph/verwandlung.txt"                                       
##  [6] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/prozess/prozess.txt"                                             
##  [7] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/prozess/trial.txt"                                               
##  [8] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/sawyer/tom_de.txt"                                               
##  [9] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/translations/sawyer/tom_en.txt"                                               
## [10] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/books/verwandlung/verwandlung.txt"                                                  
## [11] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/chisq_kommentare.txt"                                                               
## [12] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/lemmatization_de.txt"                                                               
## [13] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/data/stopwords_de_voyant_tools.txt"                                                      
## [14] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/moje_besedilo.txt"                                                                       
## [15] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/pictures/vokalformanten_interaktiv_l1_l2_lang_kurz_files/jquery-3.5.1/jquery-AUTHORS.txt"
## [16] "d:/Users/teodo/Downloads/tpetric7-master/tpetric7.github.io-main/tmp_files/jquery-3.5.1/jquery-AUTHORS.txt"
```

## Read files

### tidyverse:


```r
library(tidyverse)
alltxt <- seznam %>% map(read_lines)

substr(alltxt[1], 1, 50)
```

```
## [1] "c(\"EmoVal\\tFreq\\tWORD\\tWORD_LOWER\\tWORD_CLASS\\tEMO"
```

```r
substr(alltxt[2], 1, 70)
```

```
## [1] "Der Prozess by Franz Kafka Aligned by : bilingual-texts.com ( fully re"
```

### Base R:


```r
alltxt <- lapply(seznam, readLines)

substr(alltxt[1], 1, 50)
```

```
## [1] "c(\"EmoVal\\tFreq\\tWORD\\tWORD_LOWER\\tWORD_CLASS\\tEMO"
```

```r
substr(alltxt[2], 1, 70)
```

```
## [1] "Der Prozess by Franz Kafka Aligned by : bilingual-texts.com ( fully re"
```

## Konversion

R scripts kann man ins Rmd-Dateiformat umwandeln (konvertieren), und zwar mittels:

-   `[Ctrl + Shift + K]` oder
-   `knitr::spin("t_preskus.R")`

Da beide Dateiformate Textdateien darstellen, ist es auch relativ leicht, sie in andere Formate umwandeln.
