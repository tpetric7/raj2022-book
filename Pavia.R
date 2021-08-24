
#In this session, we will use the package udpipe to do the following:
#-to annotate short texts and large corpora in different languages,
#-to load and analyze the existing UD corpora,
#-to extract different types of information from corpora in the UD format. 

#You can execute a line of R code by clicking on Run. 
#Alternatively, you can press Ctrl + Enter.
#The hashtagged lines are not executed.

#In order to use udpipe, you should install it first (see the instructions).
#After you have installed it, you should load it every time you start an R session.

library(udpipe)


###PART I. Annotation of simple texts and corpus query.
###Task 1. Annotation of English text.
#First, we should load the English model.

#If you have already loaded the English model, please ignore the line of code below.
#If you haven't, remove the hashtag and run this command:
model_eng <- udpipe_download_model(language = "english")

ud_english <- udpipe_load_model(model_eng$file_model)

#We begin with a simple sentence, creating a character vector with the sentence. 
text <- "There's no place like home."
#We parse it with udpipe
x <- udpipe(text, object = ud_english)
#Let's look at the result 
x
#Some details for R users
is(x)

#What are the columns of this data frame?
colnames(x)

#Exercise1: Parse a sentence of your choice and check if the analysis is correct.

#Let's parse two sentences
text <- "Mama always said life was like a box of chocolates. You never know what you're gonna get."
x <- udpipe(text, object = ud_english)
x

# Now we'll parse the Universal Declaration of Human Rights. 
#Important: the text should be saved in the UTF-8 format (I recommend Notepad++ for working with text data)
#Running the code below will open a dialog window where you can select the file.
text <- scan(file = file.choose(), what = "character", sep  = "\n", encoding = "UTF-8")

#The function reads the text to R, splitting the text into paragraphs (sep = "\n")
#Look at the first six items of the Declaration.
head(text,10)

# # In case of subtitles, run the following two lines:
# library(reader)
# text1 <- n.readLines("Pavia_data/Avatar_eng.txt", n = 4470, skip = 2, header = FALSE)
# head(text1)
# 
# # In case of subtitles (Avatar), run the following two lines:
# library(tidyverse)
# text1 <- separate(text, col = text, into = c("time", "text"), sep = "\t")

text <- read.delim2("Alt_Pavia-master/Avatar/Avatar_eng_deu.txt", header = FALSE, stringsAsFactors = FALSE)

text <- (text[,2]) # only English
head(text,10)

#Now we can parse the text.
x <- udpipe(text, object = ud_english)
head(x)

#How to save the output as a conllu file:
getwd()
write.table(as_conllu(x), file = "Avatar_ud.conllu", sep = "\t", quote = F, row.names = F)


##Task 2. Data exploration and corpus query.

#How to compute token frequencies 
tokens_freq <- table(x$token)
tokens_freq
#Top 20
sort(tokens_freq, decreasing = TRUE)[1:20]

#The same for lemmas
lemmas_freq <- table(x$lemma)
sort(lemmas_freq, decreasing = TRUE)[1:20]

#Frequencies of noun lemmas only (top 20)
nouns_freq <- table(x$lemma[x$upos == "NOUN"])
sort(nouns_freq, decreasing = T)[1:20]

#Find the line with the word "wedlock". 
#Important: when making a subset of a 2-dimensional object, 
#the rows are selected on the left of the comma,
#the columns are selected on the right of the comma.

x[x$lemma == "brother",]

x[x$lemma == "brother",1] # in which documents (in Avatar = utterance)
x[x$lemma == "brother",4] # in which sentences
x[x$lemma == "brother",11] # upos
x[x$lemma == "brother",13] # word features (case, number, ...)
x[x$lemma == "brother",15] # dependency relations


#Find only the sentence with the word "wedlock".
#Here, we don't need a comma because we make a subset of a one-dimensional object (i.e. the column Sentence)
x$sentence[x$lemma == "brother"]

#Exercise 2: find the sentences with the word "law"

#Find all plural nouns (tokens)
x$token[x$upos == "NOUN" & x$feats == "Number=Plur"] 

x$token[x$lemma == "brother" & x$upos == "NOUN" & x$feats == "Number=Plur"] 

#If you forgot the values of POS, morphological features or dependencies,
#you can easily check them:
#Universal parts of speech
levels(factor(x$upos))
#Syntactic dependencies
levels(factor(x$dep_rel))
#Morphological features
levels(factor(x$feats))
#see universaldependencies.org for information about the meaning of all these labels.

