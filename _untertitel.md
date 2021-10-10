# Untertitel

## Programme starten



## Daten laden

Die englischen und deutschen Untertitel zum Film *Avatar* stammen aus der Datensammlung von *Natalia Levshina* [@levshina2015linguistics], die slowenischen Untertitel stammen von der Webseite [nachschauen](https://...).

Zuerst laden wir sechs Dateien mit Untertiteln zum Film *Avatar*. Hauptsächlich werden wir mit den Untertiteln in englischer, deutscher und slowenischer Sprache arbeiten.





## Datensätze vorbereiten

### Textspalte vorbereiten

Untertitel haben ein besonderes Format. Recht einfach sind Datenmodifizierungen mit den tidyverse-Funktionen. Die Voraussetzung für ihre Verwendung ist die Umwandlung der Texte ins Tabellenformat. Dann können wir z.B. auch neue Tabellenspalten mit den Zeitangaben bilden.



Da die Anfangs- und Endzeit der Untertitel in den drei Sprachen nicht übereinstimmt, wollen wir lediglich die Untertiteltexte beibehalten.







### Datensätze verknüpfen

Nun verknüpfen wir die drei Datensätze zu einem einzigen.



### Merkmale hinzufügen

Mit Hilfe von *quanteda*-Funktionen fügen wir dem Datensatz noch weitere Kenngrößen hinzu, und zwar die Anzahl der Wortformerscheinungen oder Tokens pro Äußerung (sentlen), die Anzahl der Silben pro Äußerung (syllables), die Wortlänge (wordlen), die Anzahl der verschiedenen Wortformen (Types) und das Type-Token-Verhältnis als bekanntes Maß für lexikalische Diversität.



Speichern für spätere Verwendung.





### Konkordanzrecherche

Ein Beispiel einer Konkordanzrecherche mit Hilfe von *kwic* - dem Konkordanz-Tool in *quanteda*:



### Textzerlegung

Zerlegung der Untertitellinien in Wörter:



### Zerlegung und Annotation

Zuerst müssen wir für jede Sprache ein **udpipe**-Sprachmodell laden, um für jede der drei Untertitelversionen eine morphosyntaktische Annotation vorzunehmen.

Englisch:





Deutsch:





Slowenisch:





Französisch:





Italienisch:





Türkisch:





Anpassung der Tabellenspalte "token_id" als *numeric()*.




Die Datensätze wollen wir für anderweitige Verwendungen speichern, und zwar sowohl im *conllu*-Format als auch im *csv*-Format. In beiden Fällen erhalten wir Textdateien.







Den drei annotierten Datensätzen wollen wir noch einige weitere Merkmale hinzufügen (und zwar mit den *mutate()*-Befehlen, in denen auch einfache *quanteda*-Funktionen verwendet werden). Außerdem soll die komplexe Tabellenspalte *feats* (features) in einzelne Spalten aufgeteilt werden (und zwar mit der *cbind_morphological()*-Funktion von *udpipe*).

Da wir dies mit allen drei Datensätzen anstellen wollen, bilden wir eine Funktion dazu, die als Input eine Tabelle (tbl) verlangt, in denen die Spalten "word, token, feats, sentence" zur Verfügung stehen:



Die für die Verwendung der Funktion entsprechenden Tabellen sind die zuvor gebildeten Tabellen "udeng", "uddeu" und "udslv". Nach der Anreicherung der Datensätze verknüpfen wir sie zu einem einzigen.



Für spätere Verwendungen speichern wir den Datensatz in zwei verschiedenen Formaten.





## Morphologie der Untertitel

Um einzelne Wörter und ihre Funktionen im Text aufzuspüren, brauchen wir nur die *filter()*- und die *select()*-Funktion einzugeben. Beispielsweise das Lemma "brother" in den englischen Untertiteln:



Dasselbe mit dem deutschen "Bruder" und dem slowenischen "brat":





Das Lemma "brother" bzw. scheint in den englischen Untertiteln ein wenig häufiger vorzukommen als die deutsche bzw. slowenische Entsprechung "Bruder" bzw. "brat".

### XRay Brother

An welchen Stellen kommt das Wort in den Untertiteln vor?



Um die Stellen aus drei Texten besser vergleichen zu können, müssen wir drei *xray*-Diagramme erstellen und sie mit Hilfe von *patchwork* zusammenkleben.



### Substantive im Plural

Als nächstes wollen wir alle als Substantive (Noun) identifizierte Einheiten herausfinden, die im Plural auftreten.









### Adjektive im Komparativ

In unserer nächsten Recherche wollen wir Komparativformen von Adjektiven ausfindig machen und ihre Stelle im Untertitel.

Zuerst zählen wir die Wortarten (upos). Hier fällt auf, dass der Anteil einiger Wortarten in den slowenischen Untertiteln größer ist als in den anderen beiden Sprachen (z.B. Verben, Substantive), in anderen Fällen jedoch kleiner (z.B. Pronomen, die ja im Slowenischen nicht obligatorisch auftreten müssen).



In den englischen Untertiteln wurden 17 Komparativformen identifiziert, in den deutschen 20 und in den slownischen 4. Der Anteil der Komparativformen ist also in den englischen und deutschen Untertiteln größer als in den slowenischen.

Ähnlich verhält es sich mit den Superlativformen: deutsch (35 = 6%), englisch (14 = 2,77%), slowenisch (6 = 1,65)



Anmerkung: Die Klassifzierung für die deutsche Sprache (Variante: "german-gsd") enthält diese Kategorie nicht. Wir haben daher die "german-hdt"-Variante gewählt.

## Syntax: Dependenz

Programme wie *udpipe* oder *spacyr* sind auch in der Lage, syntaktische Dependenzrelationen gemäß der Stanforder sprachübergreifenden Typologie zu identifizieren und als Annotation auszugeben. Typologische Grundlage für die Annotation: [Universal Stanford Dependencies: A cross-linguistic typology (de Marneffe et al. 2014)](https://universaldependencies.org/u/dep/index.html).



Mehr über das Datenformat: [CoNLL-U Format](https://universaldependencies.org/format.html)

Frequenzwerte der syntaktischen Abhängigkeitsrelationen in den Avatar-Untertiteln (englisch, deutsch, slowenisch):



Gemäß *udpipe* erscheinen in den englischen und deutschen Untertiteln die Dependenzrelationen *root, nsubj, advmod, det, obj* am häufigsten. In den slowenischen Untertiteln haben die Relationen *root, advmod, obj, case, nsubj* die größten Frequenzwerte.

Die Dependenzrelation *root* gibt uns Auskunft darüber, ob eine Wortfolge als Satz identifiziert wurde. Sie wird gewöhnlich mit Hilfe des (finiten) Verbs im Satz bestimmt. In elliptischen Sätzen wird eine der vorkommenden Wortformen mit *root* assoziiert.

In der Tabelle ist (unter *root*) zu sehen, dass in den englischen Untertiteln 2026 satzwertige Einheiten identifiziert wurden, in den deutschen 2366 und in den slowenischen 1807.

In der Tabelle zeigen die Prozentzahlen beispielsweise einen bemerkenswerten Unterschied in der Häufigkeit der Dependenzrelation *nsubj*, d.h. die Anzahl der identifizierten Subjekte. In den slowenischen Untertiteln liegt der Anteil deutlich unter dem in den englischen und deutschen. Das hängt damit zusammen, dass Slowenisch eine Pro-drop-Sprache ist, dass also unbetonte Personalpronomen (in Subjekt-Funktion) nicht sprachlich realisiert zu sein brauchen. Besonder deutlich wird dies, wenn wir einen Beispielsatz aus allen drei Texten visualisieren.

Mit Hilfe der folgenden Funktion können wir die Dependenzrelationen im Satz visualisieren. Wir geben der Funktion den Namen *plot_annotation()*.



Hier ist ein Beispiel eines Avatar-Untertitels in drei Sprachen. Wegen der deutschen bzw. slowenischen Sonderzeichen wandeln wir den Text mit Hilfe der Funktion *enc2utf8()* ins erforderliche UTF8-Format um.



Englischer Satz:

-   PRON: Personalpronomen mit Subjekt-Funktion (nsubj)

-   NOUN, VERB: Substantiv, Verb

-   AUX: das Hilfs- oder Auxiliarverb

-   xcomp: hier eine Relation zwischen zwei Verben, die gemeinsam das Prädikat des Satzes bilden

-   DET: Determiner (Determinans), Begleiter eines Substantivs (meist handelt es sich um einen Artikel)

-   obj: Objektfunktion (hier ist "these dreams" das Objekt des Verbs "have")

-   SCONJ: subordinierende Konjunktion (aber hier wäre "prep" für Präposition angebracht)

-   acl: gewöhnlich bezogen auf einen finiten oder infiniten Satz, der eine Nominalphrase modifiziert (im Kontrast zu advcl, die ein Prädikat modifizieren)

-   mark: ein Marker, der eine untergerodnete Phrase / Satz kennzeichnet.



Deutscher Satz:

-   PRON: Personalpronomen mit Subjekt-Funktion (nsubj)

-   NOUN, VERB, ADP, ADV: Substantiv, Verb, Adposition (hier: Präposition), Adverb

-   DET: Determiner (Determinans), Begleiter eines Substantivs (meist handelt es sich um einen Artikel)

-   obl: eine Art von Adjunkt, in der Valenzgrammatik gewöhnlich als Präpositionalobjekt klassifizert (hier ist "vom Fliegen" das Objekt des Verbs "have")

-   case: Element, das den Kasus einer Phrase regiert (z.B. "von" regiert den Dativ der Nominalphrase "dem Fliegen")

-   advmod: Element, das das Prädikat modifizert (Adverbialphrase).



Slowenischer Satz:

-   Das Personalpronomen mit Subjekt-Funktion fehlt, daher auch keine Subjekt-Relation (nsubj) angezeigt.

-   In slowenischen Nominalphrasen sind Begleiter (DET) nicht obligatorisch bzw. default (slow. "privzeto") wie etwa im Englischen oder Deutschen.

-   NOUN, VERB, ADP: Substantiv, Verb, Adposition (hier: Präposition)

-   AUX: das Hilfs- oder Auxiliarverb

-   DET: Determiner (Determinans), Begleiter eines Substantivs (meist handelt es sich um einen Artikel)

-   xcomp: hier eine Relation zwischen zwei Verben, die gemeinsam das Prädikat des Satzes bilden ("začel sanjati")

-   obl: eine Art von Adjunkt, in der Valenzgrammatik gewöhnlich als Präpositionalobjekt klassifizert (hier ist "o letenju" das Objekt des Verbs "sanjati")

-   case: Element, das den Kasus einer Phrase regiert (z.B. die Präposition "o" regiert den Dativ der Nominalphrase "letenju").



Aus den drei Diagrammen ist ersichtlich, dass die Subjekt-Relation (nsubj) im englischen und deutschen Satz mittels eines Personalpronomens (PRON) realisiert wird, während das Subjekt im slowenischen Satz mittels der finiten Verbform, einem Hilfs- oder Auxiliarverbs (AUX), (mit)ausgedrückt wird, also im Hilfsverb "versteckt" auftritt. Im slowenischen Satz ist PRON syntaktisch nicht notwendig, im englischen und deutschen schon. Das wirkt sich natürlich auf die Frequenzwerte bzw. den Pronzenanteil aus (s. Tabelle).

Die Diagramme zeigen strukturelle Ähnlichkeiten und Unterschiede zwischen den Sprachversionen:

-   sowohl im englischen Untertitel als auch in der slowenischen Version wird eine xcomp-Relation angegeben, d.h. dass das Satzprädikat mit Hilfe von zwei Verben konstituiert wird ("started having" vs. "začel sanjati"). Die Verben "started" bzw. "začeti" modifizeren das Hauptverb "have" bzw. "sanjati" temporal. Im deutschen Untertitel wird stattdessen ein einfaches Prädikat ("träumte") verwendet, dass durch eine Adverbialphrase ("auf einmal") temporal modifiziert wird.

-   das englische Substantiv "dream" wird im deutschen und slowenischen Untertitel im Satzprädikat ausgedrückt ("träumte", "sanjati")

-   der englische Subordinationsmarker "of", der sich sowohl auf Nominalphrasen als auch auf Sätze beziehen kann, wird im deutschen und slowenischen Untertitel mit einer spezifischeren Wortklasse ausgedrückt, nämlich mit einer Präposition (ADP, Adposition).

-   [Universal POS tags](https://universaldependencies.org/u/pos/index.html)

-   [Universal features](https://universaldependencies.org/u/feat/index.html)

-   [UDPipe](http://lindat.mff.cuni.cz/services/udpipe/)

### Aktiv und Passiv

Wie groß ist der Anteil aktivischer und passivischer Sätze in den drei Sprachversionen? Dies können wir mit Hilfe der nsubj-Relation erfahren. In den englischen und deutschen Untertiteln wurden je 34 passivische Subjekte identifizert, in den slowenischen keiner.



Schauen wir uns ein paar dieser Untertitel in allen drei Sprachen an:



-   Wir wählen einen englischen Untertitel als Beispiel, und zwar: "And the concept is that ervery driver is matched to his own avatar\*".
-   Deutsche Version: "*Die Idee ist, dass jeder Operator auf seinen eigenen Avatar abgestimmt wird*".
-   Slowenische Version: "*Vsak upravljavec dobi svojega avatarja*".





Wiederum visualisieren wir die drei Sprachversionen.









-   Die slowenische Version ist syntaktisch am einfachsten, denn sie besteht lediglich aus einem Hauptsatz, im englischen und deutschen Untertitel dagegen aus Haupt- und Nebensatz, wobei letztere die hauptsächliche Information trägt (die auch im slowenischen Hauptsatz zu Tage tritt). Der Hauptsatz im englischen und deutschen Untertitel kann kommunikativ betrachtet als Vorreiter oder Vorschaltung eingeordnet werden, also als Ausdruck, der vor allem zur Orientierung oder Einordnung eines Gedankens (der im Nebensatz ausgedrückt wird) in ein Gedankenschema oder Frame dient.

-   Die passivische Relation, die im englischen und deutschen Untertitel mittels passivischer Verbformen realisiert wird, wird im slowenischen Untertitel mit dem Verb "dobiti" zum Ausdruck gebracht (deutsch: "bekommen", englisch: "get"). Das Subjekt des slowenischen Verb "dobiti" (hier: "vsak upravljalec") ist semantisch gesehen ein Benefaktiv oder Nutznießer (benefaktive Relation), also ein Rezipient, für den eine Handlung vorteilhaft oder nutzbringend ist. Entsprechendes gilt auch für das deutsche bekommen-Passiv (z.B. "jeder Operator bekommt einen Avatar".

-   Die Ausdrucksweise im slowenischen Untertitel ist im Vergleich zu den anderen Sprachversionen semantisch ungenau, denn es bleibt dem Leser überlassen, ob er die im Film realisierte symbiotische Verbindung zwischen Reiter und Tier nachvollziehen kann. Die Ausdrucksweise im englischen und deutschen Untertitel ist dagegen spezifischer, d.h. es handelt sich um eher eine technische (fachbezogene) Ausdrucksweise (engl. "matching", deutsch "Abstimmung").

-   Da es sich in diesem Fall um einen Vorgang oder Prozess handelt, gibt es keinen menschlichen Verursacher der Abstimmung, denn sowohl der Operator (driver, upravljalec) sind so wie das gerittene Tier lediglich Reagentien im Prozess. Das ist in allen drei Sprachversionen deckungsgleich.

-   In allen drei Sprachversionen wird wird der (menschliche) Benefaktiv (d.h. das syntaktische Subjekt) als Ausgangspunkt einer neuen oder wichtigen Information verwendet. Die neue Information "seinen eigenen Avatar" wird ins Rampenlicht gerückt, also zum Rhema des Satzes gemacht. Die typische Verteilung Thema vor Rhema wird hiermit in allen drei Sprachversionen gewahrt. Außerdem wird damit auch die häufigere Reihenfolge Subjekt vor Objekt eingehalten. Im slowenischen Satz handelt es sich um ein direktes Objekt (Akkusativobjekt), im englischen und deutschen dagegen um ein Präpositionalobjekt ("match to ...", "abstimmen auf ...").


### Substantive und Pronomen als Satzglieder

Nun lenken wir unsere Sichtweise auf die Wortklassen Substantiv (NOUN) und Pronomen (PRON) in Subjekt- oder Objekt-Funktion. 



Ein erster Blick auf die Tabelle zeigt uns mehrere Unterschiede:
-   Pronomen erscheinen in den englischen und deutschen Untertiteln häufiger in Subjekt-Funktion als Substantive. In den slowenischen Untertiteln ist es umgekehrt, was wahrscheinlich damit zusammenhängt, dass Slowenisch eine Pro-Drop-Sprache ist (s.o.).
-   In Objekt-Funktion scheint das Verhältnis zwischen den beiden Wortklassen (NOUN, PRON) ausgewogener zu sein.
-   Das indirekte Objekt (iobj), dass sich, semantisch betrachtet, oft auf einen Adressaten oder Rezipienten bezieht, wird vorzugsweise mit einem Pronomen ausgedrückt, selten oder gar nicht mit einem Substantiv.
-   Für einige Satzglied-Funktionen liegen keine Zahlen vor. Das kann daran liegen, dass diese Funktionen in der verwendeten Grammatik einer der ausgewählten Sprachen nicht unterschieden wird.

Für genauere Feststellungen empfiehlt es sich, nur jeweils zwei Satzgliedfunktionen miteinander zu vergleichen.


### Subjekt nominal / pronominal

Wie viele Subjekte im Aktiv oder Passiv werden mit Hilfe von Substantiven oder Personalpronomen ausgedrückt?



Treten Pronomen genau so häufig als Passiv-Subjekte auf wie Substantive? Die obige Tabelle scheint für die englischen und deutschen Untertitel das Gegenteil zu zeigen. Machen für doch für diese beiden Sprachversionen je einen Chi-Quadrat-Test!



In der letzten Tabelle fällt auf, dass der Anteil der Pronomen (pct_PRON) in der nsubj:pass-Funktion größer ist als der der Substantive (pct_NOUN). Ist dieser Unterschied zufällig (aufgrund der Stichprobenauswahl entstanden) oder können wir ihn auf die Grundgesamtheit (auf umgangssprachliche Dialoge in der englischen Sprache) verallgemeinern? Eine Antwort darauf soll uns der Chi-Quadrat-Test geben.

Für den Chi-Quadrat-Test benötigen wir lediglich die beiden Spalten mit den absoluten Zahlenwerten (also die zweite und dritte). In *Base-R* kann man dies sehr ökonomisch mit einer Bedingung in eckigen Klammern *[]* erreichen, mit der tidyverse-Funktion *select()* zwar transparenter und in Tabellenform, dafür muss man jedoch etwas mehr schreiben.



Der Chi-Quadrat-Test bestätigt mit dem p-Wert (0,1339) die Null-Hypothese, d.h. das es zwischen Pronomen und Substantiven als Subjekte in den englischen Untertiteln keinen statistisch signifikanten Unterschied gibt und dass der prozentuelle Unterschied aufgrund unserer Stichprobenauswahl entstanden ist (also zufällig).

Dasselbe können wir mit den deutschen Pronomen und Substantiven in Subjekt-Funktion machen. In diesem Fall ist der prozentuelle Unterschied zwischen Substantiven und Pronomen als aktivische oder passivische Subjekte größer zu sein als in der englischen Stichprobe.



In den deutschen Untertiteln können wir mit dem Chi-Quadrat-Test einen statistisch signifikanten Unterschied zwischen Pronomen und Substantiven nachweisen (p < 0,05): Pronomen scheinen in Subjekt-Funktion seltener in Passivsätzen verwendet worden zu sein als Substantive. Möglicherweise gilt dies auch für die Grundgesamtheit in deutsche Sprache (hier vor allem für umgangssprachliche Dialoge). Anders ausgedrückt: wir haben eine (nicht zufällige) Tendenz nachgewiesen, dass das Subjekt in den deutschen Passivsätzen häufiger mit Substantiven, also autosemantischen Ausdrücken realisiert wurde.



Wir können uns die entsprechenden Belege mit Passivsubjekten auch anschauen. Aus der Tabelle ist auch ersichtlich, dass die grammatische Analyse des Programms auch einige Fehler enthält (z.B. "Avatar" in "(auf) seinen eigenen Avatar abgestimmt wird" ist Bestandteil eines Präpositionalobjekts und kein Passivsubjekt) oder eine andere Klassifizierung sinnvoller wäre (z.B. "Was ist hier passiert?" - "was" wurde als Passivsubjekt des Verbs "passieren" eingeordnet). Im Untertitel "wenn du nicht gekommen wärst" scheint das Programm den sein-Passiv übergeneralisierend auf Sätze mit einem Verb im Perfekt anzuwenden. Einige Fehler kommen aufgrund unvollständiger Sätze als Input vor, andere wiederum aufgrund der Tatsache, dass bestimmte sprachliche Formen mehrere Funktionen in der Sprache erfüllen können.




### Objekt nominal / pronominal

Wird das *direkte Objekt* (obj), im Deutschen und Slowenischen auch *Akkusativojekt* genannt, in den Untertiteln häufiger nominal oder pronominal ausgedrückt?



Die Tabelle deutet daraufhin, dass in den englischen Untertiteln kein wesentlicher Unterschied auftritt, in den deutschen und slowenischen Untertiteln dagegen schon. Das können wir wiederum testen. Der erste Chi-Quadrat-Test bestätigt für die englischen Untertitel die Null-Hypothese (bei p > 0,05 also keinen Unterschied), für die deutschen und slowenischen Untertitel dagegen die alternative Hypothese (d.h. dass es bei p < 0,05 einen Wahrscheinlichkeitsunterschied gibt, ob das Objekt nominal oder pronominal ausgedrückt ist). 



### Wortklasse von Subjekt / Objekt

Welche sprachübergreifende (cross-linguistic) Tendenz werden mit den englisch- und deutschsprachigen Daten bestätigt?



Englisch:



Deutsch:



Sowohl in den englischen als auch deutschen Untertiteln wird das Subjekt häufiger pronominal und seltener nominal ausgedrückt. Beim direkten Objekt ist es umgekehrt, denn dieses wird häufiger nominal ausgedrückt. Das man darauf zurückgeführen, dass das Subjekt häufig definit ist (etwas vom Hörer / Leser Identifizierbares ausdrückt), das Objekt dagegen etwas (noch) nicht Identifziertes.

Dieses Verhältnis können wir in den slowenischen Untertiteln nicht nachweisen, was wir wiederum auf die Tatsache zurückführen können, dass Slowenisch eine Pro-Drop-Sprachen ist und daher die Anzahl pronominalisierter Subjekte wesentlich geringer sein muss, da ein pronominalisiertes Subjekt nur bei Hervorhebung obligatorisch im Satz vorkommt.



### Gattungs- und Eigennamen

Treten Gattungsnamen (Appelativa) und Eigennamen häufiger in Subjekt- oder in Objekt-Funktion auf?

Englisch:



Deutsch:



Slowenisch:



In allen drei Sprachversionen treten die Eigennamen (PROPN) häufiger in Subjekt-Funktion als in Objekt-Funktion auf, was man wieder darauf zurückführen kann, dass Eigennamen eine definite (d.h. identifizierbare) Einheit bezeichnen.

### Konstituentenfolge

In *SOV-Sprachen* ist die Reihenfolge *Modifizierer vor Kopf* häufiger zu beobachten, in *SVO-Sprachen* dagegen *Modifizierer nach Kopf*. Das prüfen wir in unserem bisherigen Sprachmaterial. Als Modifizierer wählen wird attributive Adjektive, als Kopf von Nominalphrasen die davor oder dahinter stehenden Substantive oder andere Wortklassen (z.B. Pronomen). 

Englisch und Slowenisch werden gewöhnlich als SVO-Sprachen eingeordnet, Deutsch mit der Konstituentenfolge SVO in Hauptsätzen und SOV in Nebensätzen wird im Atlas *Wals* (https://wals.info) dagegen als Sprache ohne dominante Konstituentenfolge bezeichnet. 

Was zeigt nun unser Sprachmaterial?



Im Englischen, Deutschen und Slowenischen und Türkischen dominiert die Reihenfolge Adjektiv vor Substantiv, also Modifizierer vor Kopf. Im Französischen und Italienischen dagegen ist die umgekehrte Reihenfolge dominant bzw. sind sowohl vor- als auch nachgestellte adjektivische Attribute fast gleich gut vertreten. 

Schauen wir uns noch an, in welchen Untertiteln unser Programm nachgestellte Adjektive identifiziert hat!



Im slowenischen Untertitel "Gre za nekaj resničnega" wird das Adjektiv "resničnega" als nachgestelltes Attribut zum Kopf "nekaj", einem Pronomen, eingeordnet. Entsprechend im englischen Untertitel: "Something measurable". Aber einige der Belege entpuppen sich als Fehlmeldung. 


### Kontexte von Modifizierern






### Greenbergs Universalie 25

"If the pronominal object follows the verb, so does the nominal object."

Zuerst wollen wir direkte Objekte (im Deutschen und Slowenischen auch als Akkusativobjekte bezeichnet) ausfinding machen, die sowohl Gattungsnamen als auch Eigennamen enthalten und die dem Kopf der Verbalphrase vorangehen (OV) oder folgen (VO). 



Nun machen wir dasselbe mit den pronominalen Objekten.



Dann fügen wir beide Tabellen zusammen.







Übersichtsgraphik mit Korrelationsberechnung:



Korrelationsgraphik:








Schnell eine Graphik mit dem Datensatz erstellen, ohne zu programmieren:



