# Spracherwerbsdaten

## Programme


```r
library(tidyverse)
library(scales)
library(janitor)
library(readxl)
```


## Daten lesen

Verwendet werden die Transkriptionsdateien der normalhörenden deutschsprachigen Kinder im Korpus von *Szagun*.    

Zuerst wird das Arbeitsverzeichnis festgelegt.
Dann werden alle (relevanten) Excel-Dateien gelesen und in der Variable "data" (einer Liste) gespeichert, die die Erwerbsdaten von 6 Kindern und deren Müttern enthält. Die Dateien konzentrieren sich auf sechs d-Wörter, die als Demonstrativpronomen und bestimmter Artikel dienen können.

Code (Version 1):   
Wir erhalten 12 Datensätze (6 Kinder und 6 erwachsene Bezugspersonen, meistens die Mutter).


```r
library(fs)

wd <- getwd()
wdd <- paste0(wd,"/data/szagun/")

file_paths <- fs::dir_ls(wdd)
file_paths
```

```
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Anna.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Anna_M.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Emely.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Emely_M.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Falko.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Falko_M.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Lisa.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Lisa_M.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Rahel.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Rahel_M.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Soeren.xlsx
## D:/Users/teodo/Documents/R/raj2022-book/data/szagun/Soeren_M.xlsx
```

```r
data <- file_paths %>%
    map(function (path) {
        readxl::read_xlsx(path, skip = 3)
    })
# data
```

Code (Version 2):   
Wir erhalten 12 Datensätze (6 Kinder und 6 erwachsene Bezugspersonen, meistens die Mutter).


```r
# rahel <- read_excel("data/Rahel_Mot.xlsx")

wd <- getwd()
wdd <- paste0(wd,"/data/szagun/")
setwd(wdd)

data.files = list.files(path = wdd, pattern = "\\.xlsx", 
                        full.names = TRUE,
                        recursive = FALSE) # TRUE if subdirectories included
data <- lapply(data.files, readxl::read_excel, skip = 3)
# data

# dataframes: which columns are in common?
# common_cols <- intersect(colnames(f), colnames(g))
```

## Verknüpfung der einzelnen Dateien 

Mit Clan wurden 12 Excel-Dateien zusammengestellt. Die Excel-Dateien werden nun zu einer einzelnen zusammengefasst. Zu diesem Zweck werden mit Hilfe einer Programm-Schleife mehrere Veränderungen vorgenommen:   
- die data-Liste wird in einen Datensatz umgewandelt (as.data.frame, as_tibble),   
- nicht relevante Variablen eliminiert (select),   
- Variablen umbenannt (rename),   
- neue Variablen aus bereits bestehenden geschaffen (separate),   
- fehlende Spalten (z.B. für "das") hinzugefügt (if ... add_column),   
- Variablen konvertiert (as.numeric).


```r
szagun <- NULL
szagun <- data.frame()

for(i in 1:length(data)){
  f <- data[i] %>% 
    as.data.frame() %>% as_tibble() %>% clean_names() %>%
    dplyr::select(-c(language, corpus, sex, group, race, ses, role, 
              education, custom_field)) %>%
    rename(utterances = starts_with("x_")) %>% 
    # mutate(des = ifelse("des" %in% names(.), des, NA)) %>% # add missing column "des" (but this doesn't work)
    separate(file, into = c("id", "location"), sep = ",") %>%
    dplyr::select(-location) %>%
    rename(ageof = age) %>%
    separate(id, into = c("id", "age"), sep = "_")
  
  if(!'des' %in% names(f)) {
    # if column "des" is missing, add it to dataframe, fill 0
    f <- f %>% add_column(des = 0)}
  # append file to previous file
  szagun <- rbind(szagun, f)
}

szagun <- szagun %>% 
  mutate(ttr = as.numeric(ttr))

szagun <- szagun %>% 
  rename(age1 = age, age = ageof) %>% 
  mutate(age = age1) %>% 
  mutate(age = paste0(str_sub(age, 1, 1), ";",  
         str_sub(age, 2, 3), ".", str_sub(age, 4, 5)))
```

Die gemeinsamen Spalten in Datensätzen (hier: *f*) kann man übrigens mit der Funktion `intersect()` herausfinden.


```r
common_cols <- intersect(colnames(f), colnames(f))
```


Hier ist nun die gesamte Tabelle (mit 6 Kindern und 6 Erwachsenen) für den von Szagun ausgewählten Beobachtungszeitraum.


```r
library(DT)
szagun %>% 
  DT::datatable(filter = "top", fillContainer = T,
              extensions = c('Buttons', "ColReorder", "RowReorder",
                             'FixedColumns', "KeyTable", "Scroller"),
              options = list(pageLength = 10, 
                             autowidth = TRUE,
                             colReorder = TRUE, 
                             rowReorder = TRUE, order = list(c(0, 'asc')),
                             keys = TRUE,
                             deferRender = TRUE,
                             scrollY = 600, scroller = TRUE,
                             scrollX = TRUE,
                             fixedColumns = 
                               list(leftColumns = 2, rightColumns = 1),
                             dom = 'Bfrtip', # Bfrtip or t
    buttons = c('colvis','copy', 'csv', 'excel', 'pdf', 'print')
  )) %>%
  formatStyle("id",
  target = 'row',
  backgroundColor = styleEqual(c(0, 1), c('gray30', 'lightblue')))
```

