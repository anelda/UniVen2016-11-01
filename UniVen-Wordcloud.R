# Building a matrix with terms that occurred and their frequency after cleaning up stopwords, punctuation, and whitespace
# This part of the script comes straight from https://deltadna.com/blog/text-mining-in-r-for-term-frequency/
# If you are running R version 3.2.3 a dependency called "slam" cannot be installed
# The workaround on Linux was - http://stackoverflow.com/questions/39885408/dependency-slam-is-not-available-when-installing-tm-package
# sudo apt-get install r-cran-slam
# then install 'tm' normally through install.packages('tm')

install.packages('tm')
library(tm)

# Read in the file with the sticky note content saved as text in text editor such as Notepad++
# Change the filename according to which file you're using - good feedback or feedback for improving
# This script assumes that your file is in your working directory

data <- read.csv("UniVen_improve.txt")

# After the previous step you will have each entry (new lines) as a row in the table
# Essentially we just want one block of text - that is why we use paste and collapse

data_cleaned  <- paste(data[,1], collapse=" ")

# Now we can set up the source and create a corpus
data_source <- VectorSource(data_cleaned)

corpus <- Corpus(data_source)

# We use the multipurpose tm_map function inside tm to do a variety of cleaning tasks

corpus <- tm_map(corpus, content_transformer(tolower))

corpus <- tm_map(corpus, removePunctuation)

corpus <- tm_map(corpus, stripWhitespace)

corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Now we create the document-term matrix

dtm <- DocumentTermMatrix(corpus)

# We can convert our term-document-matrix into a normal matrix as it is easier to work with for small datasets

dtm2 <- as.matrix(dtm)

# We then take the column sums of this matrix, which will give us a named vector

frequency <- colSums(dtm2)

# And now we can sort this vector to see the most frequently used words

frequency <- sort(frequency, decreasing=TRUE)

# Drawing the wordcloud
# First we have to install the packages

install.packages("wordcloud2")
install.packages("RColorBrewer")
library(wordcloud2)
library(RColorBrewer)

words <- names(frequency)

# wordcloud2 needs a dataframe with word frequencies, so we will convert the matrix to a dataframe

df_words  <- as.data.frame(as.table(frequency))

# And finally we can draw the wordcloud

wordcloud2(data = df_words)


