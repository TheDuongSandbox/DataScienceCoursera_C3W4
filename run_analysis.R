require(dplyr)
require(memisc)

dataDir <- 'data'
outputDir <- 'output'

activity_info <- read.delim(file.path(dataDir, 'activity_labels.txt'), col.names = c('ActivityId', 'Activity'), header = FALSE, sep = '')
feature_info <- read.delim(file.path(dataDir, 'features.txt'), col.names = c('FeatureId', 'Feature'), header = FALSE, sep = '')

getData <- function(dataName, dataFolder = dataDir) {
  getFilePath <- function(fileName) {
    return(file.path(dataFolder, dataName, fileName))
  }
  
  subjects <- read.delim(getFilePath(paste0('subject_', dataName, '.txt')), col.names = c('SubjectId'), header = FALSE, sep = '')
  
  activities <- read.delim(getFilePath(paste0('y_', dataName, '.txt')), col.names = c('ActivityId'), header = FALSE, sep = '') %>% 
    left_join(activity_info, by = 'ActivityId') %>% 
    dplyr::select(Activity)
  
  # Read the measurement data and take only the mean and standard deviation data
  measurements <- read.delim(getFilePath(paste0('X_', dataName, '.txt')), col.names = feature_info[,2], header = FALSE, sep = '') %>%
    dplyr::select(matches('\\.(mean|std)\\.'))
  # Converting the variable names to something more meaningful
  
  return(bind_cols(subjects, activities, measurements))
}

tidyData <- bind_rows(getData('train'), getData('test')) %>% # Bind all rows in the `train` and `test` data set together
  group_by(Activity, SubjectId) %>% # Group them by the `Activity` and `SubjectId` values
  summarise_all(funs(mean)) # Get mean of all the other variables in the dataset

if(!file.exists(outputDir)) {
  dir.create(outputDir)
}

write.table(tidyData, file = file.path(outputDir, 'tidydata.txt'), row.names = FALSE)

tidyData <- within(as.data.set(tidyData), {
  description(Activity) <- 'The activity monitored'
  description(SubjectId) <- 'The ID of the subject'
  
})
Write(codebook(tidyData), file.path(outputDir, 'tidydata.cdbk.txt'))