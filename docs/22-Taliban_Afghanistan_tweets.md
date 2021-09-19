# Taliban in Afghanistan

Ein brisantes politisches Thema. Was passiert in Afghanistan nach dem Abzug der NATO-Truppen und der Machtübernahme der Taliban?


```r
library(tidyverse)
library(tidytext)
library(rtweet)
```


## Fetch Stream


```r
library(tidyverse)
library(rtweet)

## Stream keywords used to filter tweets
q <- "Afghanistan"
## Stream for 30 minutes
streamtime <- 30 * 60
## Filename to save json data (backup)
filename <- "data/afghanistan.json"

## Stream tweets
rt_rollingstones <- stream_tweets(q = q, timeout = streamtime, file_name = filename)
```


```r
library(jsonlite)
fromJSON("data/afghanistan.json")
```


## Fetch tweets


```r
library(tidyverse)
library(rtweet)

q <- "Afghanistan"
tweets_afghanistan_de <- search_tweets(q = q, 
                        n = 18000,
                        token = bearer_token(), 
                        include_rts = FALSE,
                        `-filter` = "replies",
                        lang = "de")

tweets_afghanistan_de
```



```r
q <- "Afghanistan"
tweets_afghanistan_en <- search_tweets(q = q, 
                        n = 18000,
                        token = bearer_token(), 
                        include_rts = FALSE,
                        `-filter` = "replies",
                        lang = "en")

tweets_afghanistan_en
```



```r
q <- "Afganistan"
tweets_afghanistan_sl <- search_tweets(q = q, 
                        n = 18000,
                        token = bearer_token(), 
                        include_rts = FALSE,
                        `-filter` = "replies",
                        lang = "sl")

tweets_afghanistan_sl
```


## Gather tweets


```r
tweets_afghanistan <- bind_rows(tweets_afghanistan_sl,
                                tweets_afghanistan_de,
                                tweets_afghanistan_en)
```

## Save tweets


```r
library(writexl)
write_xlsx(tweets_afghanistan, "data/tweets_afghanistan.xlsx")
write_rds(tweets_afghanistan, "data/tweets_afghanistan.rds")
```

## Load tweets


```r
tweets_afghanistan <- read_rds("data/tweets_afghanistan.rds")

tweets_afghanistan_de <- subset(tweets_afghanistan, lang = "de")
tweets_afghanistan_en <- subset(tweets_afghanistan, lang = "en")
tweets_afghanistan_sl <- subset(tweets_afghanistan, lang = "sl")
```


## Who wrote about


```r
tweets_afghanistan %>% 
  filter(str_detect(screen_name, "spiegel"))
```

```
## # A tibble: 50 x 90
##    user_id status_id           created_at          screen_name text       source
##    <chr>   <chr>               <dttm>              <chr>       <chr>      <chr> 
##  1 2834511 1432320891380174850 2021-08-30 12:34:46 derspiegel  "Die Mita~ Tweet~
##  2 2834511 1432588199164059648 2021-08-31 06:16:57 derspiegel  "Um kurz ~ Tweet~
##  3 2834511 1431985249659936774 2021-08-29 14:21:03 derspiegel  "Saad Moh~ dlvr.~
##  4 2834511 1432795329267707906 2021-08-31 20:00:01 derspiegel  "Nach dem~ Tweet~
##  5 2834511 1432649500972093440 2021-08-31 10:20:33 derspiegel  "Sebastia~ dlvr.~
##  6 2834511 1432300816803590145 2021-08-30 11:15:00 derspiegel  "Die US-S~ Tweet~
##  7 2834511 1432935850015399937 2021-09-01 05:18:23 derspiegel  "Zum Ende~ Tweet~
##  8 2834511 1432609282567061511 2021-08-31 07:40:44 derspiegel  "Nach dem~ Tweet~
##  9 2834511 1432327492803735557 2021-08-30 13:01:00 derspiegel  "Die Gefä~ Tweet~
## 10 2834511 1432803515676585984 2021-08-31 20:32:32 derspiegel  "In einer~ dlvr.~
## # ... with 40 more rows, and 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```



```r
tweets_afghanistan %>% 
  filter(str_detect(screen_name, "Tonin"))
```

```
## # A tibble: 2 x 90
##   user_id            status_id  created_at          screen_name text      source
##   <chr>              <chr>      <dttm>              <chr>       <chr>     <chr> 
## 1 959105459922919427 143312194~ 2021-09-01 17:37:52 MatejTonin  Tudi v o~ Twitt~
## 2 959105459922919427 143312194~ 2021-09-01 17:37:52 MatejTonin  Afghanis~ Twitt~
## # ... with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```



