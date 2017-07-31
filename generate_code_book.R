require(memisc)

tidyData <- within(as.data.set(read.table('output/tidydata.txt', header = TRUE)), {
  description(Activity) <- 'The activity monitored'
  description(SubjectId) <- 'The ID of the subject'
})
# Generate the basic CodeBook.md
Write(codebook(tidyData), 'output/CodeBook.md')