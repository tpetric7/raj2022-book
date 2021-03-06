# Installation

## Grundlegende Programme

Für die computergestützte Arbeit mit Sprachmaterial verwenden wir freie Softwaretools, d.h. die Programmiersprache `R`, die grafische Oberfläche `RStudio` für komfortableres Programmieren und `RTools` für die Installation von Entwicklungsversionen in einer `Windows`-Umgebung (letztere ist optional, aber für fortgeschrittene Benutzer empfohlen).

Die Programme `R` (4.1.2 oder höher), `RStudio` (2022.02.0+443 oder höher) und `RTools` (4.0.0 oder höher) können von den folgenden Webadressen heruntergeladen werden (wir führen nur die Installationspakete für die Operationssysteme `Windows` und `MacOS` an, für Linux bitte selber nachschlagen):

- für `Windows` https://cloud.r-project.org/bin/windows/base/, für `MacOS` https://cloud.r-project.org/bin/macosx/ 

- https://www.rstudio.com/products/rstudio/download/ (`Windows` oder `MacOS`)

- für fortgeschrittene Benutzer, die auf die Entwicklungsversionen der Programme auf `github` und einige andere Dienste zugreifen möchten https://cran.r-project.org/bin/windows/Rtools/.

Auf neueren Computern laufen meist 64-Bit-Betriebssysteme (`Windows`, `macOS`, `Linux`). Es ist daher ratsam, 64-Bit-Versionen der `R`-Programme (*package, library*) zu wählen. Auf einem 32-Bit-Betriebssystem (wenn Sie noch einen älteren Computer verwenden) benötigen Sie 32-Bit-Versionen der Software.


## Zusätzliche Programme

Nach der Installation von `R` und `RStudio` sind viele Funktionen bereits verfügbar. Zusätzliche Softwarefunktionen können über die `CRAN`-Server bezogen werden. Alle diese Angebote sind kostenlos. Wenn Sie Programmfunktionen oder Bibliotheken (`library`) hinzufügen wollen, installieren Sie diese zuerst von den `CRAN` Programmiersprachenservern. In der Programmierumgebung `RStudio` kann dies auf mehrere Arten erreicht werden:   

- Für Anfänger ist es am einfachsten, in `RStudio` auf die Registerkarte (Reiter) *Packages* ("Pakete") zu klicken, dann auf *Installieren*, und dann den Namen des gewünschten Programms oder Pakets in das neue Dialogfeld einzugeben. Beachten Sie, dass in der Programmiersprache `R` zwischen Groß- und Kleinschreibung unterschieden wird (im Gegensatz zu `Excel`).   

- Ein schnellerer Weg, neue Programmfunktionen zu installieren, ist die Eingabe des Befehls `install.packages("package-name")` in der `Console` (*Konsole*). Der Paketname muss in Anführungszeichen angegeben werden.   

Programmfunktionen, die nicht Teil des Basis-Softwarepakets (`Base R`) sind, müssen vom Benutzer in den Speicher des Computers geladen werden. Dies geschieht, indem man `library(Paketname)` (Anführungszeichen werden hier nicht benötigt) in das Programmskript oder in die Konsole einträgt. 

Im Programmskript speichert der Benutzer die Programmbefehle für seine Datenanalyse, insbesondere solche, die wiederverwendet und/oder automatisch ausgeführt werden sollen. Programmskripte kann der Benutzer entweder als `R`-Skript (Standard-Dateierweiterung: `R`) oder als `Rmarkdown`-Dokument (Standard-Dateierweiterung: `Rmd`) speichern.  

Man kann Programme bzw. Bibliotheken (`library`) ausführen, indem man sie lediglich in der Konsole eingibt, aber dies wird nicht im Programmskript gespeichert. 

Für die computergestützte Arbeit mit Sprachmaterial und die statistische Analyse werden wir in den folgenden Kapiteln die folgenden zusätzlichen Bibliotheken (Pakete, Programme, Sammlungen von Softwarefunktionen) verwenden (für weitere spezielle Analysen und Darstellungen aber noch eine ganze Reihe weiterer Programme):



Für Anfänger sind sicher auch Software-Add-ons interessant, die die Auswahl von Befehlen mit der Maus und mehrere vordefinierte Arbeitsabläufe ermöglichen, wie z. B. die folgenden *Add-ons* für statistische Analysen:   
- *RCommander*: `library(Rcmdr)`   
- *Rattle*: `library(Rattle)`.   

Solche Add-Ons erfordern nicht, dass man sich schon in den ersten Wochen oder Monaten die Namen von Bibliotheken oder Befehlen merken muss, die für die Analyse in der Programmiersprache `R` benötigt werden. `RCommander` druckt auch die Reihenfolge der Befehle für Sie aus, so dass es einfacher ist zu lernen, wie man ein Programmskript oder ein `Rmarkdown`-Dokument erstellt.


## Hilfe

In `RStudio` ist auch eine sorgfältig ausgearbeitete `Hilfe` eingebaut, die auf verschiedene Weise erreicht werden kann: 

- Wählen Sie die Registerkarte *Help* (Hilfe) und geben Sie in das Feld *Search* (Suchen) einen Suchbegriff ein (z.B. den Namen des Befehls oder der Funktion, über die Sie Einzelheiten erfahren möchten). Klicken Sie sich dann zur gewünschten Hilfeseite durch.   

- Wenn Sie bereits eine Bibliothek (Paket) in den Speicher Ihres Computers geladen haben, ist es aber meist bequemer, (a) die Maus über eine Programmfunktion im Skript zu halten, um einen Hinweis zu erhalten oder (b) mit der Maus den Befehlsnamen anzuklicken und die Funktionstaste `F1` (in `Windows`) für kontextsensitive Hilfe zu drücken. Auf diese Weise landen wir meist auf der entsprechenden Hilfeseite.


