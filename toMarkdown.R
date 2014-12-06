library(knitr)
file <- commandArgs(trailingOnly = TRUE)
print(paste("Converting", file, "to Markdown"))
knit(file)
