transformNames <- function(names) {
  # Abbreviation patterns
  patterns <- matrix(c(
    '^t', 'Timed', 
    '^f', 'Frequency',
    'Acc', 'Accelerometer',
    'Gyro', 'Gyroscope',
    'Mag', 'Magnitude',
    '\\.mean', '\\.Mean',
    '\\.std', '\\.StandardDevication',
    '(\\w+)\\.(\\w+)', 'The\\2Of\\1', # Move mean and std to the front
    '\\.+(\\w)$', '-\\1', # Add `-` before X/Y/Z
    '\\.+$', '' # Remove trailing dots (.).
    ), ncol = 2, byrow = TRUE)
  # Converting abbreviations back to their final form
  apply(patterns, 1, function(pattern) {
    names <<- sub(pattern[[1]], pattern[[2]], names)
  })
  
  return(names)
}