```r
tweets_afghanistan %>% 
  filter(str_detect(screen_name, "SpletnaMladina"))
```

```
## # A tibble: 4 x 90
##   user_id   status_id           created_at          screen_name  text     source
##   <chr>     <chr>               <dttm>              <chr>        <chr>    <chr> 
## 1 108657222 1431663032787214342 2021-08-28 17:00:40 SpletnaMlad~ "Neprem~ Buffer
## 2 108657222 1432387852558548992 2021-08-30 17:00:51 SpletnaMlad~ "Borrel~ Buffer
## 3 108657222 1432614230587543557 2021-08-31 08:00:23 SpletnaMlad~ "Ameriš~ Buffer
## 4 108657222 1433127586314457091 2021-09-01 18:00:17 SpletnaMlad~ "Talibi~ Buffer
## # ... with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```



```r
tweets_afghanistan %>% 
  filter(str_detect(screen_name, "Dnevnik"))
```

```
## # A tibble: 5 x 90
##   user_id  status_id           created_at          screen_name text       source
##   <chr>    <chr>               <dttm>              <chr>       <chr>      <chr> 
## 1 36331941 1431904459613999107 2021-08-29 09:00:01 Dnevnik_si  "Med begu~ Tweet~
## 2 36331941 1432583936241291266 2021-08-31 06:00:01 Dnevnik_si  "Ameriška~ Tweet~
## 3 36331941 1432251743308435456 2021-08-30 08:00:00 Dnevnik_si  "Iraška v~ Tweet~
## 4 36331941 1431632667217334277 2021-08-28 15:00:00 Dnevnik_si  "Evropska~ Tweet~
## 5 36331941 1432614135808802816 2021-08-31 08:00:01 Dnevnik_si  "Poraz ZD~ Tweet~
## # ... with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```



```r
tweets_afghanistan %>% 
  filter((screen_name == "Delo"))
```

```
## # A tibble: 3 x 90
##   user_id   status_id           created_at          screen_name text      source
##   <chr>     <chr>               <dttm>              <chr>       <chr>     <chr> 
## 1 218560775 1430815592928399365 2021-08-26 08:53:15 Delo        "Odhajaj~ Twitt~
## 2 218560775 1430462998041219076 2021-08-25 09:32:10 Delo        "Nemčija~ Twitt~
## 3 218560775 1430965980440760323 2021-08-26 18:50:50 Delo        "Reševan~ Twitt~
## # ... with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```



```r
tweets_afghanistan %>% 
  filter(str_detect(screen_name, "Demokracija"))
```

```
## # A tibble: 6 x 90
##   user_id   status_id           created_at          screen_name  text     source
##   <chr>     <chr>               <dttm>              <chr>        <chr>    <chr> 
## 1 373900600 1433132118746574849 2021-09-01 18:18:18 Demokracija1 "S spre~ Twitt~
## 2 373900600 1433108064517992457 2021-09-01 16:42:43 Demokracija1 "(KOMEN~ Twitt~
## 3 373900600 1433031789346496512 2021-09-01 11:39:37 Demokracija1 "V javn~ Twitt~
## 4 373900600 1431597625988485120 2021-08-28 12:40:46 Demokracija1 "Noro! ~ Twitt~
## 5 373900600 1430819770727862274 2021-08-26 09:09:51 Demokracija1 "Litij ~ Twitt~
## 6 373900600 1433032283250909185 2021-09-01 11:41:35 Demokracija1 "Zmagal~ Twitt~
## # ... with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>, ...
```

## Timeplot


```r
## plot time series of tweets
p1 <- ts_plot(tweets_afghanistan, "3 hours", color = "red") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #Afghanistan Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

library(plotly)
ggplotly(p1)
```

