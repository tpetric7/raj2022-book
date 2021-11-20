# Namestitev

## Osnovni programi

Za računalniško podprto delo z jezikovnim gradivom uporabljamo brezplačna programska orodja, tj. programski jezik `R`. za udobnejše programiranje grafični vmesnik `RStudio` in za nameščanje razvojnih programskih različic v okenskem okolju tudi `RTools` (slednji ni obvezen, vendar priporočljiv za naprednejše uporabnike).

Programe `R` (4.1.1 ali novejšo), `RStudio` (2021.09.0 ali novejšo) in RTools (4.0.0 ali novejšo) prenesemo z naslednjih spletnih naslovov:

- za Windows https://cloud.r-project.org/bin/windows/base/, za MacOS https://cloud.r-project.org/bin/macosx/

- https://www.rstudio.com/products/rstudio/download/ (Windows ali MacOS)

- za naprednejše uporabnike, ki želijo dostopati do razvojnih različicah programov na portalu `github` in nekaterih drugih storitvah https://cran.r-project.org/bin/windows/Rtools/.

Na novejših računalnikih tečejo večinoma 64-bitni operacijski sistemi (Windows, macOS, Linux). Zato je priporočljivo izbrati 64-bitne različice programov. Na 32-bitnem operacijskem sistemu (če še uporabljate starejši računalnik) potrebujete 32-bitne programske različice.


## Dodatni programi

Po namestitvi programov `R` in `RStudio` je mnogo funkcij že na voljo. Na strežnikih CRAN je mogoče dobiti dodatne programske funkcije. Vse so brezplačne. Vedno ko želimo dodati programske funkcije ali knjižnice (`library`), jih najprej namestimo s strežnikov za programski jezik `CRAN`. V programskem okolju `RStudio` to lahko dosežemo na več načinov:

- Začetnikom se bo zdelo najlažje v RStudiu klikniti zavihek `Packages`, potem `Install` in v novem pogovornem oknu vpisati ime zaželenega programa ali paketa (`package`). Pozor, programski jezik `R` razlikuje velike in male črke (v nasprotju s programom `Excel`).

- Hitreje namestitev novih programskih funkcij opravimo z vpisom ukaza `install.packages("ime-zazelenega-paketa")` v konzolo (`console`). Ime paketa mora podati v navednicah.

Programske funkcije, ki niso sestavni del osnovega programskega paketa (`base R`), je treba naložiti v pomnilnik računalnika. To storimo z vpisom `library(ime-paketa)` (navednice tu niso potrebne) v dokument, v katerem shranjujemo zaporedje ukazov za analizo, tj. v programski skript (privzeta pripona datoteke: `R`) ali `Rmarkdown` dokument (privzeta pripona datoteke: `Rmd`). 

Možno je tudi zagnati knjižnico (`library`) z vpisom v konzolo, vendar se vpis tega ukaza ne shranjuje v dokumentu.

Med pomembnejšimi dodatnimi knjižnicami (paketi, programi, zbirkami programskih funkcij) za računalniško podprto delo z jezikovnim gradivom in statistično analizo bomo uporabljali:



Začetnikom bodo nemara privlačni programski dodatki, ki omogočajo izbiranje ukazov z miško in več že vnaprej pripravljenih delovnih postopkov. Taki dodatki za statistično analizo so npr.

- RCommander: `library(Rcmdr)`

- Rattle: `library(rattle)`.

Taki dodatki ne zahtevajo, da bi si morali že kar v prvih tednih ali mesecih dela morali zapomniti imena knjižnic ali ukazov, ki jih potrebujemo za analizo v programskem jeziku `R`. `RCommander` vam zaporedje ukazov tudi izpiše, tako da se lažje naučite sestaviti programski skript ali `rmarkdown` dokument.


## Pomoč

`RStudio` ima tudi vgrajeno skrbno dodelano pomoč (`Help`), ki jo dosežemo na več načinov:

- Izberemo zavihek `Help` in v okence "Search" vpišemo poizvedbeni niz (npr. ime ukaza ali funkcije, o kateri želimo izvedeti podrobnosti). Potem se preklikamo do zaželene strani pomoči.

- Druga možnost pa je večinoma priročnejša, če smo neko knjižnico (paket) že naložili v pomnilnik računalnika, tj. z miško pomaknemo kazalec na ime ukaza in pritisnemo funkcijsko tipko `F1` za pomoč (Windows). Na ta način priletimo večinoma na relevantno stran.


## Druga orodja

Poleg programa za preglednice in grafikone (npr. `Microsoft Excel` ali brezplačne različice kot `OpenOffice` ali `LibreOffice`) nam lahko pride prav brezplačen program za statistično analizo, če nekega analitičnega postopka v programskem jeziku `R` še ne znamo izpeljati: npr.

- `jamovi` (https://www.jamovi.org/download.html), ki `pod pokrovom` dela s programskim jezikom `R` in zna pripraviti lepa statistična poročila in prikaze;

- `Jasp` (https://jasp-stats.org/download/), ki ima podobno kot `jamovi` več čarovnikov za pripravo statističnih poročil in prikazov, vendar glede programskih funkcij zaostaja za prvo imenovanim programom.

Za hitro in nekomplicirano analizo besedila (ali manjšega števila besedil) je zelo priročno spletno orodje `Voyant Tools` (https://voyant-tools.org/). Z računalnika naložite besedilo (ali s kopiranjem v pogovorno okno), kliknete "Anzeigen" (Show) in že po nekaj sekundah vam program pripravi celo paleto diagramov in preglednic o lastnostih besednih oblik v besedilu. 

V primeru večjega števila besedil, ki jih je treba ločeno analizirati, postane delo s tem orodjem neudobno, in je lažje delati v okolju `RStudio` s programskim jezikom `R` (ali z drugimi programskimi jeziki, npr. priljubljen je tudi `Python`). Druga prednost programskega jezika `R` in `Rmarkdown` je tudi možnost izdelave poročila, članka, bloga ali knjige, ki vsebuje celoten postopek, rezultate analize in spremno besedilo.


## Oblačne storitve

Za naprednejše uporabnike velja omeniti portal `github` (https://github.com/), ki je za zdaj še vedno brezplačen (čeprav ga je kupil `Microsoft`). Omogoča hrambo analiznih postopkov, programskih knjižnic, objavo delovnega gradiva in sodelovanje med programerji in uporabniki. Tudi knjiga, ki jo berete, ima svoj dom na portalu `github`.

Omeniti velja, da lahko programski jezik R in RStudio uporabljamo tudi v **oblačnih storitvah**, ne da bi bilo potrebno namestiti `R` in `RStudio`, npr. 

- *RStudio cloud*: https://rstudio.cloud/

- *Google Colaboratory* (https://colab.research.google.com)

- *Kaggle* (https://www.kaggle.com/).

Te storitve zahtevajo, da ustvarite račun in se za vsakokratno delo prijavte v spletni portal. Te storitve lahko uporabljate brezplačno.

Prednost je, da se vaša analiza izvaja na zmogljivem strežniku v oblaku, izognete se morebitnim programskim sporom in nezaželenim spremembam operacijskega sistema in obremenitvam lastnega računalnika. 

Slabost brezplačne uporabe storitve `RStudio.cloud` je, da vam v primeru večje besedilne zbirke dokaj hitro zmanjka pomnilnika, tako da ne morete več delati naprej in izgubite že pridobljene rezultate. `Google Colab` je namenjen predvsem programerjem, ki delajo v programskem jeziku `Python`. Če delate v programskem jeziku `R`, morate računati s tem, da določenih programskih funkcij ne bo (npr. knjižnice `readtext` za lahkotno branje besedilne zbirke).