#Exercise 3: find all tokens of adjectives in the comparative form, and the sentences where they occur

#Frequencies of parts of speech
pos_freq <- table(x$upos)
pos_freq
#sorted in descending order
sort(pos_freq, decreasing = TRUE)

#Frequencies of syntactic dependencies
dep_freq <- table(x$dep_rel)
dep_freq
#sorted in descending order
sort(dep_freq, decreasing = TRUE)

#Exercise 4: take a small text in English, read it in R, parse it and obtain the top 20 frequency lists of tokens, lemmas, parts of speech and syntactic dependencies.
#Note: use x1 or another name instead of x in your code. Otherwise, the parsed English text will be overwritten.

#Which and how many active and passive subjects are there?
x$lemma[x$dep_rel == "nsubj"]
length(which(x$dep_rel == "nsubj"))
x$lemma[x$dep_rel == "nsubj:pass"]
length(which(x$dep_rel == "nsubj:pass"))

#Combining different conditions. How many are nouns and how many are pronouns?
length(which(x$dep_rel == "nsubj" & x$upos == "NOUN"))
length(which(x$dep_rel == "nsubj" & x$upos == "PRON"))

#Exercise 5: how many passive subjects are nouns, and how many of them are pronouns?

#Let's extract the lemmas of all objects
x$lemma[x$dep_rel == "obj"]
#lemmas of all objects that are pronouns
x$lemma[x$dep_rel == "obj" & x$upos == "PRON"]
#Lemmas of all objects that are common nouns:
x$lemma[x$dep_rel == "obj" & x$upos == "NOUN"]
#How many such objects are there?
length(which(x$dep_rel == "obj" & x$upos == "NOUN"))

#Which cross-linguistic tendency do these results confirm?

#Lemmas of all objects that are common OR proper nouns:
x$lemma[x$dep_rel == "obj" & x$upos %in% c("NOUN", "PROPN")]

##Task 3. Extraction of information about word order from the English data.

#First, we need to turn the character vectors with IDs into numeric vectors.
#This is a purely technical procedure.
summary(x$token_id) #you can see that the token_id values are treated as character strings, not as numbers
summary(x$head_token_id) #the same for head_token_id

x$token_id <- as.numeric(x$token_id)
summary(x$token_id) #now you can see that these are numbers

x$head_token_id <- as.numeric(x$head_token_id)
summary(x$head_token_id)

#How many attributive adjectives ("amod" and ADJ) follow and precede the head?
length(which(x$dep_rel == "amod" & x$upos == "ADJ" & x$token_id < x$head_token_id))
length(which(x$dep_rel == "amod" & x$upos == "ADJ" & x$token_id > x$head_token_id))
#check the sentences with adjectives following the head. What do they have in common?
x$sentence[x$dep_rel == "amod" & x$upos == "ADJ" & x$token_id > x$head_token_id]

#Task 4. Parsing text in German

#If you have already downloaded the model, you can skip the next command.
#If not, remove the hashtag and run the code.
model_ger <- udpipe_download_model(language = "german")

ud_german <- udpipe_load_model(model_ger$file_model)

text_ger <- "Du hast mich gefragt."
x <- udpipe(text_ger, object = ud_german)
x

#Exercise 6: parse a sentence in another language and interpret the output. Are there any errors?
#to see the available models, type:

?udpipe_download_model

#to choose between multiple models for the same language: 
#see https://universaldependencies.org/

########################################
###PART II: Order of head and amod in UD corpora

library(udpipe)
#select UD_English-EWT/en_ewt-ud-train.conllu from UD, version 2.4
# Avatar english subtitles
eng_ud <- udpipe_read_conllu(file = file.choose())
nrow(eng_ud) #number of tokens (incl. punctuation)
colnames(eng_ud) #column names

#important: transform token_id and head_token_id into numeric vectors
eng_ud$token_id <- as.numeric(eng_ud$token_id)
eng_ud$head_token_id <- as.numeric(eng_ud$head_token_id)

#which and how many attributive adjectives precede the head?
eng_ud$token[eng_ud$dep_rel == "amod" & eng_ud$upos == "ADJ" & eng_ud$token_id < eng_ud$head_token_id]
length(which(eng_ud$dep_rel == "amod" & eng_ud$upos == "ADJ" & eng_ud$token_id < eng_ud$head_token_id))
#8084
# 261 in Avatar (english subtitles)