```{=html}
<div id="htmlwidget-d292c7a1792d3ab88d74" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-d292c7a1792d3ab88d74">{"x":{"data":[{"x":[1629838800,1629849600,1629860400,1629871200,1629882000,1629892800,1629903600,1629914400,1629925200,1629936000,1629946800,1629957600,1629968400,1629979200,1629990000,1630000800,1630011600,1630022400,1630033200,1630044000,1630054800,1630065600,1630076400,1630087200,1630098000,1630108800,1630119600,1630130400,1630141200,1630152000,1630162800,1630173600,1630184400,1630195200,1630206000,1630216800,1630227600,1630238400,1630249200,1630260000,1630270800,1630281600,1630292400,1630303200,1630314000,1630324800,1630335600,1630346400,1630357200,1630368000,1630378800,1630389600,1630400400,1630411200,1630422000,1630432800,1630443600,1630454400,1630465200,1630476000,1630486800,1630497600,1630508400,1630519200],"y":[5,2,8,8,12,4,4,7,3,1,6,7,7,5,7,10,2,1,4,11,7,5,7,6,1,0,1,5,9,5,6,3,1,0,1,304,951,865,838,1298,327,93,309,736,795,844,694,743,458,155,464,979,941,753,865,875,384,97,387,787,680,579,6071,12554],"text":["time: 2021-08-24 21:00:00<br />n:     5","time: 2021-08-25 00:00:00<br />n:     2","time: 2021-08-25 03:00:00<br />n:     8","time: 2021-08-25 06:00:00<br />n:     8","time: 2021-08-25 09:00:00<br />n:    12","time: 2021-08-25 12:00:00<br />n:     4","time: 2021-08-25 15:00:00<br />n:     4","time: 2021-08-25 18:00:00<br />n:     7","time: 2021-08-25 21:00:00<br />n:     3","time: 2021-08-26 00:00:00<br />n:     1","time: 2021-08-26 03:00:00<br />n:     6","time: 2021-08-26 06:00:00<br />n:     7","time: 2021-08-26 09:00:00<br />n:     7","time: 2021-08-26 12:00:00<br />n:     5","time: 2021-08-26 15:00:00<br />n:     7","time: 2021-08-26 18:00:00<br />n:    10","time: 2021-08-26 21:00:00<br />n:     2","time: 2021-08-27 00:00:00<br />n:     1","time: 2021-08-27 03:00:00<br />n:     4","time: 2021-08-27 06:00:00<br />n:    11","time: 2021-08-27 09:00:00<br />n:     7","time: 2021-08-27 12:00:00<br />n:     5","time: 2021-08-27 15:00:00<br />n:     7","time: 2021-08-27 18:00:00<br />n:     6","time: 2021-08-27 21:00:00<br />n:     1","time: 2021-08-28 00:00:00<br />n:     0","time: 2021-08-28 03:00:00<br />n:     1","time: 2021-08-28 06:00:00<br />n:     5","time: 2021-08-28 09:00:00<br />n:     9","time: 2021-08-28 12:00:00<br />n:     5","time: 2021-08-28 15:00:00<br />n:     6","time: 2021-08-28 18:00:00<br />n:     3","time: 2021-08-28 21:00:00<br />n:     1","time: 2021-08-29 00:00:00<br />n:     0","time: 2021-08-29 03:00:00<br />n:     1","time: 2021-08-29 06:00:00<br />n:   304","time: 2021-08-29 09:00:00<br />n:   951","time: 2021-08-29 12:00:00<br />n:   865","time: 2021-08-29 15:00:00<br />n:   838","time: 2021-08-29 18:00:00<br />n:  1298","time: 2021-08-29 21:00:00<br />n:   327","time: 2021-08-30 00:00:00<br />n:    93","time: 2021-08-30 03:00:00<br />n:   309","time: 2021-08-30 06:00:00<br />n:   736","time: 2021-08-30 09:00:00<br />n:   795","time: 2021-08-30 12:00:00<br />n:   844","time: 2021-08-30 15:00:00<br />n:   694","time: 2021-08-30 18:00:00<br />n:   743","time: 2021-08-30 21:00:00<br />n:   458","time: 2021-08-31 00:00:00<br />n:   155","time: 2021-08-31 03:00:00<br />n:   464","time: 2021-08-31 06:00:00<br />n:   979","time: 2021-08-31 09:00:00<br />n:   941","time: 2021-08-31 12:00:00<br />n:   753","time: 2021-08-31 15:00:00<br />n:   865","time: 2021-08-31 18:00:00<br />n:   875","time: 2021-08-31 21:00:00<br />n:   384","time: 2021-09-01 00:00:00<br />n:    97","time: 2021-09-01 03:00:00<br />n:   387","time: 2021-09-01 06:00:00<br />n:   787","time: 2021-09-01 09:00:00<br />n:   680","time: 2021-09-01 12:00:00<br />n:   579","time: 2021-09-01 15:00:00<br />n:  6071","time: 2021-09-01 18:00:00<br />n: 12554"],"type":"scatter","mode":"lines","line":{"width":1.88976377952756,"color":"rgba(255,0,0,1)","dash":"solid"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":25.5707762557078,"l":40.1826484018265},"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"<b> Frequency of #Afghanistan Twitter statuses from past 9 days <\/b>","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[1629804780,1630553220],"tickmode":"array","ticktext":["avg. 26","avg. 28","avg. 30","sep. 01"],"tickvals":[1629936000,1630108800,1630281600,1630454400],"categoryorder":"array","categoryarray":["avg. 26","avg. 28","avg. 30","sep. 01"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-627.7,13181.7],"tickmode":"array","ticktext":["0","4000","8000","12000"],"tickvals":[0,4000,8000,12000],"categoryorder":"array","categoryarray":["0","4000","8000","12000"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"496832ef5b00":{"x":{},"y":{},"type":"scatter"}},"cur_data":"496832ef5b00","visdat":{"496832ef5b00":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```



