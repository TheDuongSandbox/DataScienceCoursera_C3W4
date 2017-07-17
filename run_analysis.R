require(dplyr)

activity_info <- read.delim('data/activity_labels.txt', col.names = c('ActivityId', 'Activity'), header = FALSE, sep = '')
feature_info <- read.delim('data/features.txt', col.names = c('FeatureId', 'Feature'), header = FALSE, sep = '')

getData <- function(dataName, dataFolder = 'data') {
  getFilePath <- function(fileName) {
    return(file.path(dataFolder, dataName, fileName))
  }
  
  subjects <- read.delim(getFilePath(paste0('subject_', dataName, '.txt')), col.names = c('SubjectId'), header = FALSE, sep = '')
  
  activities <- read.delim(getFilePath(paste0('y_', dataName, '.txt')), col.names = c('ActivityId'), header = FALSE, sep = '') %>% 
    left_join(activity_info, by = 'ActivityId') %>% 
    select(Activity)
  
  measurements <- read.delim(getFilePath(paste0('X_', dataName, '.txt')), col.names = feature_info[,2], header = FALSE, sep = '') %>%
    select(matches('\\.(mean|std)\\.'))
  
  return(bind_cols(subjects, activities, measurements))
}

tidyData <- bind_rows(getData('train'), getData('test')) %>% # Bind all rows in the `train` and `test` data set together
  group_by(Activity, SubjectId) %>% # Group them by the `Activity` and `SubjectId` values
  summarise_all(funs(mean)) # Get mean of all the other variables in the dataset

write.table(tidyData, file = 'tidyData.txt', row.names = FALSE)