## Andere Werkzeuge

Zusätzlich zu Tabellenkalkulations- und Diagrammsoftware (z.B. `Microsoft Excel` oder kostenfreie Programmbündel wie `OpenOffice` oder `LibreOffice`) kann ein freies statistisches Analyseprogramm nützlich sein, insbesonderer wenn man noch nicht in der Lage ist, ein analytisches Verfahren in der Programmiersprache `R` durchzuführen: z.B.

- `Jamovi` (https://www.jamovi.org/download.html), das unter der Haube mit der Programmiersprache `R` arbeitet und ansprechende statistische Berichte und tabellarische oder graphische Darstellungen erstellen kann;

- `Jasp` (https://jasp-stats.org/download/), das wie `Jamovi` mehrere Assistenten für die Erstellung von statistischen Berichten und Darstellungen bietet, aber in Bezug auf die durchführbaren Programmierfunktionen hinter dem ersten zurückbleibt.

Für eine schnelle und unkomplizierte Analyse eines Textes (oder einer kleinen Anzahl von Texten) ist das webbasierte Tool `Voyant Tools` (https://voyant-tools.org/) sehr praktisch. Laden Sie den Text von Ihrem Computer (oder kopieren Sie ihn in ein Dialogfeld), klicken Sie auf `Anzeigen` und nach einigen Sekunden erzeugt das Programm eine ganze Reihe von Diagrammen und Tabellen zu den Eigenschaften der Wortformen im Text. 

Wenn Sie mit einer großen Anzahl von Texten zu tun haben, die sogar separat analysiert werden sollen, wird es unbequem, mit diesem Werkzeug zu arbeiten, und es ist einfacher, in der `RStudio`-Umgebung mit der Programmiersprache `R` zu arbeiten (oder mit anderen Programmiersprachen, z.B. mit dem ebenfalls beliebten `Python`). Ein weiterer Vorteil der Programmiersprache `R` und `Rmarkdown`-Dokumenten ist die Möglichkeit, einen Bericht, Artikel, Blog oder ein Buch zu erstellen, in dem sowohl der Datensatz, das komplette Analyseverfahren, die Ergebnisse der Analyse in tabellarischer und graphischer Form als auch der begleitende Text enthalten ist. Ein Beispiel dafür ist dieses Buch, das Sie im Augenblick verwenden. 


## Cloud-Dienste

Für fortgeschrittene Benutzer ist das Portal `github` (https://github.com/) vorläufig noch kostenlos (obwohl es von `Microsoft` aufgekauft wurde). Es ermöglicht die Speicherung von Analyseverfahren, Softwarebibliotheken, die Veröffentlichung von Arbeitsmaterial und die Zusammenarbeit zwischen Programmierern und Benutzern. Das Buch, das Sie gerade lesen, hat auch ein Zuhause auf `github`.

Es ist erwähnenswert, dass die Programmiersprache `R` und die Programmierumgebung `RStudio` auch in **Cloud-Diensten** verwendet werden können, ohne dass `R` und `RStudio` auf dem eigenen Computer installiert werden müssen, z. B. 

- *RStudio cloud*: https://rstudio.cloud/

- *Google Collaboratory* (https://colab.research.google.com)

- *Kaggle* (https://www.kaggle.com/).

Für diese Dienste müssen Sie ein Konto anlegen und sich beim entsprechenden Webportal anmelden. Die Nutzung dieser Dienste ist kostenlos.

Der Vorteil ist, dass Ihre Analyse auf einem leistungsstarken Cloud-Server ausgeführt wird, womit potenzielle Softwarekonflikte und unerwünschte Änderungen am Betriebssystem sowie Belastungen für Ihren eigenen Computer vermieden werden. 

Der Nachteil der kostenlosen Nutzung von `RStudio.cloud` ist, dass der kostenfreie Speicherplatz bei großen Textsammlungen schnell erschöpft ist, so dass man nicht weiterarbeiten kann und die bereits erzielten Ergebnisse verloren gehen. `Google Colab` ist in erster Linie für Programmierer gedacht, die in der Programmiersprache `Python` arbeiten. Wenn Sie mit der Programmiersprache `R` arbeiten, sollten Sie damit rechnen, dass bestimmte Programmierfunktionen nicht zur Verfügung stehen (z.B. die `readtext`-Bibliothek zum unkomplizierten Öffnen einer Textsammlung).

## Repositorien und YouTube

Auf YouTube gibt es zahlreiche Kanäle, wo man `R` und statistische Methoden lernen kann. Außerdem haben die meisten Informatiker auf [Github](https://github.com/) ihre Repositorien mit gespeicherten Programmskripts, Blogs und Büchern, die man als  Lernmaterialien verwenden kann, z.B.:   

- [David Robinson](https://github.com/dgrtwo);   
- [Julia Silbe](https://github.com/juliasilge);   
- [Andrew Couch](https://github.com/andrew-couch/Tidy-Tuesday);   
- [Wolf Riepl](https://github.com/fjodor);   
- [StatQuest](https://www.youtube.com/results?search_query=statquest);   
- [Statistik am PC](https://www.youtube.com/c/StatistikamPC_BjoernWalther);   
- [Kurzes Tutorium Statistik](https://www.youtube.com/channel/UCtBEklAtHHji2V1TsaTzZXw)   
und viele, viele andere.   

Falls man irgend *steckenbleibt*, findet man Programlösungen auch auf den Portalen [stackoverflow](https://stackoverflow.com/) oder [crossvalidated](https://stats.stackexchange.com/) und an vielen anderen Stellen im Internet - in den meisten Fällen auf Englisch.   