```r
## plot time series of tweets
p2 <- ts_plot(tweets_afghanistan_de, "3 hours", 
              color = "darkgreen") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #rollingstones Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

library(plotly)
ggplotly(p2)
```

```{=html}
<div id="htmlwidget-5fa1f760606d85ffd21c" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-5fa1f760606d85ffd21c">{"x":{"data":[{"x":[1629838800,1629849600,1629860400,1629871200,1629882000,1629892800,1629903600,1629914400,1629925200,1629936000,1629946800,1629957600,1629968400,1629979200,1629990000,1630000800,1630011600,1630022400,1630033200,1630044000,1630054800,1630065600,1630076400,1630087200,1630098000,1630108800,1630119600,1630130400,1630141200,1630152000,1630162800,1630173600,1630184400,1630195200,1630206000,1630216800,1630227600,1630238400,1630249200,1630260000,1630270800,1630281600,1630292400,1630303200,1630314000,1630324800,1630335600,1630346400,1630357200,1630368000,1630378800,1630389600,1630400400,1630411200,1630422000,1630432800,1630443600,1630454400,1630465200,1630476000,1630486800,1630497600,1630508400,1630519200],"y":[5,2,8,8,12,4,4,7,3,1,6,7,7,5,7,10,2,1,4,11,7,5,7,6,1,0,1,5,9,5,6,3,1,0,1,304,951,865,838,1298,327,93,309,736,795,844,694,743,458,155,464,979,941,753,865,875,384,97,387,787,680,579,6071,12554],"text":["time: 2021-08-24 21:00:00<br />n:     5","time: 2021-08-25 00:00:00<br />n:     2","time: 2021-08-25 03:00:00<br />n:     8","time: 2021-08-25 06:00:00<br />n:     8","time: 2021-08-25 09:00:00<br />n:    12","time: 2021-08-25 12:00:00<br />n:     4","time: 2021-08-25 15:00:00<br />n:     4","time: 2021-08-25 18:00:00<br />n:     7","time: 2021-08-25 21:00:00<br />n:     3","time: 2021-08-26 00:00:00<br />n:     1","time: 2021-08-26 03:00:00<br />n:     6","time: 2021-08-26 06:00:00<br />n:     7","time: 2021-08-26 09:00:00<br />n:     7","time: 2021-08-26 12:00:00<br />n:     5","time: 2021-08-26 15:00:00<br />n:     7","time: 2021-08-26 18:00:00<br />n:    10","time: 2021-08-26 21:00:00<br />n:     2","time: 2021-08-27 00:00:00<br />n:     1","time: 2021-08-27 03:00:00<br />n:     4","time: 2021-08-27 06:00:00<br />n:    11","time: 2021-08-27 09:00:00<br />n:     7","time: 2021-08-27 12:00:00<br />n:     5","time: 2021-08-27 15:00:00<br />n:     7","time: 2021-08-27 18:00:00<br />n:     6","time: 2021-08-27 21:00:00<br />n:     1","time: 2021-08-28 00:00:00<br />n:     0","time: 2021-08-28 03:00:00<br />n:     1","time: 2021-08-28 06:00:00<br />n:     5","time: 2021-08-28 09:00:00<br />n:     9","time: 2021-08-28 12:00:00<br />n:     5","time: 2021-08-28 15:00:00<br />n:     6","time: 2021-08-28 18:00:00<br />n:     3","time: 2021-08-28 21:00:00<br />n:     1","time: 2021-08-29 00:00:00<br />n:     0","time: 2021-08-29 03:00:00<br />n:     1","time: 2021-08-29 06:00:00<br />n:   304","time: 2021-08-29 09:00:00<br />n:   951","time: 2021-08-29 12:00:00<br />n:   865","time: 2021-08-29 15:00:00<br />n:   838","time: 2021-08-29 18:00:00<br />n:  1298","time: 2021-08-29 21:00:00<br />n:   327","time: 2021-08-30 00:00:00<br />n:    93","time: 2021-08-30 03:00:00<br />n:   309","time: 2021-08-30 06:00:00<br />n:   736","time: 2021-08-30 09:00:00<br />n:   795","time: 2021-08-30 12:00:00<br />n:   844","time: 2021-08-30 15:00:00<br />n:   694","time: 2021-08-30 18:00:00<br />n:   743","time: 2021-08-30 21:00:00<br />n:   458","time: 2021-08-31 00:00:00<br />n:   155","time: 2021-08-31 03:00:00<br />n:   464","time: 2021-08-31 06:00:00<br />n:   979","time: 2021-08-31 09:00:00<br />n:   941","time: 2021-08-31 12:00:00<br />n:   753","time: 2021-08-31 15:00:00<br />n:   865","time: 2021-08-31 18:00:00<br />n:   875","time: 2021-08-31 21:00:00<br />n:   384","time: 2021-09-01 00:00:00<br />n:    97","time: 2021-09-01 03:00:00<br />n:   387","time: 2021-09-01 06:00:00<br />n:   787","time: 2021-09-01 09:00:00<br />n:   680","time: 2021-09-01 12:00:00<br />n:   579","time: 2021-09-01 15:00:00<br />n:  6071","time: 2021-09-01 18:00:00<br />n: 12554"],"type":"scatter","mode":"lines","line":{"width":1.88976377952756,"color":"rgba(0,100,0,1)","dash":"solid"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":25.5707762557078,"l":40.1826484018265},"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"<b> Frequency of #rollingstones Twitter statuses from past 9 days <\/b>","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[1629804780,1630553220],"tickmode":"array","ticktext":["avg. 26","avg. 28","avg. 30","sep. 01"],"tickvals":[1629936000,1630108800,1630281600,1630454400],"categoryorder":"array","categoryarray":["avg. 26","avg. 28","avg. 30","sep. 01"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-627.7,13181.7],"tickmode":"array","ticktext":["0","4000","8000","12000"],"tickvals":[0,4000,8000,12000],"categoryorder":"array","categoryarray":["0","4000","8000","12000"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"49682ba3437f":{"x":{},"y":{},"type":"scatter"}},"cur_data":"49682ba3437f","visdat":{"49682ba3437f":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```



