install.packages("wordcloud2")
install.packages('tm',dep= T)
install.packages("pdftools", dep= T)
install.packages("SnowballC", dep=T)
library(SnowballC)
library(pdftools)
library(tm)
library(wordcloud2)

txt <- pdf_text(file.choose()) 
str(txt)    #We can get total number of pages present inside this pdf
txt[5]      #Will give the content of 5th page of the pdf
class(txt)
cat(txt[1:5])  #printing few pages of pdf 

#creating corpus
txt_corpus = VCorpus(VectorSource(txt)) # using tm library to create vector source used to create source object
txt_corpus[7]
#displaying the corpus object using inspect function in tm library
inspect(txt_corpus[[7]])
as.character(txt_corpus[7])
t=lapply(txt_corpus,as.character)
t

# data cleaning

#lower case
txt_corpus_clean = tm_map(txt_corpus,tolower)
txt_corpus_clean <- tm_map(txt_corpus_clean, PlainTextDocument)
lapply(txt_corpus_clean[7],as.character)


#Remove numbers from content
txt_corpus_clean = tm_map(txt_corpus_clean,
                          removeNumbers)
lapply(txt_corpus_clean[7],as.character)

# remove punctuation

txt_corpus_clean = tm_map(txt_corpus_clean,
                          removePunctuation)

# Define custom function to remove punctuation including apostrophes and quotes
removeCustomPunctuation <- function(x) {
  # Remove punctuation marks
  x <- gsub("[[:punct:]]", " ", x)
  # Remove apostrophes and quote symbols
  x <- gsub("[\"']", "", x)
  return(x)
}

# Apply custom transformation to remove punctuation
txt_corpus_clean <- tm_map(txt_corpus_clean, removeCustomPunctuation)
txt_corpus_clean <- tm_map(txt_corpus_clean, PlainTextDocument)
lapply(txt_corpus_clean[7],as.character)


#remove whitespace
txt_corpus_clean = tm_map(txt_corpus_clean,stripWhitespace)
lapply(txt_corpus_clean[8],as.character)

#remove stopwords
txt_corpus_clean = tm_map(txt_corpus_clean, removeWords, c(stopwords('en'), "will"))
lapply(txt_corpus_clean[8], as.character)

#Remove extra white space
txt_corpus_clean = tm_map(txt_corpus_clean,stripWhitespace)
lapply(txt_corpus_clean[8],as.character)

## stemming

txt_corpus_clean <- tm_map(txt_corpus_clean,stemDocument)
txt_corpus_clean <-tm_map(txt_corpus_clean,stripWhitespace)
lapply(txt_corpus_clean[8],as.character)


dtm <- DocumentTermMatrix(txt_corpus_clean)
dtm =as.matrix(dtm)
View(dtm)
dtm=t(dtm)
occu = rowSums(dtm)
occu
no_occu = sort(occu,decreasing = T)
head(no_occu)


install.packages("RColorBrewer")
library("RColorBrewer")




max_words <- 250 
top_words <- head(no_occu, max_words)

# Plotting wordcloud using wordcloud2
wordcloud2(data = data.frame(word = names(top_words), freq = top_words),
           size = 1.49,               # adjust size of words
           shape = "rectangle",         # shape of word cloud
           color = "random-dark",    # color scheme
           backgroundColor = "white",# background color
           minRotation = -pi/4,      # minimum rotation angle
           maxRotation = pi/4        # maximum rotation angle
)





















