#words.txt:
#	Rscript -e 'download.file("https://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'

#words.txt: /usr/share/dict/words
#	cp $< $@

all: report.html

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

#clean up files
clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html

#create word.txt file from local dictionary
words.txt: /usr/share/dict/words
	cp /usr/share/dict/words words.txt

#create data of word length frequencies from word.txt file for histogram data
histogram.tsv: histogram.r words.txt
	Rscript $<

#create histogram from histogram data
histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data = read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

#create html report of the findings
report.html: report.rmd histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")'