```{=html}
<div id="htmlwidget-54abb0977d49441f5c6b" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-54abb0977d49441f5c6b">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"1567\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"294\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"17\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"69\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"158\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"43\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"195\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"6\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0\" data-max=\"651\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"0.006\" data-max=\"1\" data-scale=\"3\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","extensions":["Buttons","ColReorder","RowReorder","FixedColumns","KeyTable","Scroller"],"fillContainer":true,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250"],["Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Anna","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Emely","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Falko","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Lisa","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Rahel","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren","Soeren"],["10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10407","10507","10614","10813","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10407","10507","10614","10813","10907","11014","20000","20107","20214","20400","20507","20614","20800","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10800","10907","20000","20107","20214","20400","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","11014","20000","20107","20214","20400","20507","20800","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20000","20107","20214","20400","20507","20614","20800","20907","21014","30000","30107","30214","30400","30507","30614","30800","10400","10507","10614","10800","10907","11014","20400","20507","20800","20907","21014","30107","30214","30400","30507","30614","30800"],["CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","CHI","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT","MOT"],["1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.07","1;05.07","1;06.14","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.07","1;05.07","1;06.14","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;08.00","1;09.07","2;00.00","2;01.07","2;02.14","2;04.00","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;08.00","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00","1;04.00","1;05.07","1;06.14","1;08.00","1;09.07","1;10.14","2;04.00","2;05.07","2;08.00","2;09.07","2;10.14","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00"],[230,633,845,1247,1076,1338,957,871,929,1257,1039,1039,979,823,859,602,1148,883,960,953,989,867,470,168,478,887,472,581,342,721,479,583,740,274,354,297,392,110,133,87,138,74,53,73,374,235,191,321,720,875,695,1360,1567,859,678,353,797,1103,1004,542,590,566,956,536,494,499,794,278,7,554,323,315,265,1043,133,271,543,158,458,482,68,2,2,6,4,14,6,67,46,140,311,238,378,817,734,711,908,914,806,544,1009,821,690,1057,730,357,571,531,505,662,58,489,92,471,1012,310,819,257,96,42,14,67,4,1,20,5,2,381,694,555,410,580,706,750,667,537,693,735,653,369,417,766,602,578,669,647,1331,1293,1150,915,342,385,743,331,414,323,686,229,225,738,232,76,235,318,270,214,229,224,193,316,270,428,630,632,909,424,513,899,556,1010,1115,617,572,525,498,741,684,1035,787,605,881,844,655,543,440,348,854,272,363,688,427,262,675,265,151,227,197,107,174,94,64,487,663,765,753,561,997,679,580,780,1030,1446,1265,1365,1073,1335,948,778,1119,851,956,889,516,895,660,543,1174,480,586,530,1058,424,586,682,237,288,176,277,243,117],[1,7,68,66,127,86,93,102,55,81,152,155,125,92,106,82,115,130,161,167,151,127,88,31,71,99,90,106,48,119,85,123,117,44,71,39,67,14,29,15,19,20,9,11,0,1,0,1,0,1,0,0,1,78,85,46,57,107,141,81,101,105,142,96,79,56,94,30,2,61,50,39,65,137,23,61,97,15,71,83,2,0,0,0,1,0,0,0,0,0,0,1,27,37,195,118,141,116,149,30,115,72,83,188,105,34,92,92,90,144,7,125,20,101,229,51,147,99,9,4,1,8,2,1,0,2,1,0,1,0,0,2,4,40,124,92,94,46,101,54,73,108,94,86,84,81,138,156,117,170,67,64,165,67,67,50,144,45,21,108,35,11,30,40,35,20,43,30,5,11,7,0,1,1,8,4,6,26,18,124,100,135,118,93,94,159,149,233,223,140,191,191,90,125,74,51,162,45,64,143,51,31,144,38,19,24,32,17,19,8,4,1,19,23,42,16,32,60,40,128,208,294,150,277,203,232,124,88,169,131,124,141,50,179,118,70,160,49,50,61,133,30,55,39,31,35,17,52,44,13],[0,0,0,0,0,0,1,0,3,1,2,0,5,5,0,0,5,3,3,5,3,0,6,2,8,10,5,6,12,9,13,9,12,2,10,2,6,3,8,2,4,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,5,4,1,3,2,4,1,0,0,2,1,3,1,0,2,2,0,1,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,2,3,3,0,4,2,2,2,2,0,2,1,11,0,6,5,6,8,2,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,2,0,0,0,2,1,0,2,2,2,0,17,4,5,5,3,6,3,6,1,1,4,6,1,1,3,4,1,5,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,4,0,0,0,0,1,1,3,0,7,6,5,12,5,1,7,6,3,4,4,1,6,2,0,0,0,0,1,0,0,1,2,2,0,0,0,0,0,0,0,0,2,0,0,1,0,0,0,1,4,1,2,2,0,0,2,1,1,0,0,5,3,2],[0,1,0,5,5,28,4,1,14,44,17,41,8,17,24,16,28,26,24,30,36,28,7,3,28,19,10,31,5,24,10,23,16,8,12,16,13,5,2,5,2,5,3,5,0,0,0,0,0,0,0,0,0,1,0,0,0,4,7,3,13,14,53,16,13,13,15,1,0,15,4,5,3,14,9,6,16,3,7,6,1,0,0,0,0,0,1,0,0,0,0,2,0,7,5,4,15,34,17,21,32,23,43,58,18,26,30,23,24,43,2,10,2,14,40,9,37,5,6,3,0,3,0,0,1,0,0,0,0,1,3,3,4,2,7,1,20,35,8,25,4,10,12,7,5,15,12,20,12,22,15,15,11,6,7,7,20,8,8,18,5,8,4,9,4,4,5,4,3,1,2,0,0,0,0,0,1,1,1,0,2,16,5,3,3,5,12,16,28,24,14,15,30,24,15,4,32,2,6,26,10,6,39,6,5,7,9,10,7,7,2,0,0,39,35,20,69,14,7,12,38,34,14,21,28,19,5,12,25,9,9,12,10,20,12,18,30,18,16,4,18,2,7,8,13,7,2,8,9,6],[0,0,1,1,7,8,32,19,57,80,56,84,37,45,65,59,56,70,75,63,66,60,48,17,36,62,28,49,21,43,30,38,35,25,17,17,33,8,9,15,12,7,4,3,0,0,0,0,3,1,1,1,1,0,0,0,1,28,28,16,49,23,43,14,20,13,61,17,1,16,13,9,13,51,10,14,30,6,16,28,2,0,0,0,0,0,0,0,0,0,0,0,1,4,6,57,96,105,42,86,116,78,94,110,63,58,99,90,45,54,7,53,10,45,101,38,116,17,21,4,0,1,0,0,1,0,0,0,0,0,3,5,0,3,0,0,4,9,1,3,10,17,13,31,15,16,39,12,17,27,16,20,32,9,9,13,29,7,15,20,3,4,11,24,12,5,8,6,2,2,1,0,1,0,0,1,3,0,1,4,5,1,3,9,33,57,84,57,95,89,72,53,69,46,35,14,56,23,16,39,13,6,56,15,11,16,7,12,9,2,6,0,2,1,3,7,5,13,15,45,105,98,109,158,113,53,58,35,67,61,60,49,44,54,13,19,79,14,15,15,15,2,12,3,8,15,8,11,13,4],[0,5,1,2,4,17,9,9,6,12,8,5,6,3,4,1,8,13,21,7,10,8,11,1,31,43,15,7,4,7,0,2,4,0,0,0,0,0,1,0,1,0,0,2,1,1,0,1,1,5,1,0,0,1,0,3,8,3,1,1,0,0,0,0,0,0,11,5,0,29,3,3,5,6,1,1,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,10,5,9,5,2,1,1,3,0,1,1,1,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,2,0,3,2,0,2,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,2,0,1,0,0,0,3,14,1,3,4,3,2,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,2,0,2,1,11,0,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[11,10,6,13,6,35,87,55,116,113,100,81,61,94,65,36,179,86,94,119,157,86,54,26,66,108,62,85,56,79,86,72,114,30,46,38,42,7,17,22,22,11,4,5,0,0,0,0,36,69,15,19,53,7,8,2,15,19,40,26,59,66,75,50,41,38,56,13,1,35,21,10,24,80,9,23,33,5,24,40,1,0,0,1,0,0,0,0,0,0,2,0,0,5,35,30,97,81,79,94,68,44,137,136,56,20,123,122,100,80,2,50,7,71,133,30,137,55,10,5,2,10,2,0,0,0,0,0,2,23,5,10,3,3,19,15,16,33,72,15,41,37,74,49,41,60,105,60,42,73,39,49,44,39,36,30,62,14,12,57,33,9,18,29,14,21,17,17,10,7,5,4,0,15,2,1,16,40,2,12,14,4,5,6,33,137,92,109,133,87,115,110,44,72,26,19,94,16,30,84,22,22,91,14,23,14,25,12,23,8,7,0,0,5,3,0,2,13,5,75,105,183,154,195,119,147,88,67,96,82,95,65,57,89,38,38,59,21,19,24,51,20,27,12,22,22,14,36,20,7],[2,4,4,5,5,5,6,5,6,6,6,5,6,6,5,5,6,6,6,6,6,5,6,6,6,6,6,6,6,6,5,6,6,5,5,5,5,5,6,5,6,4,5,5,1,2,0,2,3,4,3,2,3,4,2,3,4,5,5,5,5,5,5,5,5,5,6,6,3,5,6,6,6,6,5,6,5,4,6,5,4,0,0,1,1,0,1,0,0,0,1,2,2,6,5,5,5,5,6,6,6,6,4,6,6,6,6,5,5,5,5,5,4,5,5,5,5,5,4,4,2,5,2,1,2,1,2,0,2,2,3,4,3,4,4,4,5,6,5,5,5,4,6,6,5,6,5,6,4,5,5,5,5,5,5,5,5,5,5,6,5,5,5,5,5,5,5,5,5,4,4,1,3,2,3,3,4,3,5,4,5,5,5,5,5,6,4,6,4,5,4,5,5,5,5,4,5,5,5,5,5,5,6,5,5,5,5,5,5,5,4,1,2,4,5,3,4,5,5,5,5,5,4,4,4,4,5,4,6,5,5,5,5,5,4,5,5,5,5,5,4,4,5,5,5,4,4,5,5,5],[12,23,76,87,149,174,226,186,251,331,335,366,242,256,264,194,391,328,378,391,423,309,214,80,240,341,210,284,146,281,224,267,298,109,156,112,161,37,66,59,60,43,23,26,1,2,0,2,40,76,17,20,55,87,93,51,81,161,217,127,223,213,317,177,156,122,241,67,4,156,93,67,113,289,52,107,178,29,121,164,6,0,0,1,1,0,1,0,0,0,2,3,28,55,251,214,358,341,290,234,335,223,357,497,245,141,348,329,260,323,19,249,39,237,508,134,445,178,46,16,3,24,4,1,2,2,2,0,3,24,11,20,11,48,151,109,140,126,184,100,130,172,197,175,146,175,296,251,188,309,141,153,257,124,125,103,261,75,57,208,82,33,64,105,69,51,78,59,23,21,15,4,4,16,11,6,26,67,25,154,122,159,135,114,165,362,337,420,479,341,392,370,234,268,153,88,351,92,121,304,101,66,338,79,61,65,77,52,64,27,19,1,21,68,84,43,108,101,69,262,458,611,427,651,463,451,277,202,361,284,299,268,165,343,181,146,332,103,102,106,217,54,103,63,75,79,41,112,89,32],[0.167,0.174,0.053,0.057,0.034,0.029,0.027,0.027,0.024,0.018,0.018,0.014,0.025,0.023,0.019,0.026,0.015,0.018,0.016,0.015,0.014,0.016,0.028,0.075,0.025,0.018,0.029,0.021,0.041,0.021,0.022,0.022,0.02,0.046,0.032,0.045,0.031,0.135,0.091,0.085,0.1,0.093,0.217,0.192,1,1,null,1,0.075,0.053,0.176,0.1,0.055,0.046,0.022,0.059,0.049,0.031,0.023,0.039,0.022,0.023,0.016,0.028,0.032,0.041,0.025,0.09,0.75,0.032,0.065,0.09,0.053,0.021,0.096,0.056,0.028,0.138,0.05,0.03,0.667,null,null,1,1,null,1,null,null,null,0.5,0.667,0.071,0.109,0.02,0.023,0.014,0.015,0.021,0.026,0.018,0.027,0.011,0.012,0.024,0.043,0.017,0.015,0.019,0.015,0.263,0.02,0.103,0.021,0.01,0.037,0.011,0.028,0.087,0.25,0.667,0.208,0.5,1,1,0.5,1,null,0.667,0.083,0.273,0.2,0.273,0.083,0.026,0.037,0.036,0.048,0.027,0.05,0.038,0.023,0.03,0.034,0.034,0.034,0.017,0.024,0.021,0.016,0.035,0.033,0.019,0.04,0.04,0.049,0.019,0.067,0.088,0.029,0.061,0.152,0.078,0.048,0.072,0.098,0.064,0.085,0.217,0.19,0.267,0.25,0.75,0.125,0.273,0.5,0.154,0.045,0.2,0.026,0.041,0.031,0.037,0.044,0.03,0.017,0.012,0.014,0.008,0.015,0.01,0.014,0.021,0.019,0.033,0.045,0.014,0.054,0.041,0.016,0.05,0.076,0.018,0.063,0.082,0.077,0.065,0.096,0.078,0.185,0.211,1,0.095,0.059,0.06,0.07,0.037,0.05,0.072,0.019,0.011,0.008,0.009,0.006,0.009,0.009,0.018,0.02,0.017,0.018,0.017,0.019,0.03,0.015,0.022,0.034,0.015,0.049,0.049,0.047,0.018,0.074,0.049,0.079,0.067,0.051,0.098,0.045,0.056,0.156]],"container":"<table class=\"display fill-container\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>id<\/th>\n      <th>age1<\/th>\n      <th>code<\/th>\n      <th>age<\/th>\n      <th>utterances<\/th>\n      <th>das<\/th>\n      <th>dem<\/th>\n      <th>den<\/th>\n      <th>der<\/th>\n      <th>des<\/th>\n      <th>die<\/th>\n      <th>types<\/th>\n      <th>token<\/th>\n      <th>ttr<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"autowidth":true,"colReorder":true,"rowReorder":true,"order":[["0","asc"]],"keys":true,"deferRender":true,"scrollY":600,"scroller":true,"scrollX":true,"fixedColumns":{"leftColumns":2,"rightColumns":1},"dom":"Bfrtip","buttons":["colvis","copy","csv","excel","pdf","print"],"columnDefs":[{"className":"dt-right","targets":[5,6,7,8,9,10,11,12,13,14]},{"orderable":false,"targets":0}],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[1]; $(row).css({'background-color':value == 0 ? \"gray30\" : value == 1 ? \"lightblue\" : null});\n}"}},"evals":["options.rowCallback"],"jsHooks":[]}</script>
```

```r
writexl::write_xlsx(szagun, "data/Kapitel 9 Spracherwerbsdaten Computergestütze Textanalyse mit R.xlsx")
```

In der Gesamttabelle haben wir einen Fehler, den wir noch berichtigen müssen. Für die Mütter stehen uns nicht für jeden Monat Zahlen zur Verfügung. Dieser Zuordnungsfehler (MOT-Daten bei CHI zugeordnet) ist in der Graphik mit `plotly` (s.u.) bemerkbar. Außerdem gibt es auch kleinere monatliche Unterschiede bei den Kindern. Die Altersangaben müssen wir demnach vereinfachen (nur Jahr und Monat, eventuell auch bestimmte Monate zusammenfassen).

Das lassen wir im Augenblick noch außer Acht.

## 1. Häufigkeit insgesamt


```r
children <- szagun %>% 
  filter(code == "CHI") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(age, code, d_wort) %>% 
  summarise(avg_freq = mean(freq/utterances)) %>% 
  ggplot(aes(age, avg_freq, group = code, fill = d_wort)) +
  geom_col() +
  geom_smooth(se = F) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  labs(y = "mean frequency") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) 

ggsave(plot = children, 
       filename ="pictures/szagun_gesamtfrequenz_kinder.jpg", 
       dpi = 300)
children
```

<img src="06-Szagun_NH_chisq5_files/figure-html/unnamed-chunk-7-1.svg" width="672" />

```r
library(plotly)
ggplotly(children)
```