#which and how many attributive adjectives follow the head?
eng_ud$token[eng_ud$dep_rel == "amod" & eng_ud$upos == "ADJ" & eng_ud$token_id > eng_ud$head_token_id]
length(which(eng_ud$dep_rel == "amod" & eng_ud$upos == "ADJ" & eng_ud$token_id > eng_ud$head_token_id))
#265
# 15 in Avatar (english subtitles)

#Exercise 7: examine the contexts of individual adjectives, e.g. "fantastic".
#What kind of constructions can you identify?
eng_ud$sentence[eng_ud$dep_rel == "amod" & eng_ud$upos == "ADJ" & 
                  eng_ud$token_id < eng_ud$head_token_id & eng_ud$token == "big"]

#Compute the proportions of amod - head and head - amod
prop.table(c(8084, 265))
#[1] 0.96825967 0.03174033
prop.table(c(261, 15))
# [1] 0.94565217 0.05434783 (in Avatar - english subtitles)

#Create a numeric vector with one element: proportion of amod - head
eng_amod_head <- prop.table(c(8084, 265))[1]
eng_amod_head

#Create a numeric vector with one element: proportion of amod - head
eng_amod_head <- prop.table(c(261, 15))[1]
eng_amod_head
#Create a numeric vector with one element: proportion of amod - head
eng_head_amod <- prop.table(c(261, 15))[2]
eng_head_amod


#The same for Italian ISDT (train)
#The same for GERMAN
model_ger <- udpipe_download_model(language = "german")
ud_ger <- udpipe_load_model(model_ger$file_model)
# setwd("d:/Users/teodo/Documents/R/NataliaLevshina/ALT_Pavia-master/")
text <- read.delim2("ALT_Pavia-master/Avatar/Avatar_eng_deu.txt", header = FALSE, stringsAsFactors = FALSE, 
                    fileEncoding = "UTF-8")
text <- (text[,3]) # only German
head(text,10)
x <- udpipe(text, object = ud_ger)
head(x)
write.table(as_conllu(x), file = "Avatar_ud_deu.conllu", sep = "\t", quote = F, row.names = F)

# ita_ud <- udpipe_read_conllu(file = file.choose())
ger_ud <- udpipe_read_conllu(file = "Avatar_ud_deu.conllu")
nrow(ger_ud) #number of tokens (incl. punctuation)

#important: transform token_id and head_token_id into numeric vectors
ger_ud$token_id <- as.numeric(ger_ud$token_id)
#missing values: due to forms like degli, alla, etc. 
#we remove those lines:
ger_ud <- ger_ud[complete.cases(ger_ud$token_id),]

ger_ud$head_token_id <- as.numeric(ger_ud$head_token_id)

#which and how many attributive adjectives precede the head?
ger_ud$token[ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & ger_ud$token_id < ger_ud$head_token_id]
length(which(ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & ger_ud$token_id < ger_ud$head_token_id))
#4665 (Italian)
# 212 in Avatar (german subtitles)

#which and how many attributive adjectives follow the head?
ger_ud$token[ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & ger_ud$token_id > ger_ud$head_token_id]
length(which(ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & ger_ud$token_id > ger_ud$head_token_id))
#10761 (Italian)
# 7 in Avatar (german subtitles)

#Exercise 8: examine the contexts of individual adjectives, e.g. "vero".
#What kind of constructions can you identify?
ger_ud$sentence[ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & 
                  ger_ud$token_id < ger_ud$head_token_id & ger_ud$token == "gut"]
length(ger_ud$sentence[ger_ud$dep_rel == "amod" & ger_ud$upos == "ADJ" & 
                         ger_ud$token_id < ger_ud$head_token_id & ger_ud$token == "gut"])

# German Avatar subtitles
#Compute the proportions of amod - head and head - amod
prop.table(c(212, 7))
# [1] 0.96803653 0.03196347
ger_amod_head <- prop.table(c(212, 7))[1]
ger_amod_head

# Chi-Square Two sample test
eng_count <- c(261, 15)
ger__count <- c(212, 7)
amod_head_eng_ger <- cbind(eng_count, ger__count)
chisq.test(amod_head_eng_ger)

