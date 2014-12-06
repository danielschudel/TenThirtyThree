PDF=index.pdf
HTML=$(PDF:%pdf=%html)

all: $(PDF) $(HTML)

%.html: %.md
	@pandoc \
		--include-in-header=header.css \
		--number-sections \
		-o$@ \
		$^ 

%.pdf: %.md
	pandoc -s \
	       -V geometry:paperwidth=11in \
	       -V geometry:paperheight=8.5in \
	       -V geometry:margin=1in \
	       --number-sections \
	       -V geometry:margin=1in \
	       --table-of-contents \
	       --toc-depth=1 \
	       $^ \
	       -o $@

%.md: %.Rmd
	@Rscript toMarkdown.R $^

clean:
	/bin/rm -rf $(PDF) $(HTML) cache figure Plots/*png index.md

.PRECIOUS: %.md