```{=html}
<div id="htmlwidget-58050c1aba5334e809aa" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-58050c1aba5334e809aa">{"x":{"data":[{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.00128024283546112,0,0.00783326860601602,0.0186868351232003,0.0235009594755902,0.00311526479750779,0.0272723596140291,0.0310507306032647,0.0521809867969197,0.11167016886544,0.114000339987116,0.122966454316274,0.147213848456195,0.157316429292998,0.130126880498767,0.145962116837274,0.146814219217103,0.151788849766296,0.156040461676702,0.172752684036094,0.153669449454221,0.160941510369295,0.165235775030641,0.128827888055716],"text":["age: 1;04.00<br />avg_freq: 0.0012802428<br />code: CHI<br />d_wort: das","age: 1;04.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: das","age: 1;05.07<br />avg_freq: 0.0078332686<br />code: CHI<br />d_wort: das","age: 1;06.14<br />avg_freq: 0.0186868351<br />code: CHI<br />d_wort: das","age: 1;08.00<br />avg_freq: 0.0235009595<br />code: CHI<br />d_wort: das","age: 1;08.13<br />avg_freq: 0.0031152648<br />code: CHI<br />d_wort: das","age: 1;09.07<br />avg_freq: 0.0272723596<br />code: CHI<br />d_wort: das","age: 1;10.14<br />avg_freq: 0.0310507306<br />code: CHI<br />d_wort: das","age: 2;00.00<br />avg_freq: 0.0521809868<br />code: CHI<br />d_wort: das","age: 2;01.07<br />avg_freq: 0.1116701689<br />code: CHI<br />d_wort: das","age: 2;02.14<br />avg_freq: 0.1140003400<br />code: CHI<br />d_wort: das","age: 2;04.00<br />avg_freq: 0.1229664543<br />code: CHI<br />d_wort: das","age: 2;05.07<br />avg_freq: 0.1472138485<br />code: CHI<br />d_wort: das","age: 2;06.14<br />avg_freq: 0.1573164293<br />code: CHI<br />d_wort: das","age: 2;08.00<br />avg_freq: 0.1301268805<br />code: CHI<br />d_wort: das","age: 2;09.07<br />avg_freq: 0.1459621168<br />code: CHI<br />d_wort: das","age: 2;10.14<br />avg_freq: 0.1468142192<br />code: CHI<br />d_wort: das","age: 3;00.00<br />avg_freq: 0.1517888498<br />code: CHI<br />d_wort: das","age: 3;01.07<br />avg_freq: 0.1560404617<br />code: CHI<br />d_wort: das","age: 3;02.14<br />avg_freq: 0.1727526840<br />code: CHI<br />d_wort: das","age: 3;04.00<br />avg_freq: 0.1536694495<br />code: CHI<br />d_wort: das","age: 3;05.07<br />avg_freq: 0.1609415104<br />code: CHI<br />d_wort: das","age: 3;06.14<br />avg_freq: 0.1652357750<br />code: CHI<br />d_wort: das","age: 3;08.00<br />avg_freq: 0.1288278881<br />code: CHI<br />d_wort: das"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"das","legendgroup":"das","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.00128024283546112,0,0.00783326860601602,0.0186868351232003,0.0235009594755902,0.00311526479750779,0.0272723596140291,0.0310507306032647,0.0521809867969197,0.11167016886544,0.114000339987116,0.122966454316274,0.147213848456195,0.157316429292998,0.130126880498767,0.145962116837274,0.146814219217103,0.151788849766296,0.156040461676702,0.172752684036094,0.153669449454221,0.160941510369295,0.165235775030641,0.128827888055716],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0,0,0,0,0.000265604249667994,0,0,0,0.000623612722927804,0.000574712643678157,0.000965563559750859,0.000132590824714923,0.000547578672148996,0.000717246987562647,0.00146395381441647,0.00150809582931422,0.00128377723095333,0.00055370985603545,0.0025715748719784,0.00279307781349244,0.00266708857049339,0.002019586321751,0.00259072827942727,0.000922455598219352],"text":["age: 1;04.00<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;04.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;05.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;06.14<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;08.00<br />avg_freq: 0.0002656042<br />code: CHI<br />d_wort: dem","age: 1;08.13<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;09.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 1;10.14<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: dem","age: 2;00.00<br />avg_freq: 0.0006236127<br />code: CHI<br />d_wort: dem","age: 2;01.07<br />avg_freq: 0.0005747126<br />code: CHI<br />d_wort: dem","age: 2;02.14<br />avg_freq: 0.0009655636<br />code: CHI<br />d_wort: dem","age: 2;04.00<br />avg_freq: 0.0001325908<br />code: CHI<br />d_wort: dem","age: 2;05.07<br />avg_freq: 0.0005475787<br />code: CHI<br />d_wort: dem","age: 2;06.14<br />avg_freq: 0.0007172470<br />code: CHI<br />d_wort: dem","age: 2;08.00<br />avg_freq: 0.0014639538<br />code: CHI<br />d_wort: dem","age: 2;09.07<br />avg_freq: 0.0015080958<br />code: CHI<br />d_wort: dem","age: 2;10.14<br />avg_freq: 0.0012837772<br />code: CHI<br />d_wort: dem","age: 3;00.00<br />avg_freq: 0.0005537099<br />code: CHI<br />d_wort: dem","age: 3;01.07<br />avg_freq: 0.0025715749<br />code: CHI<br />d_wort: dem","age: 3;02.14<br />avg_freq: 0.0027930778<br />code: CHI<br />d_wort: dem","age: 3;04.00<br />avg_freq: 0.0026670886<br />code: CHI<br />d_wort: dem","age: 3;05.07<br />avg_freq: 0.0020195863<br />code: CHI<br />d_wort: dem","age: 3;06.14<br />avg_freq: 0.0025907283<br />code: CHI<br />d_wort: dem","age: 3;08.00<br />avg_freq: 0.0009224556<br />code: CHI<br />d_wort: dem"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(183,159,0,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"dem","legendgroup":"dem","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.00128024283546112,0,0.00783326860601602,0.0186868351232003,0.0237665637252582,0.00311526479750779,0.0272723596140291,0.0310507306032647,0.0528045995198475,0.112244881509118,0.114965903546867,0.123099045140988,0.147761427128344,0.15803367628056,0.131590834313184,0.147470212666588,0.148097996448056,0.152342559622331,0.15861203654868,0.175545761849587,0.156336538024714,0.162961096691046,0.167826503310069,0.129750343653936],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0,0,0.000263296471827278,0.00879703232644409,0.011561487991612,0,0.00897887319537636,0.016291569889961,0.00619087169903093,0.00538706233642396,0.0063237765880586,0.020039150097301,0.0251041878596153,0.0154354054314097,0.0226040205765614,0.0162847768874623,0.0161601451200935,0.0228639408482898,0.0240483751019091,0.0240384921381042,0.0377829337800206,0.0246984542652596,0.0254615705870815,0.030248047003459],"text":["age: 1;04.00<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: den","age: 1;04.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: den","age: 1;05.07<br />avg_freq: 0.0002632965<br />code: CHI<br />d_wort: den","age: 1;06.14<br />avg_freq: 0.0087970323<br />code: CHI<br />d_wort: den","age: 1;08.00<br />avg_freq: 0.0115614880<br />code: CHI<br />d_wort: den","age: 1;08.13<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: den","age: 1;09.07<br />avg_freq: 0.0089788732<br />code: CHI<br />d_wort: den","age: 1;10.14<br />avg_freq: 0.0162915699<br />code: CHI<br />d_wort: den","age: 2;00.00<br />avg_freq: 0.0061908717<br />code: CHI<br />d_wort: den","age: 2;01.07<br />avg_freq: 0.0053870623<br />code: CHI<br />d_wort: den","age: 2;02.14<br />avg_freq: 0.0063237766<br />code: CHI<br />d_wort: den","age: 2;04.00<br />avg_freq: 0.0200391501<br />code: CHI<br />d_wort: den","age: 2;05.07<br />avg_freq: 0.0251041879<br />code: CHI<br />d_wort: den","age: 2;06.14<br />avg_freq: 0.0154354054<br />code: CHI<br />d_wort: den","age: 2;08.00<br />avg_freq: 0.0226040206<br />code: CHI<br />d_wort: den","age: 2;09.07<br />avg_freq: 0.0162847769<br />code: CHI<br />d_wort: den","age: 2;10.14<br />avg_freq: 0.0161601451<br />code: CHI<br />d_wort: den","age: 3;00.00<br />avg_freq: 0.0228639408<br />code: CHI<br />d_wort: den","age: 3;01.07<br />avg_freq: 0.0240483751<br />code: CHI<br />d_wort: den","age: 3;02.14<br />avg_freq: 0.0240384921<br />code: CHI<br />d_wort: den","age: 3;04.00<br />avg_freq: 0.0377829338<br />code: CHI<br />d_wort: den","age: 3;05.07<br />avg_freq: 0.0246984543<br />code: CHI<br />d_wort: den","age: 3;06.14<br />avg_freq: 0.0254615706<br />code: CHI<br />d_wort: den","age: 3;08.00<br />avg_freq: 0.0302480470<br />code: CHI<br />d_wort: den"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(0,186,56,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"den","legendgroup":"den","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.00128024283546112,0,0.0080965650778433,0.0274838674496444,0.0353280517168701,0.00311526479750779,0.0362512328094055,0.0473423004932257,0.0589954712188784,0.117631943845542,0.121289680134926,0.143138195238289,0.172865614987959,0.17346908171197,0.154194854889745,0.16375498955405,0.16425814156815,0.175206500470621,0.182660411650589,0.199584253987691,0.194119471804735,0.187659550956305,0.19328807389715,0.159998390657395],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0,0,0.000767315473197826,0.000415103582524397,0.00242061230696748,0,0.00568819024268776,0.00343840523063126,0.0104864064909015,0.00973071967397635,0.0339693232150067,0.0469280877312365,0.0417360732627913,0.0376497176830285,0.0563600769400241,0.0650977861021962,0.0562300970492963,0.0782236600512655,0.064932046811069,0.0682034310512849,0.0881810667337617,0.0732324273496944,0.0673177485721199,0.0649604342206887],"text":["age: 1;04.00<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: der","age: 1;04.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: der","age: 1;05.07<br />avg_freq: 0.0007673155<br />code: CHI<br />d_wort: der","age: 1;06.14<br />avg_freq: 0.0004151036<br />code: CHI<br />d_wort: der","age: 1;08.00<br />avg_freq: 0.0024206123<br />code: CHI<br />d_wort: der","age: 1;08.13<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: der","age: 1;09.07<br />avg_freq: 0.0056881902<br />code: CHI<br />d_wort: der","age: 1;10.14<br />avg_freq: 0.0034384052<br />code: CHI<br />d_wort: der","age: 2;00.00<br />avg_freq: 0.0104864065<br />code: CHI<br />d_wort: der","age: 2;01.07<br />avg_freq: 0.0097307197<br />code: CHI<br />d_wort: der","age: 2;02.14<br />avg_freq: 0.0339693232<br />code: CHI<br />d_wort: der","age: 2;04.00<br />avg_freq: 0.0469280877<br />code: CHI<br />d_wort: der","age: 2;05.07<br />avg_freq: 0.0417360733<br />code: CHI<br />d_wort: der","age: 2;06.14<br />avg_freq: 0.0376497177<br />code: CHI<br />d_wort: der","age: 2;08.00<br />avg_freq: 0.0563600769<br />code: CHI<br />d_wort: der","age: 2;09.07<br />avg_freq: 0.0650977861<br />code: CHI<br />d_wort: der","age: 2;10.14<br />avg_freq: 0.0562300970<br />code: CHI<br />d_wort: der","age: 3;00.00<br />avg_freq: 0.0782236601<br />code: CHI<br />d_wort: der","age: 3;01.07<br />avg_freq: 0.0649320468<br />code: CHI<br />d_wort: der","age: 3;02.14<br />avg_freq: 0.0682034311<br />code: CHI<br />d_wort: der","age: 3;04.00<br />avg_freq: 0.0881810667<br />code: CHI<br />d_wort: der","age: 3;05.07<br />avg_freq: 0.0732324273<br />code: CHI<br />d_wort: der","age: 3;06.14<br />avg_freq: 0.0673177486<br />code: CHI<br />d_wort: der","age: 3;08.00<br />avg_freq: 0.0649604342<br />code: CHI<br />d_wort: der"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"der","legendgroup":"der","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.00128024283546112,0,0.00886388055104113,0.0278989710321688,0.0377486640238376,0.00311526479750779,0.0419394230520933,0.0507807057238569,0.0694818777097799,0.127362663519518,0.155259003349933,0.190066282969526,0.214601688250751,0.211118799394998,0.210554931829769,0.228852775656246,0.220488238617446,0.253430160521886,0.247592458461658,0.267787685038976,0.282300538538497,0.260891978306,0.26060582246927,0.224958824878083],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0,0.00267379679144385,0.00255480274639294,0.000197238658777122,0.000540791849834542,0.00311526479750779,0.000851060167974663,0.00306996939283935,0.00201120464061254,0.00514197711019049,0.00486908165414057,0.00535319920397898,0.00368943695135071,0.00379754994643219,0.0053081577035769,0.00269472717186192,0.00177603356782338,0.00148968529930893,0.00176850038164103,0.00322907970487574,0.00484161603264471,0.00372568812070218,0.00201157546436848,0.0031598927173638],"text":["age: 1;04.00<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: des","age: 1;04.07<br />avg_freq: 0.0026737968<br />code: CHI<br />d_wort: des","age: 1;05.07<br />avg_freq: 0.0025548027<br />code: CHI<br />d_wort: des","age: 1;06.14<br />avg_freq: 0.0001972387<br />code: CHI<br />d_wort: des","age: 1;08.00<br />avg_freq: 0.0005407918<br />code: CHI<br />d_wort: des","age: 1;08.13<br />avg_freq: 0.0031152648<br />code: CHI<br />d_wort: des","age: 1;09.07<br />avg_freq: 0.0008510602<br />code: CHI<br />d_wort: des","age: 1;10.14<br />avg_freq: 0.0030699694<br />code: CHI<br />d_wort: des","age: 2;00.00<br />avg_freq: 0.0020112046<br />code: CHI<br />d_wort: des","age: 2;01.07<br />avg_freq: 0.0051419771<br />code: CHI<br />d_wort: des","age: 2;02.14<br />avg_freq: 0.0048690817<br />code: CHI<br />d_wort: des","age: 2;04.00<br />avg_freq: 0.0053531992<br />code: CHI<br />d_wort: des","age: 2;05.07<br />avg_freq: 0.0036894370<br />code: CHI<br />d_wort: des","age: 2;06.14<br />avg_freq: 0.0037975499<br />code: CHI<br />d_wort: des","age: 2;08.00<br />avg_freq: 0.0053081577<br />code: CHI<br />d_wort: des","age: 2;09.07<br />avg_freq: 0.0026947272<br />code: CHI<br />d_wort: des","age: 2;10.14<br />avg_freq: 0.0017760336<br />code: CHI<br />d_wort: des","age: 3;00.00<br />avg_freq: 0.0014896853<br />code: CHI<br />d_wort: des","age: 3;01.07<br />avg_freq: 0.0017685004<br />code: CHI<br />d_wort: des","age: 3;02.14<br />avg_freq: 0.0032290797<br />code: CHI<br />d_wort: des","age: 3;04.00<br />avg_freq: 0.0048416160<br />code: CHI<br />d_wort: des","age: 3;05.07<br />avg_freq: 0.0037256881<br />code: CHI<br />d_wort: des","age: 3;06.14<br />avg_freq: 0.0020115755<br />code: CHI<br />d_wort: des","age: 3;08.00<br />avg_freq: 0.0031598927<br />code: CHI<br />d_wort: des"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(97,156,255,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"des","legendgroup":"des","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.00128024283546112,0.00267379679144385,0.0114186832974341,0.0280962096909459,0.0382894558736722,0.00623052959501558,0.0427904832200679,0.0538506751166963,0.0714930823503924,0.132504640629708,0.160128085004073,0.195419482173505,0.218291125202101,0.214916349341431,0.215863089533346,0.231547502828108,0.22226427218527,0.254919845821195,0.249360958843299,0.271016764743852,0.287142154571141,0.264617666426702,0.262617397933639,0.228118717595447],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.011434376269809,0,0.00311327211500668,0.0131353596808377,0.00704705878671194,0,0.0125293463424702,0.0237433303262712,0.0310419100841003,0.0275839817390421,0.0561416876080859,0.0570766013231864,0.0624340338240235,0.0703968188859299,0.0748098822733366,0.0790543165580227,0.085400620210884,0.109429230838365,0.110132788165598,0.101131319938102,0.0942142569009602,0.123726316620674,0.120224777497475,0.0979211921236275],"text":["age: 1;04.00<br />avg_freq: 0.0114343763<br />code: CHI<br />d_wort: die","age: 1;04.07<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: die","age: 1;05.07<br />avg_freq: 0.0031132721<br />code: CHI<br />d_wort: die","age: 1;06.14<br />avg_freq: 0.0131353597<br />code: CHI<br />d_wort: die","age: 1;08.00<br />avg_freq: 0.0070470588<br />code: CHI<br />d_wort: die","age: 1;08.13<br />avg_freq: 0.0000000000<br />code: CHI<br />d_wort: die","age: 1;09.07<br />avg_freq: 0.0125293463<br />code: CHI<br />d_wort: die","age: 1;10.14<br />avg_freq: 0.0237433303<br />code: CHI<br />d_wort: die","age: 2;00.00<br />avg_freq: 0.0310419101<br />code: CHI<br />d_wort: die","age: 2;01.07<br />avg_freq: 0.0275839817<br />code: CHI<br />d_wort: die","age: 2;02.14<br />avg_freq: 0.0561416876<br />code: CHI<br />d_wort: die","age: 2;04.00<br />avg_freq: 0.0570766013<br />code: CHI<br />d_wort: die","age: 2;05.07<br />avg_freq: 0.0624340338<br />code: CHI<br />d_wort: die","age: 2;06.14<br />avg_freq: 0.0703968189<br />code: CHI<br />d_wort: die","age: 2;08.00<br />avg_freq: 0.0748098823<br />code: CHI<br />d_wort: die","age: 2;09.07<br />avg_freq: 0.0790543166<br />code: CHI<br />d_wort: die","age: 2;10.14<br />avg_freq: 0.0854006202<br />code: CHI<br />d_wort: die","age: 3;00.00<br />avg_freq: 0.1094292308<br />code: CHI<br />d_wort: die","age: 3;01.07<br />avg_freq: 0.1101327882<br />code: CHI<br />d_wort: die","age: 3;02.14<br />avg_freq: 0.1011313199<br />code: CHI<br />d_wort: die","age: 3;04.00<br />avg_freq: 0.0942142569<br />code: CHI<br />d_wort: die","age: 3;05.07<br />avg_freq: 0.1237263166<br />code: CHI<br />d_wort: die","age: 3;06.14<br />avg_freq: 0.1202247775<br />code: CHI<br />d_wort: die","age: 3;08.00<br />avg_freq: 0.0979211921<br />code: CHI<br />d_wort: die"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(245,100,227,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"die","legendgroup":"die","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.00175781175011659,0.00155269911163658,0.00206905080989599,0.00340300475185009,0.00547227479839369,0.00814509504859176,0.0116320589420543,0.0159313098137864,0.0205924066059459,0.0263057327201243,0.0328838634109768,0.0385596454002561,0.0430131614766968,0.0470518729151433,0.0505996941665126,0.0536577795450367,0.0562490179487495,0.0583299257042717,0.059910846792667,0.060994630724193,0.0615265521192611,0.0614862307936349,0.0608925604401284,0.0597497264947297],"text":["age:  1<br />avg_freq: 0.001757812<br />code: CHI<br />d_wort: grey60","age:  2<br />avg_freq: 0.001552699<br />code: CHI<br />d_wort: grey60","age:  3<br />avg_freq: 0.002069051<br />code: CHI<br />d_wort: grey60","age:  4<br />avg_freq: 0.003403005<br />code: CHI<br />d_wort: grey60","age:  5<br />avg_freq: 0.005472275<br />code: CHI<br />d_wort: grey60","age:  6<br />avg_freq: 0.008145095<br />code: CHI<br />d_wort: grey60","age:  7<br />avg_freq: 0.011632059<br />code: CHI<br />d_wort: grey60","age:  8<br />avg_freq: 0.015931310<br />code: CHI<br />d_wort: grey60","age:  9<br />avg_freq: 0.020592407<br />code: CHI<br />d_wort: grey60","age: 10<br />avg_freq: 0.026305733<br />code: CHI<br />d_wort: grey60","age: 11<br />avg_freq: 0.032883863<br />code: CHI<br />d_wort: grey60","age: 12<br />avg_freq: 0.038559645<br />code: CHI<br />d_wort: grey60","age: 13<br />avg_freq: 0.043013161<br />code: CHI<br />d_wort: grey60","age: 14<br />avg_freq: 0.047051873<br />code: CHI<br />d_wort: grey60","age: 15<br />avg_freq: 0.050599694<br />code: CHI<br />d_wort: grey60","age: 16<br />avg_freq: 0.053657780<br />code: CHI<br />d_wort: grey60","age: 17<br />avg_freq: 0.056249018<br />code: CHI<br />d_wort: grey60","age: 18<br />avg_freq: 0.058329926<br />code: CHI<br />d_wort: grey60","age: 19<br />avg_freq: 0.059910847<br />code: CHI<br />d_wort: grey60","age: 20<br />avg_freq: 0.060994631<br />code: CHI<br />d_wort: grey60","age: 21<br />avg_freq: 0.061526552<br />code: CHI<br />d_wort: grey60","age: 22<br />avg_freq: 0.061486231<br />code: CHI<br />d_wort: grey60","age: 23<br />avg_freq: 0.060892560<br />code: CHI<br />d_wort: grey60","age: 24<br />avg_freq: 0.059749726<br />code: CHI<br />d_wort: grey60"],"type":"scatter","mode":"lines","name":"fitted values","line":{"width":3.77952755905512,"color":"rgba(51,102,255,1)","dash":"solid"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":43.1050228310502},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,24.6],"tickmode":"array","ticktext":["1;04.00","1;04.07","1;05.07","1;06.14","1;08.00","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00"],"tickvals":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"categoryorder":"array","categoryarray":["1;04.00","1;04.07","1;05.07","1;06.14","1;08.00","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-60,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"age","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.0194171991523688,0.407761182199745],"tickmode":"array","ticktext":["0%","10%","20%","30%","40%"],"tickvals":[0,0.1,0.2,0.3,0.4],"categoryorder":"array","categoryarray":["0%","10%","20%","30%","40%"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"mean frequency","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"title":{"text":"d_wort","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"50c1df34855":{"x":{},"y":{},"fill":{},"type":"bar"},"50c2018dd9":{"x":{},"y":{},"fill":{}}},"cur_data":"50c1df34855","visdat":{"50c1df34855":["function (y) ","x"],"50c2018dd9":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```


```r
mothers <- szagun %>% 
  filter(code != "CHI") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(age, code, d_wort) %>% 
  summarise(avg_freq = mean(freq/utterances)) %>% 
  ggplot(aes(age, avg_freq, group = code, fill = d_wort)) +
  geom_col() +
  geom_smooth(se = F) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  labs(y = "mean frequency") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

ggsave(plot = mothers, 
       filename ="pictures/szagun_gesamtfrequenz_muetter.jpg", 
       dpi = 300)
mothers
```

<img src="06-Szagun_NH_chisq5_files/figure-html/unnamed-chunk-8-1.svg" width="672" />

```r
library(plotly)
ggplotly(mothers)
```

```{=html}
<div id="htmlwidget-d2350223e22af9fc68ce" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-d2350223e22af9fc68ce">{"x":{"data":[{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.204150325831823,0.118387909319899,0.159333877246534,0.175189756954022,0.183058065491929,0.110108303249097,0.173473656764353,0.143770948623286,0.186235712983865,0.188089274385782,0.166169195265522,0.157050902599404,0.164425798056163,0.197899181803554,0.13470409855234,0.112016864077354,0.119503404631028,0.106308984250481,0.1746719361196,0.274025174144795,0.0878465241021113,0.207183006681562,0.161799631527243,0.0700443937087773],"text":["age: 1;04.00<br />avg_freq: 0.204150326<br />code: MOT<br />d_wort: das","age: 1;04.07<br />avg_freq: 0.118387909<br />code: MOT<br />d_wort: das","age: 1;05.07<br />avg_freq: 0.159333877<br />code: MOT<br />d_wort: das","age: 1;06.14<br />avg_freq: 0.175189757<br />code: MOT<br />d_wort: das","age: 1;08.00<br />avg_freq: 0.183058065<br />code: MOT<br />d_wort: das","age: 1;08.13<br />avg_freq: 0.110108303<br />code: MOT<br />d_wort: das","age: 1;09.07<br />avg_freq: 0.173473657<br />code: MOT<br />d_wort: das","age: 1;10.14<br />avg_freq: 0.143770949<br />code: MOT<br />d_wort: das","age: 2;00.00<br />avg_freq: 0.186235713<br />code: MOT<br />d_wort: das","age: 2;01.07<br />avg_freq: 0.188089274<br />code: MOT<br />d_wort: das","age: 2;02.14<br />avg_freq: 0.166169195<br />code: MOT<br />d_wort: das","age: 2;04.00<br />avg_freq: 0.157050903<br />code: MOT<br />d_wort: das","age: 2;05.07<br />avg_freq: 0.164425798<br />code: MOT<br />d_wort: das","age: 2;06.14<br />avg_freq: 0.197899182<br />code: MOT<br />d_wort: das","age: 2;08.00<br />avg_freq: 0.134704099<br />code: MOT<br />d_wort: das","age: 2;09.07<br />avg_freq: 0.112016864<br />code: MOT<br />d_wort: das","age: 2;10.14<br />avg_freq: 0.119503405<br />code: MOT<br />d_wort: das","age: 3;00.00<br />avg_freq: 0.106308984<br />code: MOT<br />d_wort: das","age: 3;01.07<br />avg_freq: 0.174671936<br />code: MOT<br />d_wort: das","age: 3;02.14<br />avg_freq: 0.274025174<br />code: MOT<br />d_wort: das","age: 3;04.00<br />avg_freq: 0.087846524<br />code: MOT<br />d_wort: das","age: 3;05.07<br />avg_freq: 0.207183007<br />code: MOT<br />d_wort: das","age: 3;06.14<br />avg_freq: 0.161799632<br />code: MOT<br />d_wort: das","age: 3;08.00<br />avg_freq: 0.070044394<br />code: MOT<br />d_wort: das"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"das","legendgroup":"das","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.204150325831823,0.118387909319899,0.159333877246534,0.175189756954022,0.183058065491929,0.110108303249097,0.173473656764353,0.143770948623286,0.186235712983865,0.188089274385782,0.166169195265522,0.157050902599404,0.164425798056163,0.197899181803554,0.13470409855234,0.112016864077354,0.119503404631028,0.106308984250481,0.1746719361196,0.274025174144795,0.0878465241021113,0.207183006681562,0.161799631527243,0.0700443937087773],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.00724159221637818,0.00503778337531487,0.0085428919613659,0.00631300705736082,0.0104204392244993,0,0.0055863896490948,0.010693234397139,0.0164418715796403,0.00891407267033026,0.0125142255098655,0.00743671660131096,0.00713797640788613,0.0102358600514563,0.0110385663091605,0.00360057379155485,0.00814583638994361,0.0183611676050146,0.0144439712988768,0.0108545225684027,0.00787664551124527,0.0113462235979521,0.0983710080569887,0.00341880341880342],"text":["age: 1;04.00<br />avg_freq: 0.007241592<br />code: MOT<br />d_wort: dem","age: 1;04.07<br />avg_freq: 0.005037783<br />code: MOT<br />d_wort: dem","age: 1;05.07<br />avg_freq: 0.008542892<br />code: MOT<br />d_wort: dem","age: 1;06.14<br />avg_freq: 0.006313007<br />code: MOT<br />d_wort: dem","age: 1;08.00<br />avg_freq: 0.010420439<br />code: MOT<br />d_wort: dem","age: 1;08.13<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: dem","age: 1;09.07<br />avg_freq: 0.005586390<br />code: MOT<br />d_wort: dem","age: 1;10.14<br />avg_freq: 0.010693234<br />code: MOT<br />d_wort: dem","age: 2;00.00<br />avg_freq: 0.016441872<br />code: MOT<br />d_wort: dem","age: 2;01.07<br />avg_freq: 0.008914073<br />code: MOT<br />d_wort: dem","age: 2;02.14<br />avg_freq: 0.012514226<br />code: MOT<br />d_wort: dem","age: 2;04.00<br />avg_freq: 0.007436717<br />code: MOT<br />d_wort: dem","age: 2;05.07<br />avg_freq: 0.007137976<br />code: MOT<br />d_wort: dem","age: 2;06.14<br />avg_freq: 0.010235860<br />code: MOT<br />d_wort: dem","age: 2;08.00<br />avg_freq: 0.011038566<br />code: MOT<br />d_wort: dem","age: 2;09.07<br />avg_freq: 0.003600574<br />code: MOT<br />d_wort: dem","age: 2;10.14<br />avg_freq: 0.008145836<br />code: MOT<br />d_wort: dem","age: 3;00.00<br />avg_freq: 0.018361168<br />code: MOT<br />d_wort: dem","age: 3;01.07<br />avg_freq: 0.014443971<br />code: MOT<br />d_wort: dem","age: 3;02.14<br />avg_freq: 0.010854523<br />code: MOT<br />d_wort: dem","age: 3;04.00<br />avg_freq: 0.007876646<br />code: MOT<br />d_wort: dem","age: 3;05.07<br />avg_freq: 0.011346224<br />code: MOT<br />d_wort: dem","age: 3;06.14<br />avg_freq: 0.098371008<br />code: MOT<br />d_wort: dem","age: 3;08.00<br />avg_freq: 0.003418803<br />code: MOT<br />d_wort: dem"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(183,159,0,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"dem","legendgroup":"dem","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.211391918048201,0.123425692695214,0.1678767692079,0.181502764011383,0.193478504716429,0.110108303249097,0.179060046413448,0.154464183020425,0.202677584563506,0.197003347056113,0.178683420775388,0.164487619200715,0.171563774464049,0.208135041855011,0.1457426648615,0.115617437868908,0.127649241020972,0.124670151855495,0.189115907418476,0.284879696713197,0.0957231696133565,0.218529230279514,0.260170639584231,0.0734631971275807],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.0340874558780871,0.0188916876574307,0.0253449000292542,0.0284363737926122,0.0239399300523164,0.0270758122743682,0.0221872720518128,0.0241588412296059,0.0187730763021139,0.0306361656729346,0.0351863918565703,0.0287953117046212,0.0300537611668865,0.0222978497800854,0.0407172993900467,0.0385668235969594,0.0171286980314501,0.0305727889613487,0.0199030846417335,0.0248826933744267,0.0311952461282002,0.0253703934169681,0.0285455754483919,0.0650198552082114],"text":["age: 1;04.00<br />avg_freq: 0.034087456<br />code: MOT<br />d_wort: den","age: 1;04.07<br />avg_freq: 0.018891688<br />code: MOT<br />d_wort: den","age: 1;05.07<br />avg_freq: 0.025344900<br />code: MOT<br />d_wort: den","age: 1;06.14<br />avg_freq: 0.028436374<br />code: MOT<br />d_wort: den","age: 1;08.00<br />avg_freq: 0.023939930<br />code: MOT<br />d_wort: den","age: 1;08.13<br />avg_freq: 0.027075812<br />code: MOT<br />d_wort: den","age: 1;09.07<br />avg_freq: 0.022187272<br />code: MOT<br />d_wort: den","age: 1;10.14<br />avg_freq: 0.024158841<br />code: MOT<br />d_wort: den","age: 2;00.00<br />avg_freq: 0.018773076<br />code: MOT<br />d_wort: den","age: 2;01.07<br />avg_freq: 0.030636166<br />code: MOT<br />d_wort: den","age: 2;02.14<br />avg_freq: 0.035186392<br />code: MOT<br />d_wort: den","age: 2;04.00<br />avg_freq: 0.028795312<br />code: MOT<br />d_wort: den","age: 2;05.07<br />avg_freq: 0.030053761<br />code: MOT<br />d_wort: den","age: 2;06.14<br />avg_freq: 0.022297850<br />code: MOT<br />d_wort: den","age: 2;08.00<br />avg_freq: 0.040717299<br />code: MOT<br />d_wort: den","age: 2;09.07<br />avg_freq: 0.038566824<br />code: MOT<br />d_wort: den","age: 2;10.14<br />avg_freq: 0.017128698<br />code: MOT<br />d_wort: den","age: 3;00.00<br />avg_freq: 0.030572789<br />code: MOT<br />d_wort: den","age: 3;01.07<br />avg_freq: 0.019903085<br />code: MOT<br />d_wort: den","age: 3;02.14<br />avg_freq: 0.024882693<br />code: MOT<br />d_wort: den","age: 3;04.00<br />avg_freq: 0.031195246<br />code: MOT<br />d_wort: den","age: 3;05.07<br />avg_freq: 0.025370393<br />code: MOT<br />d_wort: den","age: 3;06.14<br />avg_freq: 0.028545575<br />code: MOT<br />d_wort: den","age: 3;08.00<br />avg_freq: 0.065019855<br />code: MOT<br />d_wort: den"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(0,186,56,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"den","legendgroup":"den","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.245479373926288,0.142317380352645,0.193221669237155,0.209939137803995,0.217418434768745,0.137184115523466,0.20124731846526,0.178623024250031,0.22145066086562,0.227639512729047,0.213869812631958,0.193282930905336,0.201617535630936,0.230432891635096,0.186459964251547,0.154184261465868,0.144777939052422,0.155242940816844,0.20901899206021,0.309762390087624,0.126918415741557,0.243899623696482,0.288716215032623,0.138483052335792],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.0716513195216608,0.0768261964735516,0.0715095434121665,0.0690679358581832,0.0708433430711593,0.0288808664259928,0.0529244726167489,0.0489608003115573,0.0580652653648404,0.0614598543162519,0.0642823491427662,0.062724346329193,0.0453573687618631,0.0520736134654125,0.0692765717251667,0.0549408697037773,0.0444290969738243,0.0468713074262266,0.03254558577884,0.0491607698628722,0.0535577190316117,0.0327321030269812,0.026095891694795,0.0345475256605394],"text":["age: 1;04.00<br />avg_freq: 0.071651320<br />code: MOT<br />d_wort: der","age: 1;04.07<br />avg_freq: 0.076826196<br />code: MOT<br />d_wort: der","age: 1;05.07<br />avg_freq: 0.071509543<br />code: MOT<br />d_wort: der","age: 1;06.14<br />avg_freq: 0.069067936<br />code: MOT<br />d_wort: der","age: 1;08.00<br />avg_freq: 0.070843343<br />code: MOT<br />d_wort: der","age: 1;08.13<br />avg_freq: 0.028880866<br />code: MOT<br />d_wort: der","age: 1;09.07<br />avg_freq: 0.052924473<br />code: MOT<br />d_wort: der","age: 1;10.14<br />avg_freq: 0.048960800<br />code: MOT<br />d_wort: der","age: 2;00.00<br />avg_freq: 0.058065265<br />code: MOT<br />d_wort: der","age: 2;01.07<br />avg_freq: 0.061459854<br />code: MOT<br />d_wort: der","age: 2;02.14<br />avg_freq: 0.064282349<br />code: MOT<br />d_wort: der","age: 2;04.00<br />avg_freq: 0.062724346<br />code: MOT<br />d_wort: der","age: 2;05.07<br />avg_freq: 0.045357369<br />code: MOT<br />d_wort: der","age: 2;06.14<br />avg_freq: 0.052073613<br />code: MOT<br />d_wort: der","age: 2;08.00<br />avg_freq: 0.069276572<br />code: MOT<br />d_wort: der","age: 2;09.07<br />avg_freq: 0.054940870<br />code: MOT<br />d_wort: der","age: 2;10.14<br />avg_freq: 0.044429097<br />code: MOT<br />d_wort: der","age: 3;00.00<br />avg_freq: 0.046871307<br />code: MOT<br />d_wort: der","age: 3;01.07<br />avg_freq: 0.032545586<br />code: MOT<br />d_wort: der","age: 3;02.14<br />avg_freq: 0.049160770<br />code: MOT<br />d_wort: der","age: 3;04.00<br />avg_freq: 0.053557719<br />code: MOT<br />d_wort: der","age: 3;05.07<br />avg_freq: 0.032732103<br />code: MOT<br />d_wort: der","age: 3;06.14<br />avg_freq: 0.026095892<br />code: MOT<br />d_wort: der","age: 3;08.00<br />avg_freq: 0.034547526<br />code: MOT<br />d_wort: der"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"der","legendgroup":"der","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.317130693447949,0.219143576826196,0.264731212649321,0.279007073662178,0.288261777839904,0.166064981949458,0.254171791082009,0.227583824561588,0.27951592623046,0.289099367045299,0.278152161774724,0.256007277234529,0.246974904392799,0.282506505100509,0.255736535976713,0.209125131169645,0.189207036026246,0.20211424824307,0.24156457783905,0.358923159950496,0.180476134773168,0.276631726723463,0.314812106727418,0.173030577996331],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.00490431475098063,0.0138539042821159,0.00398966541052875,0.0129707112970711,0.00969560315670803,0.0523465703971119,0.00821351734270875,0.00431440045897877,0.00611276619221007,0.00309227489783953,0.00150375939849623,0.00118676143879792,0.00164838008740448,0,0.000727802037845671,0,0,0,0.0012531328320802,0,0.00120772946859904,0,0,0.00547945205479453],"text":["age: 1;04.00<br />avg_freq: 0.004904315<br />code: MOT<br />d_wort: des","age: 1;04.07<br />avg_freq: 0.013853904<br />code: MOT<br />d_wort: des","age: 1;05.07<br />avg_freq: 0.003989665<br />code: MOT<br />d_wort: des","age: 1;06.14<br />avg_freq: 0.012970711<br />code: MOT<br />d_wort: des","age: 1;08.00<br />avg_freq: 0.009695603<br />code: MOT<br />d_wort: des","age: 1;08.13<br />avg_freq: 0.052346570<br />code: MOT<br />d_wort: des","age: 1;09.07<br />avg_freq: 0.008213517<br />code: MOT<br />d_wort: des","age: 1;10.14<br />avg_freq: 0.004314400<br />code: MOT<br />d_wort: des","age: 2;00.00<br />avg_freq: 0.006112766<br />code: MOT<br />d_wort: des","age: 2;01.07<br />avg_freq: 0.003092275<br />code: MOT<br />d_wort: des","age: 2;02.14<br />avg_freq: 0.001503759<br />code: MOT<br />d_wort: des","age: 2;04.00<br />avg_freq: 0.001186761<br />code: MOT<br />d_wort: des","age: 2;05.07<br />avg_freq: 0.001648380<br />code: MOT<br />d_wort: des","age: 2;06.14<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 2;08.00<br />avg_freq: 0.000727802<br />code: MOT<br />d_wort: des","age: 2;09.07<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 2;10.14<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 3;00.00<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 3;01.07<br />avg_freq: 0.001253133<br />code: MOT<br />d_wort: des","age: 3;02.14<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 3;04.00<br />avg_freq: 0.001207729<br />code: MOT<br />d_wort: des","age: 3;05.07<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 3;06.14<br />avg_freq: 0.000000000<br />code: MOT<br />d_wort: des","age: 3;08.00<br />avg_freq: 0.005479452<br />code: MOT<br />d_wort: des"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(97,156,255,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"des","legendgroup":"des","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0.32203500819893,0.232997481108312,0.26872087805985,0.291977784959249,0.297957380996612,0.21841155234657,0.262385308424718,0.231898225020567,0.28562869242267,0.292191641943139,0.279655921173221,0.257194038673327,0.248623284480203,0.282506505100509,0.256464338014559,0.209125131169645,0.189207036026246,0.20211424824307,0.24281771067113,0.358923159950496,0.181683864241768,0.276631726723463,0.314812106727418,0.178510030051126],"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.10951179702029,0.0705289672544081,0.0777848346161028,0.106556893776113,0.0887106802391606,0.0631768953068592,0.0868066284030374,0.0712497549473869,0.116115142529426,0.106033364036099,0.0913283391430851,0.093038829367139,0.0950164561359492,0.124345945531664,0.0841554948079992,0.0924161442497076,0.0883555656677135,0.0863531419958284,0.146741900503943,0.0884003022111724,0.0989458001533886,0.0771016545190306,0.0441724177625132,0.051243145806502],"text":["age: 1;04.00<br />avg_freq: 0.109511797<br />code: MOT<br />d_wort: die","age: 1;04.07<br />avg_freq: 0.070528967<br />code: MOT<br />d_wort: die","age: 1;05.07<br />avg_freq: 0.077784835<br />code: MOT<br />d_wort: die","age: 1;06.14<br />avg_freq: 0.106556894<br />code: MOT<br />d_wort: die","age: 1;08.00<br />avg_freq: 0.088710680<br />code: MOT<br />d_wort: die","age: 1;08.13<br />avg_freq: 0.063176895<br />code: MOT<br />d_wort: die","age: 1;09.07<br />avg_freq: 0.086806628<br />code: MOT<br />d_wort: die","age: 1;10.14<br />avg_freq: 0.071249755<br />code: MOT<br />d_wort: die","age: 2;00.00<br />avg_freq: 0.116115143<br />code: MOT<br />d_wort: die","age: 2;01.07<br />avg_freq: 0.106033364<br />code: MOT<br />d_wort: die","age: 2;02.14<br />avg_freq: 0.091328339<br />code: MOT<br />d_wort: die","age: 2;04.00<br />avg_freq: 0.093038829<br />code: MOT<br />d_wort: die","age: 2;05.07<br />avg_freq: 0.095016456<br />code: MOT<br />d_wort: die","age: 2;06.14<br />avg_freq: 0.124345946<br />code: MOT<br />d_wort: die","age: 2;08.00<br />avg_freq: 0.084155495<br />code: MOT<br />d_wort: die","age: 2;09.07<br />avg_freq: 0.092416144<br />code: MOT<br />d_wort: die","age: 2;10.14<br />avg_freq: 0.088355566<br />code: MOT<br />d_wort: die","age: 3;00.00<br />avg_freq: 0.086353142<br />code: MOT<br />d_wort: die","age: 3;01.07<br />avg_freq: 0.146741901<br />code: MOT<br />d_wort: die","age: 3;02.14<br />avg_freq: 0.088400302<br />code: MOT<br />d_wort: die","age: 3;04.00<br />avg_freq: 0.098945800<br />code: MOT<br />d_wort: die","age: 3;05.07<br />avg_freq: 0.077101655<br />code: MOT<br />d_wort: die","age: 3;06.14<br />avg_freq: 0.044172418<br />code: MOT<br />d_wort: die","age: 3;08.00<br />avg_freq: 0.051243146<br />code: MOT<br />d_wort: die"],"type":"bar","textposition":"none","marker":{"autocolorscale":false,"color":"rgba(245,100,227,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"die","legendgroup":"die","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"y":[0.0633668400656132,0.0617667646868928,0.0604947609586272,0.0596485039336151,0.0591373978910655,0.0588293228751665,0.0589536265766625,0.0594905975224256,0.0599345270108356,0.0604828947398604,0.061168789215317,0.0612399149473582,0.0598273773974641,0.0576096361143668,0.0561554267390974,0.0560870102353177,0.0564362093999417,0.0563861026238785,0.0559076843639182,0.0553738840564102,0.0545706825616017,0.0534182067156295,0.051992422471043,0.0503130693627087],"text":["age:  1<br />avg_freq: 0.06336684<br />code: MOT<br />d_wort: grey60","age:  2<br />avg_freq: 0.06176676<br />code: MOT<br />d_wort: grey60","age:  3<br />avg_freq: 0.06049476<br />code: MOT<br />d_wort: grey60","age:  4<br />avg_freq: 0.05964850<br />code: MOT<br />d_wort: grey60","age:  5<br />avg_freq: 0.05913740<br />code: MOT<br />d_wort: grey60","age:  6<br />avg_freq: 0.05882932<br />code: MOT<br />d_wort: grey60","age:  7<br />avg_freq: 0.05895363<br />code: MOT<br />d_wort: grey60","age:  8<br />avg_freq: 0.05949060<br />code: MOT<br />d_wort: grey60","age:  9<br />avg_freq: 0.05993453<br />code: MOT<br />d_wort: grey60","age: 10<br />avg_freq: 0.06048289<br />code: MOT<br />d_wort: grey60","age: 11<br />avg_freq: 0.06116879<br />code: MOT<br />d_wort: grey60","age: 12<br />avg_freq: 0.06123991<br />code: MOT<br />d_wort: grey60","age: 13<br />avg_freq: 0.05982738<br />code: MOT<br />d_wort: grey60","age: 14<br />avg_freq: 0.05760964<br />code: MOT<br />d_wort: grey60","age: 15<br />avg_freq: 0.05615543<br />code: MOT<br />d_wort: grey60","age: 16<br />avg_freq: 0.05608701<br />code: MOT<br />d_wort: grey60","age: 17<br />avg_freq: 0.05643621<br />code: MOT<br />d_wort: grey60","age: 18<br />avg_freq: 0.05638610<br />code: MOT<br />d_wort: grey60","age: 19<br />avg_freq: 0.05590768<br />code: MOT<br />d_wort: grey60","age: 20<br />avg_freq: 0.05537388<br />code: MOT<br />d_wort: grey60","age: 21<br />avg_freq: 0.05457068<br />code: MOT<br />d_wort: grey60","age: 22<br />avg_freq: 0.05341821<br />code: MOT<br />d_wort: grey60","age: 23<br />avg_freq: 0.05199242<br />code: MOT<br />d_wort: grey60","age: 24<br />avg_freq: 0.05031307<br />code: MOT<br />d_wort: grey60"],"type":"scatter","mode":"lines","name":"fitted values","line":{"width":3.77952755905512,"color":"rgba(51,102,255,1)","dash":"solid"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":43.1050228310502},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,24.6],"tickmode":"array","ticktext":["1;04.00","1;04.07","1;05.07","1;06.14","1;08.00","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00"],"tickvals":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],"categoryorder":"array","categoryarray":["1;04.00","1;04.07","1;05.07","1;06.14","1;08.00","1;08.13","1;09.07","1;10.14","2;00.00","2;01.07","2;02.14","2;04.00","2;05.07","2;06.14","2;08.00","2;09.07","2;10.14","3;00.00","3;01.07","3;02.14","3;04.00","3;05.07","3;06.14","3;08.00"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-60,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"age","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.0223661731080834,0.469689635269752],"tickmode":"array","ticktext":["0%","10%","20%","30%","40%"],"tickvals":[0,0.1,0.2,0.3,0.4],"categoryorder":"array","categoryarray":["0%","10%","20%","30%","40%"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"mean frequency","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"title":{"text":"d_wort","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"50c21ce1ccf":{"x":{},"y":{},"fill":{},"type":"bar"},"50c53367f2b":{"x":{},"y":{},"fill":{}}},"cur_data":"50c21ce1ccf","visdat":{"50c21ce1ccf":["function (y) ","x"],"50c53367f2b":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```




