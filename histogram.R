Length <- nchar(readLines("words.txt"))
data <- table(Length)
write.table(data, "histogram.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
