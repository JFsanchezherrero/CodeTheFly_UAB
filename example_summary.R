

###
file_name = "C:/Users/josed/Google Drive JF Bioinformatics/teaching/UAB/2023_24/1er Semestre/Bioinformatica - G. Genetica/practicas/P8/tresults/example_Tresults.tsv"
example_res = read.csv(file_name, sep="\t", stringsAsFactors = TRUE)

head(example_res)
View(example_res)

dim(example_res)
summary(example_res)

numeric_cols <- sapply(example_res, is.numeric)

head(example_res[,!numeric_cols])

colnames(example_res[,!numeric_cols])

example_res$combination

levels(example_res$combination)

file_name2 = "C:/Users/josed/Google Drive JF Bioinformatics/teaching/UAB/2023_24/1er Semestre/Bioinformatica - G. Genetica/practicas/P8/tresults/all_results.tsv"
example_res2 = read.csv(file_name2, 
                        sep="\t", stringsAsFactors = TRUE)
summary(example_res2)

library(ggplot2)
table(example_res2[,c('strain', 'combination')])

library(reshape2)
summary_data = reshape2::melt(table(example_res2[,c('strain', 'combination')]))

ggplot2::ggplot(data=summary_data, aes(x=strain, y=value, fill=combination)) + 
  geom_bar(position="fill", stat="identity")

sort(table(example_res$left_repeat))



