```r
library(patchwork)
gesamt1 <- (children + theme(legend.position = "top", 
                  axis.ticks.x = element_blank(),
                  axis.text.x = element_blank(), 
                  axis.title.x = element_blank()) +
    guides(fill = guide_legend(nrow = 1))) / 
  (mothers + theme(legend.position = "none"))

ggsave(plot = gesamt1, filename ="pictures/szagun_gesamtfrequenz.jpg", dpi = 300)

gesamt1    
```

<img src="06-Szagun_NH_chisq5_files/figure-html/unnamed-chunk-9-1.svg" width="672" />


## 2. Welche d-Form am häufigsten?


```r
topn <- szagun %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(code, d_wort) %>% 
  add_count(code) %>% 
  summarise(freqsum = sum(freq)) %>% 
  mutate(pct = freqsum/sum(freqsum)) %>% 
  mutate(d_wort = fct_reorder(d_wort, pct)) %>% 
  ggplot(aes(pct, d_wort, color = code)) +
  # geom_col(position = "dodge", color = "black") +
  geom_segment(aes(yend = d_wort, xend = 0), size = 2) +
  geom_point(size = 6) +
  geom_point(size = 2, color = "black") +
  scale_x_continuous(labels = label_percent()) +
  # guides(fill = guide_legend(nrow = 1)) +
  theme(legend.position = "none") +
  # labs(fill = "d-Wort: ") +
  facet_wrap(~ code, dir = "v")

ggsave(plot = topn, filename ="pictures/szagun_frequenzverteilung.jpg", dpi = 300)

topn
```

