# Untertitel

## Programme starten


```r
library(tidyverse)
library(scales)
library(udpipe)
stringsAsFactors = FALSE
```

## Daten laden

Die englischen und deutschen Untertitel zum Film *Avatar* stammen aus der Datensammlung von *Natalia Levshina* [@levshina2015linguistics], die slowenischen Untertitel stammen von der Webseite *nachschauen*. 

Zuerst laden wir die Untertitel zum Film *Avatar* in englischer, deutscher und slowenischer Sprache. 


```r
library(tidyverse)
avatar_eng = read_lines("data/sub/Avatar_eng.txt")
avatar_deu = read_lines("data/sub/Avatar_deu.txt")
avatar_slv = read_lines("data/sub/Avatar_slv.txt")
```



```r
head(avatar_eng); head(avatar_deu); head(avatar_slv)
```

```
## [1] "1"                                         
## [2] "00:00:39,799 --> 00:00:42,039"             
## [3] "When I was lying there in the VA hospital,"
## [4] ""                                          
## [5] "2"                                         
## [6] "00:00:42,176 --> 00:00:45,136"
```

```
## [1] "1"                                       
## [2] "00:00:39,798 --> 00:00:42,091"           
## [3] "Als ich da im Veteranen-Krankenhaus lag,"
## [4] ""                                        
## [5] "2"                                       
## [6] "00:00:42,176 --> 00:00:45,136"
```

```
## [1] ""                                           
## [2] "1"                                          
## [3] "00:00:38,160 --> 00:00:40,720"              
## [4] "<i>Ko sem ležal v veteranski bolnišnici</i>"
## [5] ""                                           
## [6] "2"
```

## Datensätze vorbereiten

### Textspalte vorbereiten

Untertitel haben ein besonderes Format. Recht einfach sind Datenmodifizierungen mit den tidyverse-Funktionen. Die Voraussetzung für ihre Verwendung ist die Umwandlung der Texte ins Tabellenformat. Dann können wir z.B. auch neue Tabellenspalten mit den Zeitangaben bilden.


```r
a1 = avatar_eng %>% 
  as_tibble() %>% 
  mutate(row_tc = row_number()) %>% 
  filter(str_detect(value, "-->")) %>% 
  rename(timecode = value)
a2 = avatar_eng %>% 
  as_tibble() %>% 
  mutate(row_id = row_number()) %>% 
  filter(str_detect(value, "[a-zA-Z]")) %>% 
  rename(text = value) %>% 
  mutate(language = "eng")

avatar_eng = bind_cols(a1,a2) %>% 
  select(timecode, text) %>% 
  separate(timecode, into = c("start", "end"), sep = "\\-\\-\\>")
tail(avatar_eng)
```

```
## # A tibble: 6 x 3
##   start           end             text                                          
##   <chr>           <chr>           <chr>                                         
## 1 "02:49:47,566 " " 02:49:51,396" 'Cause whatever happens tonight, either way, ~
## 2 "02:49:52,406 " " 02:49:55,236" I'm not gonna be coming back to this place.   
## 3 "02:49:58,866 " " 02:50:00,996" Well, I guess I'd better go.                  
## 4 "02:50:03,576 " " 02:50:06,626" Yeah, I don't want to be late for my own part~
## 5 "02:50:09,956 " " 02:50:12,416" Yeah, it's my birthday, after all.            
## 6 "02:50:14,926 " " 02:50:17,256" This is Jake Sully signing off.
```

```r
a2a = a2 %>% 
  mutate(sentence_id = row_number())
```

Da die Anfangs- und Endzeit der Untertitel in den drei Sprachen nicht übereinstimmt, wollen wir lediglich die Untertiteltexte beibehalten.


```r
b1 = avatar_deu %>% 
  as_tibble() %>% 
  mutate(row_tc = row_number()) %>% 
  filter(str_detect(value, "-->")) %>% 
  rename(timecode = value)
b2 = avatar_deu %>% 
  as_tibble() %>% 
  mutate(row_id = row_number()) %>% 
  filter(str_detect(value, "[a-zA-Z]")) %>% 
  rename(text = value) %>% 
  mutate(language = "deu")
# avatar_deu = bind_cols(a1,a2)
#   select(timecode, text) %>% 
#   separate(timecode, into = c("start", "end"), sep = "\\-\\-\\>")
# tail(avatar_deu)

b2a = b2 %>% 
  mutate(sentence_id = row_number())
```



```r
c1 = avatar_slv %>% 
  as_tibble() %>% 
  mutate(row_tc = row_number()) %>% 
  filter(str_detect(value, "-->")) %>% 
  rename(timecode = value)
c2 = avatar_slv %>% 
  as_tibble() %>% 
  mutate(row_id = row_number()) %>% 
  filter(str_detect(value, "[a-zA-Z]")) %>% 
  rename(text = value) %>% 
  mutate(text = str_replace(text, "\\<i\\>", "")) %>% 
  mutate(text = str_replace(text, "\\</i\\>", "")) %>% 
  mutate(language = "slv")
# avatar_slv = bind_cols(a1,a2)
#   select(timecode, text) %>% 
#   separate(timecode, into = c("start", "end"), sep = "\\-\\-\\>")
# tail(avatar_slv)

c2a = c2 %>% 
  mutate(sentence_id = row_number())
```