# Italian
#Compute the proportions of amod - head and head - amod
prop.table(c(4665, 10761))
#[1] 0.3024115 0.6975885
ita_amod_head <- prop.table(c(4665, 10761))[1]
ita_amod_head

# Chi-Square Two sample test
eng_count <- c(261, 15)
ita__count <- c(4665, 10761) # these are not Avatar subtitles
amod_head_eng_ita <- cbind(eng_count, ita__count)
chisq.test(amod_head_eng_ita)

#Exercise 9: perform the same kind of analysis for another language. Are your expectations confirmed?

#After we have data about many languages, we can aggregate 
#and visualize the proportions, using the code below

amod_head <- c(eng_amod_head, ger_amod_head, ita_amod_head) #add other languages!
names(amod_head) <- c("English", "German", "Italian") #add other names of languages!
dotchart(sort(amod_head), xlim = c(0, 1), xlab = "Proportion of amod first", color = 1:3)

png("dotchart_amod-head-proportion-in-E-D-I.png")
dotchart(sort(amod_head), xlim = c(0, 1), xlab = "Proportion of amod first", color = 1:3)
dev.off()

########################################
###PART III: Greenberg's Universal 25 in UD corpora
#"If the pronominal object follows the verb, so does the nominal object."

#First, we look for objects that are common or proper nouns, and which follow the head:
vo_nouns_eng <- length(which(eng_ud$dep_rel == "obj" & eng_ud$upos %in% c("NOUN", "PROPN") & 
                               eng_ud$token_id > eng_ud$head_token_id))
vo_nouns_eng
#7395
# 362 in Avatar

#the same, but the objects precede the head:
ov_nouns_eng <- length(which(eng_ud$dep_rel == "obj" & eng_ud$upos %in% c("NOUN", "PROPN") & 
                               eng_ud$token_id < eng_ud$head_token_id))
ov_nouns_eng
#45
# 4 in Avatar

#Now the same for pronominal objects following the head:
vo_pronouns_eng <- length(which(eng_ud$dep_rel == "obj" & eng_ud$upos == "PRON" & 
                                  eng_ud$token_id > eng_ud$head_token_id))
vo_pronouns_eng
#2042
# 315 in Avatar

#And finally pronominal objects preceding the head:
ov_pronouns_eng <- length(which(eng_ud$dep_rel == "obj" & eng_ud$upos == "PRON" & 
                                  eng_ud$token_id < eng_ud$head_token_id))
ov_pronouns_eng
#318
# 25 in Avatar