<img src="06-Szagun_NH_chisq5_files/figure-html/unnamed-chunk-10-1.svg" width="672" />



```r
d <- szagun %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freq)) %>% 
  pivot_wider(names_from = code, values_from = freqsum)

d %>% 
  arrange(-CHI) %>% 
  rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["d_wort"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHI"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["MOT"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"das","2":"11263","3":"6519"},{"1":"die","2":"6739","3":"3778"},{"1":"der","2":"4269","3":"2269"},{"1":"den","2":"1730","3":"1134"},{"1":"des","2":"311","3":"198"},{"1":"dem","2":"103","3":"378"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
Sowohl bei den Kindern (CHI) als auch bei den Müttern (MOT) ergibt sich fast dieselbe Reihenfolge der Häufigkeiten. Der auffälligste Unterschied ist der zwischen den Häufigkeiten von *des* und *dem*. 


```r
d_dem <- szagun %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freq)) %>% 
  mutate(d_wort = ifelse(d_wort == "dem", "dem", "andere")) %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freqsum)) %>% 
  pivot_wider(names_from = code, values_from = freqsum)
d_dem
```

```
## # A tibble: 2 x 3
##   d_wort   CHI   MOT
##   <chr>  <dbl> <dbl>
## 1 andere 24312 13898
## 2 dem      103   378
```


Mit dem $\chi^2$-Quadrat-Test kann man prüfen, ob die beiden Stichproben statistisch signifikant unterschiedlich sind.


```r
chires <- chisq.test(d_dem[,-1], B = 2000) # B: mit Monte Carlo test
chires
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  d_dem[, -1]
## X-squared = 361.75, df = 1, p-value < 2.2e-16
```


```r
observed <- chires$observed %>% as_tibble() %>% round(0) %>% 
  rename(CHI_obs = CHI, MOT_obs = MOT)