### Datensätze verknüpfen

Nun verknüpfen wir die drei Datensätze zu einem einzigen.


```r
avatar = bind_rows(a2a,b2a,c2a)
```


### Merkmale hinzufügen

Mit Hilfe von *quanteda*-Funktionen fügen wir dem Datensatz noch weitere Kenngrößen hinzu, und zwar die Anzahl der Wortformerscheinungen oder Tokens pro Äußerung (sentlen), die Anzahl der Silben pro Äußerung (syllables), die Wortlänge (wordlen), die Anzahl der verschiedenen Wortformen (Types) und das Type-Token-Verhältnis als bekanntes Maß für lexikalische Diversität.


```r
avatar = avatar %>% 
  mutate(txt = str_replace_all(text, "[:punct:]", "")) %>% 
  mutate(sentlen = quanteda::ntoken(txt)) %>% 
  mutate(syllables = nsyllable::nsyllable(txt)) %>% 
  mutate(types = quanteda::ntype(txt)) %>% 
  mutate(wordlen = syllables/sentlen) %>% 
  mutate(ttr = types/sentlen) %>% 
  select(-txt)
```

Speichern für spätere Verwendung.


```r
write_rds(avatar, "data/avatar.rds")
write_csv(avatar, "data/avatar.csv")
```



```r
avatar = read_rds("data/avatar.rds")
```

### Konkordanzrecherche

Ein Beispiel einer Konkordanzrecherche mit Hilfe von *kwic* - dem Konkordanz-Tool in *quanteda*:


```r
x = quanteda::corpus(avatar, text_field = "text") %>% 
  quanteda::tokens()
quanteda::kwic(x, pattern = "planet") %>% as_tibble()
```

```
## # A tibble: 2 x 7
##   docname   from    to pre                         keyword post  pattern
##   <chr>    <int> <int> <chr>                       <chr>   <chr> <fct>  
## 1 text18      11    11 , you're on the wrong       planet  .     planet 
## 2 text5157     8     8 se vrnili na svoj umirajoèi planet  .     planet
```

### Textzerlegung

Zerlegung der Untertitellinien in Wörter: 


```r
library(tidytext)

avatar_words = avatar %>% 
  unnest_tokens(word, text, drop = FALSE) %>% 
  select(-text)
head(avatar_words)  
```

```
## # A tibble: 6 x 9
##   row_id language sentence_id sentlen syllables types wordlen   ttr word 
##    <int> <chr>          <int>   <int>     <int> <int>   <dbl> <dbl> <chr>
## 1      3 eng                1       9        12     9    1.33     1 when 
## 2      3 eng                1       9        12     9    1.33     1 i    
## 3      3 eng                1       9        12     9    1.33     1 was  
## 4      3 eng                1       9        12     9    1.33     1 lying
## 5      3 eng                1       9        12     9    1.33     1 there
## 6      3 eng                1       9        12     9    1.33     1 in
```

### Zerlegung und Annotation

Zuerst müssen wir für jede Sprache ein **udpipe**-Sprachmodell laden, um für jede der drei Untertitelversionen eine morphosyntaktische Annotation vorzunehmen.


```r
library(udpipe)

file_model = "english-ewt-ud-2.5-191206.udpipe"
engmod <- udpipe_load_model(file_model)

x = udpipe_annotate(engmod, x = avatar$text[avatar$language == "eng"], trace = FALSE)
udeng = as.data.frame(x)
```



```r
# file_model = udpipe_download_model("german-hdt")
# file_model = "german-gsd-ud-2.5-191206.udpipe"
file_model = "german-hdt-ud-2.5-191206.udpipe"
deumod <- udpipe_load_model(file_model)

x = udpipe_annotate(deumod, x = avatar$text[avatar$language == "deu"], trace = F)
uddeu = as.data.frame(x)
```



```r
file_model = "slovenian-ssj-ud-2.5-191206.udpipe"
slvmod <- udpipe_load_model(file_model)

x = udpipe_annotate(slvmod, x = avatar$text[avatar$language == "slv"], trace = F)
udslv = as.data.frame(x)
```

Die Datensätze wollen wir für anderweitige Verwendungen speichern, und zwar sowohl im *conllu*-Format als auch im *csv*-Format. In beiden Fällen erhalten wir Textdateien.


```r
write.table(as_conllu(udeng), file = "data/Avatar_ud_eng.conllu", 
            sep = "\t", quote = F, row.names = F)
write.table(as_conllu(uddeu), file = "data/Avatar_ud_deu.conllu", 
            sep = "\t", quote = F, row.names = F)
write.table(as_conllu(udslv), file = "data/Avatar_ud_slv.conllu", 
            sep = "\t", quote = F, row.names = F)
```



