```r
## plot time series of tweets
p3 <- ts_plot(tweets_afghanistan_sl, "3 hours", 
              color = "darkgreen") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #rollingstones Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

library(plotly)
ggplotly(p3)
```

```{=html}
<div id="htmlwidget-0ceaea34ba9d87788f5f" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-0ceaea34ba9d87788f5f">{"x":{"data":[{"x":[1629838800,1629849600,1629860400,1629871200,1629882000,1629892800,1629903600,1629914400,1629925200,1629936000,1629946800,1629957600,1629968400,1629979200,1629990000,1630000800,1630011600,1630022400,1630033200,1630044000,1630054800,1630065600,1630076400,1630087200,1630098000,1630108800,1630119600,1630130400,1630141200,1630152000,1630162800,1630173600,1630184400,1630195200,1630206000,1630216800,1630227600,1630238400,1630249200,1630260000,1630270800,1630281600,1630292400,1630303200,1630314000,1630324800,1630335600,1630346400,1630357200,1630368000,1630378800,1630389600,1630400400,1630411200,1630422000,1630432800,1630443600,1630454400,1630465200,1630476000,1630486800,1630497600,1630508400,1630519200],"y":[5,2,8,8,12,4,4,7,3,1,6,7,7,5,7,10,2,1,4,11,7,5,7,6,1,0,1,5,9,5,6,3,1,0,1,304,951,865,838,1298,327,93,309,736,795,844,694,743,458,155,464,979,941,753,865,875,384,97,387,787,680,579,6071,12554],"text":["time: 2021-08-24 21:00:00<br />n:     5","time: 2021-08-25 00:00:00<br />n:     2","time: 2021-08-25 03:00:00<br />n:     8","time: 2021-08-25 06:00:00<br />n:     8","time: 2021-08-25 09:00:00<br />n:    12","time: 2021-08-25 12:00:00<br />n:     4","time: 2021-08-25 15:00:00<br />n:     4","time: 2021-08-25 18:00:00<br />n:     7","time: 2021-08-25 21:00:00<br />n:     3","time: 2021-08-26 00:00:00<br />n:     1","time: 2021-08-26 03:00:00<br />n:     6","time: 2021-08-26 06:00:00<br />n:     7","time: 2021-08-26 09:00:00<br />n:     7","time: 2021-08-26 12:00:00<br />n:     5","time: 2021-08-26 15:00:00<br />n:     7","time: 2021-08-26 18:00:00<br />n:    10","time: 2021-08-26 21:00:00<br />n:     2","time: 2021-08-27 00:00:00<br />n:     1","time: 2021-08-27 03:00:00<br />n:     4","time: 2021-08-27 06:00:00<br />n:    11","time: 2021-08-27 09:00:00<br />n:     7","time: 2021-08-27 12:00:00<br />n:     5","time: 2021-08-27 15:00:00<br />n:     7","time: 2021-08-27 18:00:00<br />n:     6","time: 2021-08-27 21:00:00<br />n:     1","time: 2021-08-28 00:00:00<br />n:     0","time: 2021-08-28 03:00:00<br />n:     1","time: 2021-08-28 06:00:00<br />n:     5","time: 2021-08-28 09:00:00<br />n:     9","time: 2021-08-28 12:00:00<br />n:     5","time: 2021-08-28 15:00:00<br />n:     6","time: 2021-08-28 18:00:00<br />n:     3","time: 2021-08-28 21:00:00<br />n:     1","time: 2021-08-29 00:00:00<br />n:     0","time: 2021-08-29 03:00:00<br />n:     1","time: 2021-08-29 06:00:00<br />n:   304","time: 2021-08-29 09:00:00<br />n:   951","time: 2021-08-29 12:00:00<br />n:   865","time: 2021-08-29 15:00:00<br />n:   838","time: 2021-08-29 18:00:00<br />n:  1298","time: 2021-08-29 21:00:00<br />n:   327","time: 2021-08-30 00:00:00<br />n:    93","time: 2021-08-30 03:00:00<br />n:   309","time: 2021-08-30 06:00:00<br />n:   736","time: 2021-08-30 09:00:00<br />n:   795","time: 2021-08-30 12:00:00<br />n:   844","time: 2021-08-30 15:00:00<br />n:   694","time: 2021-08-30 18:00:00<br />n:   743","time: 2021-08-30 21:00:00<br />n:   458","time: 2021-08-31 00:00:00<br />n:   155","time: 2021-08-31 03:00:00<br />n:   464","time: 2021-08-31 06:00:00<br />n:   979","time: 2021-08-31 09:00:00<br />n:   941","time: 2021-08-31 12:00:00<br />n:   753","time: 2021-08-31 15:00:00<br />n:   865","time: 2021-08-31 18:00:00<br />n:   875","time: 2021-08-31 21:00:00<br />n:   384","time: 2021-09-01 00:00:00<br />n:    97","time: 2021-09-01 03:00:00<br />n:   387","time: 2021-09-01 06:00:00<br />n:   787","time: 2021-09-01 09:00:00<br />n:   680","time: 2021-09-01 12:00:00<br />n:   579","time: 2021-09-01 15:00:00<br />n:  6071","time: 2021-09-01 18:00:00<br />n: 12554"],"type":"scatter","mode":"lines","line":{"width":1.88976377952756,"color":"rgba(0,100,0,1)","dash":"solid"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":25.5707762557078,"l":40.1826484018265},"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"<b> Frequency of #rollingstones Twitter statuses from past 9 days <\/b>","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[1629804780,1630553220],"tickmode":"array","ticktext":["avg. 26","avg. 28","avg. 30","sep. 01"],"tickvals":[1629936000,1630108800,1630281600,1630454400],"categoryorder":"array","categoryarray":["avg. 26","avg. 28","avg. 30","sep. 01"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-627.7,13181.7],"tickmode":"array","ticktext":["0","4000","8000","12000"],"tickvals":[0,4000,8000,12000],"categoryorder":"array","categoryarray":["0","4000","8000","12000"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.65296803652968,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"4968506f356c":{"x":{},"y":{},"type":"scatter"}},"cur_data":"4968506f356c","visdat":{"4968506f356c":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