expected <- chires$expected %>% as_tibble() %>% round(0) %>% 
  rename(CHI_exp = CHI, MOT_exp = MOT)

frequenztabelle <- bind_cols(d_dem[,1], observed, expected)

frequenztabelle %>% 
  arrange(-CHI_obs) %>% 
  rmarkdown::paged_table()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["d_wort"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHI_obs"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["MOT_obs"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["CHI_exp"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["MOT_exp"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"andere","2":"24312","3":"13898","4":"24111","5":"14099"},{"1":"dem","2":"103","3":"378","4":"304","5":"177"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Hier folgt ein $\chi^2$-Quadrat-Test mit einem Kind, und zwar mit *Rahel* und ihrer *MOT*:


```r
szagun %>% 
  filter(id == "Rahel") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freq)) %>% 
  mutate(d_wort = ifelse(d_wort == "dem", "dem", "andere")) %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freqsum)) %>% 
  pivot_wider(names_from = code, values_from = freqsum) %>% 
  select(-d_wort) %>% 
  chisq.test(.)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  .
## X-squared = 96.562, df = 1, p-value < 2.2e-16
```

Eine Frequenztabelle mit den d-Wörtern von *Soren* und seiner *MOT* (aber ohne $\chi^2$-Quadrat-Test):


```r
szagun %>% 
  filter(id == "Soeren") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(code, d_wort) %>% 
  summarise(freqsum = sum(freq)) %>% 
  pivot_wider(names_from = code, values_from = freqsum)
```

```
## # A tibble: 6 x 3
##   d_wort   CHI   MOT
##   <chr>  <dbl> <dbl>
## 1 das     2552  1136
## 2 dem        9    24
## 3 den      432   198
## 4 der     1101   300
## 5 des       24     1
## 6 die     1556   519
```

## 3. Welche Form als erste?

Zur Beantwortung dieser Frage filtern wir zuerst die Spalten *id* und *code*. Dann sortieren wir die jeweilige Tabellen für das ausgewählte Kind nach Alter *age*. Mit der Funktion `pivot_longer()` bilden wir eine lange Tabellenform. 


```r
szagun %>% 
  filter(id == "Rahel",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 92 x 10
## # Groups:   age [22]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Rahel 10400 CHI   1;04.00        428     1     4 0.25  die        4
##  2 Rahel 10507 CHI   1;05.07        630     3     4 0.75  das        1
##  3 Rahel 10507 CHI   1;05.07        630     3     4 0.75  der        1
##  4 Rahel 10507 CHI   1;05.07        630     3     4 0.75  des        2
##  5 Rahel 10614 CHI   1;06.14        632     2    16 0.125 das        1
##  6 Rahel 10614 CHI   1;06.14        632     2    16 0.125 die       15
##  7 Rahel 10800 CHI   1;08.00        909     3    11 0.273 das        8
##  8 Rahel 10800 CHI   1;08.00        909     3    11 0.273 des        1
##  9 Rahel 10800 CHI   1;08.00        909     3    11 0.273 die        2
## 10 Rahel 10907 CHI   1;09.07        424     3     6 0.5   das        4
## # ... with 82 more rows
```

```r
szagun %>% 
  filter(id == "Anna",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 116 x 10
## # Groups:   age [22]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Anna  10400 CHI   1;04.00        230     2    12 0.167 das        1
##  2 Anna  10400 CHI   1;04.00        230     2    12 0.167 die       11
##  3 Anna  10507 CHI   1;05.07        633     4    23 0.174 das        7
##  4 Anna  10507 CHI   1;05.07        633     4    23 0.174 den        1
##  5 Anna  10507 CHI   1;05.07        633     4    23 0.174 des        5
##  6 Anna  10507 CHI   1;05.07        633     4    23 0.174 die       10
##  7 Anna  10614 CHI   1;06.14        845     4    76 0.053 das       68
##  8 Anna  10614 CHI   1;06.14        845     4    76 0.053 der        1
##  9 Anna  10614 CHI   1;06.14        845     4    76 0.053 des        1
## 10 Anna  10614 CHI   1;06.14        845     4    76 0.053 die        6
## # ... with 106 more rows
```

```r
szagun %>% 
  filter(id == "Emely",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 78 x 10
## # Groups:   age [21]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Emely 10407 CHI   1;04.07        374     1     1 1     des        1
##  2 Emely 10507 CHI   1;05.07        235     2     2 1     das        1
##  3 Emely 10507 CHI   1;05.07        235     2     2 1     des        1
##  4 Emely 10813 CHI   1;08.13        321     2     2 1     das        1
##  5 Emely 10813 CHI   1;08.13        321     2     2 1     des        1
##  6 Emely 10907 CHI   1;09.07        720     3    40 0.075 der        3
##  7 Emely 10907 CHI   1;09.07        720     3    40 0.075 des        1
##  8 Emely 10907 CHI   1;09.07        720     3    40 0.075 die       36
##  9 Emely 11014 CHI   1;10.14        875     4    76 0.053 das        1
## 10 Emely 11014 CHI   1;10.14        875     4    76 0.053 der        1
## # ... with 68 more rows
```

```r
szagun %>% 
  filter(id == "Falko",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 93 x 10
## # Groups:   age [19]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Falko 10800 CHI   1;08.00        311     1     2 0.5   die        2
##  2 Falko 10907 CHI   1;09.07        238     2     3 0.667 das        1
##  3 Falko 10907 CHI   1;09.07        238     2     3 0.667 den        2
##  4 Falko 11014 CHI   1;10.14        378     2    28 0.071 das       27
##  5 Falko 11014 CHI   1;10.14        378     2    28 0.071 der        1
##  6 Falko 20000 CHI   2;00.00        817     6    55 0.109 das       37
##  7 Falko 20000 CHI   2;00.00        817     6    55 0.109 dem        1
##  8 Falko 20000 CHI   2;00.00        817     6    55 0.109 den        7
##  9 Falko 20000 CHI   2;00.00        817     6    55 0.109 der        4
## 10 Falko 20000 CHI   2;00.00        817     6    55 0.109 des        1
## # ... with 83 more rows
```

```r
szagun %>% 
  filter(id == "Lisa",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 94 x 10
## # Groups:   age [21]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Lisa  10507 CHI   1;05.07        694     2     3 0.667 das        1
##  2 Lisa  10507 CHI   1;05.07        694     2     3 0.667 die        2
##  3 Lisa  10614 CHI   1;06.14        555     2    24 0.083 den        1
##  4 Lisa  10614 CHI   1;06.14        555     2    24 0.083 die       23
##  5 Lisa  10800 CHI   1;08.00        410     3    11 0.273 den        3
##  6 Lisa  10800 CHI   1;08.00        410     3    11 0.273 der        3
##  7 Lisa  10800 CHI   1;08.00        410     3    11 0.273 die        5
##  8 Lisa  10907 CHI   1;09.07        580     4    20 0.2   das        2
##  9 Lisa  10907 CHI   1;09.07        580     4    20 0.2   den        3
## 10 Lisa  10907 CHI   1;09.07        580     4    20 0.2   der        5
## # ... with 84 more rows
```

```r
szagun %>% 
  filter(id == "Soeren",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(freq > 0)
```

```
## # A tibble: 95 x 10
## # Groups:   age [22]
##    id     age1  code  age     utterances types token   ttr d_wort  freq
##    <chr>  <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Soeren 10400 CHI   1;04.00        487     1     1 1     das        1
##  2 Soeren 10507 CHI   1;05.07        663     2    21 0.095 das       19
##  3 Soeren 10507 CHI   1;05.07        663     2    21 0.095 der        2
##  4 Soeren 10614 CHI   1;06.14        765     4    68 0.059 das       23
##  5 Soeren 10614 CHI   1;06.14        765     4    68 0.059 den       39
##  6 Soeren 10614 CHI   1;06.14        765     4    68 0.059 der        1
##  7 Soeren 10614 CHI   1;06.14        765     4    68 0.059 die        5
##  8 Soeren 10800 CHI   1;08.00        753     5    84 0.06  das       42
##  9 Soeren 10800 CHI   1;08.00        753     5    84 0.06  dem        1
## 10 Soeren 10800 CHI   1;08.00        753     5    84 0.06  den       35
## # ... with 85 more rows
```


## 4. Wann alle d-Formen vertreten?

Die Vorgangsweise ist fast dieselbe wie bei der vorherigen Frage, aber wir filtern dieses Mal zusätzlich die Anzahl der *types*.


```r
szagun %>% 
  filter(id == "Rahel",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 66 x 10
## # Groups:   age [11]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Rahel 20107 CHI   2;01.07        556     5    25 0.2   das       18
##  2 Rahel 20107 CHI   2;01.07        556     5    25 0.2   dem        0
##  3 Rahel 20107 CHI   2;01.07        556     5    25 0.2   den        1
##  4 Rahel 20107 CHI   2;01.07        556     5    25 0.2   der        1
##  5 Rahel 20107 CHI   2;01.07        556     5    25 0.2   des        3
##  6 Rahel 20107 CHI   2;01.07        556     5    25 0.2   die        2
##  7 Rahel 20400 CHI   2;04.00       1115     5   122 0.041 das      100
##  8 Rahel 20400 CHI   2;04.00       1115     5   122 0.041 dem        0
##  9 Rahel 20400 CHI   2;04.00       1115     5   122 0.041 den        2
## 10 Rahel 20400 CHI   2;04.00       1115     5   122 0.041 der        5
## # ... with 56 more rows
```

```r
szagun %>% 
  filter(id == "Rahel",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 12 x 10
## # Groups:   age [2]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Rahel 21014 CHI   2;10.14        741     6   362 0.017 das      159
##  2 Rahel 21014 CHI   2;10.14        741     6   362 0.017 dem        3
##  3 Rahel 21014 CHI   2;10.14        741     6   362 0.017 den        5
##  4 Rahel 21014 CHI   2;10.14        741     6   362 0.017 der       57
##  5 Rahel 21014 CHI   2;10.14        741     6   362 0.017 des        1
##  6 Rahel 21014 CHI   2;10.14        741     6   362 0.017 die      137
##  7 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 das      233
##  8 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 dem        4
##  9 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 den       16
## 10 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 der       57
## 11 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 des        1
## 12 Rahel 30107 CHI   3;01.07       1035     6   420 0.014 die      109
```

```r
szagun %>% 
  filter(id == "Anna",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 114 x 10
## # Groups:   age [19]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Anna  10800 CHI   1;08.00       1247     5    87 0.057 das       66
##  2 Anna  10800 CHI   1;08.00       1247     5    87 0.057 dem        0
##  3 Anna  10800 CHI   1;08.00       1247     5    87 0.057 den        5
##  4 Anna  10800 CHI   1;08.00       1247     5    87 0.057 der        1
##  5 Anna  10800 CHI   1;08.00       1247     5    87 0.057 des        2
##  6 Anna  10800 CHI   1;08.00       1247     5    87 0.057 die       13
##  7 Anna  10907 CHI   1;09.07       1076     5   149 0.034 das      127
##  8 Anna  10907 CHI   1;09.07       1076     5   149 0.034 dem        0
##  9 Anna  10907 CHI   1;09.07       1076     5   149 0.034 den        5
## 10 Anna  10907 CHI   1;09.07       1076     5   149 0.034 der        7
## # ... with 104 more rows
```

```r
szagun %>% 
  filter(id == "Anna",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 66 x 10
## # Groups:   age [11]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Anna  20000 CHI   2;00.00        957     6   226 0.027 das       93
##  2 Anna  20000 CHI   2;00.00        957     6   226 0.027 dem        1
##  3 Anna  20000 CHI   2;00.00        957     6   226 0.027 den        4
##  4 Anna  20000 CHI   2;00.00        957     6   226 0.027 der       32
##  5 Anna  20000 CHI   2;00.00        957     6   226 0.027 des        9
##  6 Anna  20000 CHI   2;00.00        957     6   226 0.027 die       87
##  7 Anna  20214 CHI   2;02.14        929     6   251 0.024 das       55
##  8 Anna  20214 CHI   2;02.14        929     6   251 0.024 dem        3
##  9 Anna  20214 CHI   2;02.14        929     6   251 0.024 den       14
## 10 Anna  20214 CHI   2;02.14        929     6   251 0.024 der       57
## # ... with 56 more rows
```

```r
szagun %>% 
  filter(id == "Emely",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 54 x 10
## # Groups:   age [9]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Emely 20907 CHI   2;09.07       1103     5   161 0.031 das      107
##  2 Emely 20907 CHI   2;09.07       1103     5   161 0.031 dem        0
##  3 Emely 20907 CHI   2;09.07       1103     5   161 0.031 den        4
##  4 Emely 20907 CHI   2;09.07       1103     5   161 0.031 der       28
##  5 Emely 20907 CHI   2;09.07       1103     5   161 0.031 des        3
##  6 Emely 20907 CHI   2;09.07       1103     5   161 0.031 die       19
##  7 Emely 21014 CHI   2;10.14       1004     5   217 0.023 das      141
##  8 Emely 21014 CHI   2;10.14       1004     5   217 0.023 dem        0
##  9 Emely 21014 CHI   2;10.14       1004     5   217 0.023 den        7
## 10 Emely 21014 CHI   2;10.14       1004     5   217 0.023 der       28
## # ... with 44 more rows
```

```r
szagun %>% 
  filter(id == "Emely",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 0 x 10
## # Groups:   age [0]
## # ... with 10 variables: id <chr>, age1 <chr>, code <chr>, age <chr>,
## #   utterances <dbl>, types <dbl>, token <dbl>, ttr <dbl>, d_wort <chr>,
## #   freq <dbl>
```

```r
szagun %>% 
  filter(id == "Falko",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 90 x 10
## # Groups:   age [15]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Falko 20000 CHI   2;00.00        817     6    55 0.109 das       37
##  2 Falko 20000 CHI   2;00.00        817     6    55 0.109 dem        1
##  3 Falko 20000 CHI   2;00.00        817     6    55 0.109 den        7
##  4 Falko 20000 CHI   2;00.00        817     6    55 0.109 der        4
##  5 Falko 20000 CHI   2;00.00        817     6    55 0.109 des        1
##  6 Falko 20000 CHI   2;00.00        817     6    55 0.109 die        5
##  7 Falko 20107 CHI   2;01.07        734     5   251 0.02  das      195
##  8 Falko 20107 CHI   2;01.07        734     5   251 0.02  dem        0
##  9 Falko 20107 CHI   2;01.07        734     5   251 0.02  den        5
## 10 Falko 20107 CHI   2;01.07        734     5   251 0.02  der        6
## # ... with 80 more rows
```

```r
szagun %>% 
  filter(id == "Falko",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 54 x 10
## # Groups:   age [9]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Falko 20000 CHI   2;00.00        817     6    55 0.109 das       37
##  2 Falko 20000 CHI   2;00.00        817     6    55 0.109 dem        1
##  3 Falko 20000 CHI   2;00.00        817     6    55 0.109 den        7
##  4 Falko 20000 CHI   2;00.00        817     6    55 0.109 der        4
##  5 Falko 20000 CHI   2;00.00        817     6    55 0.109 des        1
##  6 Falko 20000 CHI   2;00.00        817     6    55 0.109 die        5
##  7 Falko 20614 CHI   2;06.14        806     6   290 0.021 das      149
##  8 Falko 20614 CHI   2;06.14        806     6   290 0.021 dem        1
##  9 Falko 20614 CHI   2;06.14        806     6   290 0.021 den       17
## 10 Falko 20614 CHI   2;06.14        806     6   290 0.021 der       42
## # ... with 44 more rows
```

```r
szagun %>% 
  filter(id == "Lisa",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 66 x 10
## # Groups:   age [11]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Lisa  20400 CHI   2;04.00        693     5   140 0.036 das       94
##  2 Lisa  20400 CHI   2;04.00        693     5   140 0.036 dem        0
##  3 Lisa  20400 CHI   2;04.00        693     5   140 0.036 den       20
##  4 Lisa  20400 CHI   2;04.00        693     5   140 0.036 der        4
##  5 Lisa  20400 CHI   2;04.00        693     5   140 0.036 des        6
##  6 Lisa  20400 CHI   2;04.00        693     5   140 0.036 die       16
##  7 Lisa  20507 CHI   2;05.07        735     6   126 0.048 das       46
##  8 Lisa  20507 CHI   2;05.07        735     6   126 0.048 dem        1
##  9 Lisa  20507 CHI   2;05.07        735     6   126 0.048 den       35
## 10 Lisa  20507 CHI   2;05.07        735     6   126 0.048 der        9
## # ... with 56 more rows
```

```r
szagun %>% 
  filter(id == "Lisa",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 30 x 10
## # Groups:   age [5]
##    id    age1  code  age     utterances types token   ttr d_wort  freq
##    <chr> <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Lisa  20507 CHI   2;05.07        735     6   126 0.048 das       46
##  2 Lisa  20507 CHI   2;05.07        735     6   126 0.048 dem        1
##  3 Lisa  20507 CHI   2;05.07        735     6   126 0.048 den       35
##  4 Lisa  20507 CHI   2;05.07        735     6   126 0.048 der        9
##  5 Lisa  20507 CHI   2;05.07        735     6   126 0.048 des        2
##  6 Lisa  20507 CHI   2;05.07        735     6   126 0.048 die       33
##  7 Lisa  30000 CHI   3;00.00        602     6   197 0.03  das       94
##  8 Lisa  30000 CHI   3;00.00        602     6   197 0.03  dem        2
##  9 Lisa  30000 CHI   3;00.00        602     6   197 0.03  den       12
## 10 Lisa  30000 CHI   3;00.00        602     6   197 0.03  der       13
## # ... with 20 more rows
```

```r
szagun %>% 
  filter(id == "Soeren",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types >= 5)
```

```
## # A tibble: 72 x 10
## # Groups:   age [12]
##    id     age1  code  age     utterances types token   ttr d_wort  freq
##    <chr>  <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
##  1 Soeren 10800 CHI   1;08.00        753     5    84  0.06 das       42
##  2 Soeren 10800 CHI   1;08.00        753     5    84  0.06 dem        1
##  3 Soeren 10800 CHI   1;08.00        753     5    84  0.06 den       35
##  4 Soeren 10800 CHI   1;08.00        753     5    84  0.06 der        3
##  5 Soeren 10800 CHI   1;08.00        753     5    84  0.06 des        0
##  6 Soeren 10800 CHI   1;08.00        753     5    84  0.06 die        3
##  7 Soeren 20000 CHI   2;00.00        679     5   101  0.05 das       60
##  8 Soeren 20000 CHI   2;00.00        679     5   101  0.05 dem        1
##  9 Soeren 20000 CHI   2;00.00        679     5   101  0.05 den       14
## 10 Soeren 20000 CHI   2;00.00        679     5   101  0.05 der       13
## # ... with 62 more rows
```

```r
szagun %>% 
  filter(id == "Soeren",
         code == "CHI") %>% 
  group_by(age) %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  filter(types == 6)
```

```
## # A tibble: 6 x 10
## # Groups:   age [1]
##   id     age1  code  age     utterances types token   ttr d_wort  freq
##   <chr>  <chr> <chr> <chr>        <dbl> <dbl> <dbl> <dbl> <chr>  <dbl>
## 1 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 das      169
## 2 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 dem        2
## 3 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 den       25
## 4 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 der       67
## 5 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 des        2
## 6 Soeren 30214 CHI   3;02.14       1119     6   361 0.017 die       96
```

## 5. Bevorzugtes d-Wort von MOT


```r
szagun %>% 
  filter(id == "Rahel",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das     1051
## 2 die      602
## 3 der      382
## 4 den      217
## 5 dem       73
## 6 des        1
```

```r
szagun %>% 
  filter(id == "Anna",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das     1315
## 2 die     1052
## 3 der      557
## 4 den      252
## 5 dem      132
## 6 des      129
```

```r
szagun %>% 
  filter(id == "Emely",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das      831
## 2 die      376
## 3 der      287
## 4 den      106
## 5 des       66
## 6 dem       24
```

```r
szagun %>% 
  filter(id == "Falko",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das      951
## 2 die      594
## 3 der      468
## 4 den      175
## 5 dem       44
## 6 des        0
```

```r
szagun %>% 
  filter(id == "Lisa",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das     1235
## 2 die      635
## 3 der      275
## 4 den      186
## 5 dem       81
## 6 des        1
```

```r
szagun %>% 
  filter(id == "Soeren",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(-sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 das     1136
## 2 die      519
## 3 der      300
## 4 den      198
## 5 dem       24
## 6 des        1
```

## 6. Welche Formen hört Rahel nie / kaum?


```r
szagun %>% 
  filter(id == "Rahel",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 des        1
## 2 dem       73
## 3 den      217
## 4 der      382
## 5 die      602
## 6 das     1051
```

```r
szagun %>% 
  filter(id == "Anna",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 des      129
## 2 dem      132
## 3 den      252
## 4 der      557
## 5 die     1052
## 6 das     1315
```

```r
szagun %>% 
  filter(id == "Emely",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 dem       24
## 2 des       66
## 3 den      106
## 4 der      287
## 5 die      376
## 6 das      831
```

```r
szagun %>% 
  filter(id == "Falko",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 des        0
## 2 dem       44
## 3 den      175
## 4 der      468
## 5 die      594
## 6 das      951
```

```r
szagun %>% 
  filter(id == "Lisa",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 des        1
## 2 dem       81
## 3 den      186
## 4 der      275
## 5 die      635
## 6 das     1235
```

```r
szagun %>% 
  filter(id == "Soeren",
         code == "MOT") %>% 
  pivot_longer(das:die, names_to = "d_wort", values_to = "freq") %>% 
  group_by(d_wort) %>% 
  summarise(sum = sum(freq)) %>% 
  arrange(sum)
```

```
## # A tibble: 6 x 2
##   d_wort   sum
##   <chr>  <dbl>
## 1 des        1
## 2 dem       24
## 3 den      198
## 4 der      300
## 5 die      519
## 6 das     1136
```