#Put the frequencies together in one numeric vector and provide them with names:
eng_vo <- c(vo_nouns_eng, ov_nouns_eng, vo_pronouns_eng, ov_pronouns_eng)
names(eng_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")
eng_vo
#  vo_nouns    ov_nouns vo_pronouns ov_pronouns 
#   7395          45        2042         318 
#    362           4         315          25 (in Avatar)

#Let's repeat that for Yoruba
# We choose the German subtitle version of Avatar: Yoruba = German
yoruba <- udpipe_read_conllu(file = file.choose())
head(yoruba)

yoruba$token_id <- as.numeric(yoruba$token_id)
summary(yoruba$token_id)

yoruba$head_token_id <- as.numeric(yoruba$head_token_id)
summary(yoruba$head_token_id)


vo_nouns_yor <- length(which(yoruba$dep_rel == "obj" & yoruba$upos %in% c("NOUN", "PROPN") & 
                               yoruba$token_id > yoruba$head_token_id))
vo_nouns_yor
ov_nouns_yor <- length(which(yoruba$dep_rel == "obj" & yoruba$upos %in% c("NOUN", "PROPN") & 
                               yoruba$token_id < yoruba$head_token_id))
ov_nouns_yor

vo_pronouns_yor <- length(which(yoruba$dep_rel == "obj" & yoruba$upos == "PRON" & 
                                  yoruba$token_id > yoruba$head_token_id))
vo_pronouns_yor
ov_pronouns_yor <- length(which(yoruba$dep_rel == "obj" & yoruba$upos == "PRON" & 
                                  yoruba$token_id < yoruba$head_token_id))
ov_pronouns_yor

yor_vo <- c(vo_nouns_yor, ov_nouns_yor, vo_pronouns_yor, ov_pronouns_yor)
names(yor_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")
# German Avatar
# vo_nouns    ov_nouns vo_pronouns ov_pronouns 
# 145         109         123         131 


#Exercise 10: obtain the same frequencies for two or more other languages

#... after we have multiple languages, we can put everything together:
vo <- rbind(eng_vo, yor_vo) #add more languages...
vo <- as.data.frame(vo)

##compute and visualize the proportions of Noun + V and Pron + V:
vo$ov_nouns_prop <- vo$ov_nouns/(vo$vo_nouns + vo$ov_nouns)
vo$ov_pronouns_prop <- vo$ov_pronouns/(vo$vo_pronouns + vo$ov_pronouns)
vo$language <- c("eng", "yor") #Add more language names!
plot(vo$ov_nouns_prop, vo$ov_pronouns_prop, ylim = c(0, 1), xlim = c(0, 1), type = "n")
text(vo$ov_nouns_prop, vo$ov_pronouns_prop, labels = vo$language)

#Now let's stop and think: How can we reformulate the universal?

########################################
###PART IV: Greenberg's Universal 25 in film subtitles

library(readr) #the package readr should be installed first (see the instructions)
pathdir = getwd()
# avatar_eng <- read_file(file = file.choose())
# Avatar English subtitle file
avatar_eng <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_eng.txt"))
avatar_eng
cat(avatar_eng)
#remove the timing information and italics
avatar_eng <- gsub("<i>", "", avatar_eng)
avatar_eng <- gsub("</i>", "", avatar_eng)
avatar_eng <- gsub("-->", "", avatar_eng)
avatar_eng <- gsub("\\b[0-9:,]+\\b", "", avatar_eng)
avatar_eng <- gsub("\r\n", "", avatar_eng)
cat(avatar_eng)

library(udpipe)
ud_english <- udpipe_load_model(model_eng$file_model)

avatar_eng_ud <- udpipe(avatar_eng, object = ud_english)
head(avatar_eng_ud)
tail(avatar_eng_ud)

#transform token_id and head_token_id into numbers
avatar_eng_ud$token_id <- as.numeric(avatar_eng_ud$token_id)
avatar_eng_ud$head_token_id <- as.numeric(avatar_eng_ud$head_token_id)

#find all VO and OV patterns with nouns and pronouns separately

vo_nouns_eng <- length(which(avatar_eng_ud$dep_rel == "obj"&avatar_eng_ud$upos %in% c("NOUN", "PROPN") & 
                               avatar_eng_ud$token_id > avatar_eng_ud$head_token_id))
vo_nouns_eng # 365
ov_nouns_eng <- length(which(avatar_eng_ud$dep_rel == "obj"&avatar_eng_ud$upos %in% c("NOUN", "PROPN") & 
                               avatar_eng_ud$token_id < avatar_eng_ud$head_token_id))
ov_nouns_eng # 3

vo_pronouns_eng <- length(which(avatar_eng_ud$dep_rel == "obj"&avatar_eng_ud$upos == "PRON" & 
                                  avatar_eng_ud$token_id > avatar_eng_ud$head_token_id))
vo_pronouns_eng # 314
ov_pronouns_eng <- length(which(avatar_eng_ud$dep_rel == "obj"&avatar_eng_ud$upos == "PRON" & 
                                  avatar_eng_ud$token_id < avatar_eng_ud$head_token_id))
ov_pronouns_eng #28

eng_vo <- c(vo_nouns_eng, ov_nouns_eng, vo_pronouns_eng, ov_pronouns_eng)
names(eng_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")

##the same with Italian, Finnish and other versions

#Italian
# avatar_ita <- read_file(file = file.choose())
avatar_ita <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_ita.txt"))
avatar_ita
#remove the timing information and italics
avatar_ita <- gsub("<i>", "", avatar_ita)
avatar_ita <- gsub("</i>", "", avatar_ita)
avatar_ita <- gsub("-->", "", avatar_ita)
avatar_ita <- gsub("\\b[0-9:,]+\\b", "", avatar_ita)
avatar_ita <- gsub("\r\n", "", avatar_ita)
cat(avatar_ita)

#if you haven't downloaded the model yet, run the line below:
model_ita <- udpipe_download_model(language = "italian")

ud_italian <- udpipe_load_model(model_ita$file_model)

avatar_ita_ud <- udpipe(avatar_ita, object = ud_italian)
head(avatar_ita_ud)
tail(avatar_ita_ud)

#find all VO and OV patterns with nouns and pronouns separately
avatar_ita_ud$token_id <- as.numeric(avatar_ita_ud$token_id)
summary(avatar_ita_ud$token_id)

avatar_ita_ud$head_token_id <- as.numeric(avatar_ita_ud$head_token_id)
summary(avatar_ita_ud$head_token_id)

avatar_ita_ud <- avatar_ita_ud[complete.cases(avatar_ita_ud$token_id),]

vo_nouns_ita <- length(which(avatar_ita_ud$dep_rel == "obj"&avatar_ita_ud$upos %in% c("NOUN", "PROPN") & 
                               avatar_ita_ud$token_id > avatar_ita_ud$head_token_id))
vo_nouns_ita # 299
ov_nouns_ita <- length(which(avatar_ita_ud$dep_rel == "obj"&avatar_ita_ud$upos %in% c("NOUN", "PROPN") & 
                               avatar_ita_ud$token_id < avatar_ita_ud$head_token_id))
ov_nouns_ita # 8

vo_pronouns_ita <- length(which(avatar_ita_ud$dep_rel == "obj"&avatar_ita_ud$upos == "PRON" 
                                & avatar_ita_ud$token_id > avatar_ita_ud$head_token_id))
vo_pronouns_ita # 72
ov_pronouns_ita <- length(which(avatar_ita_ud$dep_rel == "obj"&avatar_ita_ud$upos == "PRON" & 
                                  avatar_ita_ud$token_id < avatar_ita_ud$head_token_id))
ov_pronouns_ita # 95

ita_vo <- c(vo_nouns_ita, ov_nouns_ita, vo_pronouns_ita, ov_pronouns_ita)
names(ita_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")

#Finnish
# avatar_fin <- read_file(file = file.choose())
avatar_fin <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_fin.txt"))
avatar_fin
#remove the timing information and italics
avatar_fin <- gsub("<i>", "", avatar_fin)
avatar_fin <- gsub("</i>", "", avatar_fin)
avatar_fin <- gsub("-->", "", avatar_fin)
avatar_fin <- gsub("\\b[0-9:,]+\\b", "", avatar_fin)
avatar_fin <- gsub("\r\n", "", avatar_fin)
cat(avatar_fin)

#if you haven't downloaded the model yet, run the code line below:
model_fin <- udpipe_download_model(language = "finnish")

ud_finnish <- udpipe_load_model(model_fin$file_model)

avatar_fin_ud <- udpipe(avatar_fin, object = ud_finnish)
head(avatar_fin_ud)
tail(avatar_fin_ud)

#find all VO and OV patterns with nouns and pronouns separately
avatar_fin_ud$token_id <- as.numeric(avatar_fin_ud$token_id)
summary(avatar_fin_ud$token_id)

avatar_fin_ud$head_token_id <- as.numeric(avatar_fin_ud$head_token_id)
summary(avatar_fin_ud$head_token_id)

avatar_fin_ud <- avatar_fin_ud[complete.cases(avatar_fin_ud$token_id),]

vo_nouns_fin <- length(which(avatar_fin_ud$dep_rel == "obj"&avatar_fin_ud$upos %in% c("NOUN", "PROPN")&avatar_fin_ud$token_id > avatar_fin_ud$head_token_id))
vo_nouns_fin # 188
ov_nouns_fin <- length(which(avatar_fin_ud$dep_rel == "obj"&avatar_fin_ud$upos %in% c("NOUN", "PROPN")&avatar_fin_ud$token_id < avatar_fin_ud$head_token_id))
ov_nouns_fin # 44

vo_pronouns_fin <- length(which(avatar_fin_ud$dep_rel == "obj"&avatar_fin_ud$upos == "PRON"&avatar_fin_ud$token_id > avatar_fin_ud$head_token_id))
vo_pronouns_fin # 121
ov_pronouns_fin <- length(which(avatar_fin_ud$dep_rel == "obj"&avatar_fin_ud$upos == "PRON"&avatar_fin_ud$token_id < avatar_fin_ud$head_token_id))
ov_pronouns_fin # 55

fin_vo <- c(vo_nouns_fin, ov_nouns_fin, vo_pronouns_fin, ov_pronouns_fin)
names(fin_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")

#Exercise 11: check another language and obtain the frequencies. Share your results with the others.

# German
# avatar_deu <- read_file(file = file.choose())
avatar_deu <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_deu.txt"))
avatar_deu
#remove the timing information and italics
avatar_deu <- gsub("<i>", "", avatar_deu)
avatar_deu <- gsub("</i>", "", avatar_deu)
avatar_deu <- gsub("-->", "", avatar_deu)
avatar_deu <- gsub("\\b[0-9:,]+\\b", "", avatar_deu)
avatar_deu <- gsub("\r\n", "", avatar_deu)
cat(avatar_deu)

#if you haven't downloaded the model yet, run the code line below:
model_deu <- udpipe_download_model(language = "german")

ud_german <- udpipe_load_model(model_deu$file_model)

avatar_deu_ud <- udpipe(avatar_deu, object = ud_german)
head(avatar_deu_ud)
tail(avatar_deu_ud)

#find all VO and OV patterns with nouns and pronouns separately
avatar_deu_ud$token_id <- as.numeric(avatar_deu_ud$token_id)
summary(avatar_deu_ud$token_id)

avatar_deu_ud$head_token_id <- as.numeric(avatar_deu_ud$head_token_id)
summary(avatar_deu_ud$head_token_id)

avatar_deu_ud <- avatar_deu_ud[complete.cases(avatar_deu_ud$token_id),]

vo_nouns_deu <- length(which(avatar_deu_ud$dep_rel == "obj"&avatar_deu_ud$upos %in% c("NOUN", "PROPN")&avatar_deu_ud$token_id > avatar_deu_ud$head_token_id))
vo_nouns_deu # 140
ov_nouns_deu <- length(which(avatar_deu_ud$dep_rel == "obj"&avatar_deu_ud$upos %in% c("NOUN", "PROPN")&avatar_deu_ud$token_id < avatar_deu_ud$head_token_id))
ov_nouns_deu # 126

vo_pronouns_deu <- length(which(avatar_deu_ud$dep_rel == "obj"&avatar_deu_ud$upos == "PRON"&avatar_deu_ud$token_id > avatar_deu_ud$head_token_id))
vo_pronouns_deu # 106
ov_pronouns_deu <- length(which(avatar_deu_ud$dep_rel == "obj"&avatar_deu_ud$upos == "PRON"&avatar_deu_ud$token_id < avatar_deu_ud$head_token_id))
ov_pronouns_deu # 132

deu_vo <- c(vo_nouns_deu, ov_nouns_deu, vo_pronouns_deu, ov_pronouns_deu)
names(deu_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")


# Slovene
# avatar_slv <- read_file(file = file.choose())
library(readr)
pathdir = getwd()
avatar_slv <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_slv.txt"))
avatar_slv
#remove the timing information and italics
avatar_slv <- gsub("<i>", "", avatar_slv)
avatar_slv <- gsub("</i>", "", avatar_slv)
avatar_slv <- gsub("-->", "", avatar_slv)
avatar_slv <- gsub("\\b[0-9:,]+\\b", "", avatar_slv)
avatar_slv <- gsub("\r\n", "", avatar_slv)
cat(avatar_slv)

#if you haven't downloaded the model yet, run the code line below:
model_slv <- udpipe_download_model(language = "slovenian")

ud_slovene <- udpipe_load_model(model_slv$file_model)

avatar_slv_ud <- udpipe(avatar_slv, object = ud_slovene)
head(avatar_slv_ud)
tail(avatar_slv_ud)

#find all VO and OV patterns with nouns and pronouns separately
avatar_slv_ud$token_id <- as.numeric(avatar_slv_ud$token_id)
summary(avatar_slv_ud$token_id)

avatar_slv_ud$head_token_id <- as.numeric(avatar_slv_ud$head_token_id)
summary(avatar_slv_ud$head_token_id)

avatar_slv_ud <- avatar_slv_ud[complete.cases(avatar_slv_ud$token_id),]

vo_nouns_slv <- length(which(avatar_slv_ud$dep_rel == "obj"&avatar_slv_ud$upos %in% c("NOUN", "PROPN")&avatar_slv_ud$token_id > avatar_slv_ud$head_token_id))
vo_nouns_slv # 154
ov_nouns_slv <- length(which(avatar_slv_ud$dep_rel == "obj"&avatar_slv_ud$upos %in% c("NOUN", "PROPN")&avatar_slv_ud$token_id < avatar_slv_ud$head_token_id))
ov_nouns_slv # 41

vo_pronouns_slv <- length(which(avatar_slv_ud$dep_rel == "obj"&avatar_slv_ud$upos == "PRON"&avatar_slv_ud$token_id > avatar_slv_ud$head_token_id))
vo_pronouns_slv # 69
ov_pronouns_slv <- length(which(avatar_slv_ud$dep_rel == "obj"&avatar_slv_ud$upos == "PRON"&avatar_slv_ud$token_id < avatar_slv_ud$head_token_id))
ov_pronouns_slv # 146

slv_vo <- c(vo_nouns_slv, ov_nouns_slv, vo_pronouns_slv, ov_pronouns_slv)
names(slv_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")


library(readr)
pathdir = getwd()
avatar_slo <- read_file(file = paste0(pathdir,"/ALT_Pavia-master/Pavia_data/","Avatar_2009_slo.srt"))
avatar_slo
#remove the timing information and italics
avatar_slo <- gsub("<i>", "", avatar_slo)
avatar_slo <- gsub("</i>", "", avatar_slo)
avatar_slo <- gsub("-->", "", avatar_slo)
avatar_slo <- gsub("\\b[0-9:,]+\\b", "", avatar_slo)
avatar_slo <- gsub("\r\n", "", avatar_slo)
cat(avatar_slo)

#if you haven't downloaded the model yet, run the code line below:
# model_slv <- udpipe_download_model(language = "slovenian")

ud_slovene <- udpipe_load_model(model_slv$file_model)

avatar_slo_ud <- udpipe(avatar_slo, object = ud_slovene)
head(avatar_slo_ud)
tail(avatar_slo_ud)

#find all VO and OV patterns with nouns and pronouns separately
avatar_slo_ud$token_id <- as.numeric(avatar_slo_ud$token_id)
summary(avatar_slo_ud$token_id)

avatar_slo_ud$head_token_id <- as.numeric(avatar_slo_ud$head_token_id)
summary(avatar_slo_ud$head_token_id)

avatar_slo_ud <- avatar_slo_ud[complete.cases(avatar_slo_ud$token_id),]

vo_nouns_slo <- length(which(avatar_slo_ud$dep_rel == "obj"&avatar_slo_ud$upos %in% c("NOUN", "PROPN")&avatar_slo_ud$token_id > avatar_slo_ud$head_token_id))
vo_nouns_slo # 179
ov_nouns_slo <- length(which(avatar_slo_ud$dep_rel == "obj"&avatar_slo_ud$upos %in% c("NOUN", "PROPN")&avatar_slo_ud$token_id < avatar_slo_ud$head_token_id))
ov_nouns_slo # 44

vo_pronouns_slo <- length(which(avatar_slo_ud$dep_rel == "obj"&avatar_slo_ud$upos == "PRON"&avatar_slo_ud$token_id > avatar_slo_ud$head_token_id))
vo_pronouns_slo # 61
ov_pronouns_slo <- length(which(avatar_slo_ud$dep_rel == "obj"&avatar_slo_ud$upos == "PRON"&avatar_slo_ud$token_id < avatar_slo_ud$head_token_id))
ov_pronouns_slo # 145

slo_vo <- c(vo_nouns_slo, ov_nouns_slo, vo_pronouns_slo, ov_pronouns_slo)
names(slo_vo) <- c("vo_nouns","ov_nouns", "vo_pronouns", "ov_pronouns")


#Exercise 12: visualize the frequencies in a scatter plot, as shown above.

#... after we have multiple languages, we can put everything together:
vo <- rbind(eng_vo, yor_vo, ita_vo, fin_vo, deu_vo, slv_vo, slo_vo) #add more languages...
vo <- as.data.frame(vo)

##compute and visualize the proportions of Noun + V and Pron + V:
vo$ov_nouns_prop <- vo$ov_nouns/(vo$vo_nouns + vo$ov_nouns)
vo$ov_pronouns_prop <- vo$ov_pronouns/(vo$vo_pronouns + vo$ov_pronouns)
vo$language <- c("eng", "yor", "ita", "fin", "deu", "slv", "slo") #Add more language names!
plot(vo$ov_nouns_prop, vo$ov_pronouns_prop, ylim = c(0, 1), xlim = c(0, 1), type = "n")
text(vo$ov_nouns_prop, vo$ov_pronouns_prop, labels = vo$language, col = c(2:6,9,1))
