### NOTES

# need to re-factor this to accept a location argument that
# lets the user decide where to save the data
# eventually, I want it to support databases

# need a function to do a specific test for valid file path / data (or if its a database connection)

# need a function to confirm everything went ok before overwriting data


# main function for saving data from queries
save_owapi_data <- function(output, file_path){
  suppressMessages(

    # if no files where data gets saved, create new ones
    if (length(file_path) == 0){
      for (a in c("profile", hero_names())){
        readr::write_csv(output[[a]], paste0(file_path, "/", a, ".csv"))
      }
      # otherwise, append all elements in output to their respective csv files
    } else {

      for (a in c("profile", hero_names())){
        # check that table for hero exists, since new hero could have been released
        if(a %in% list.files(paste0(file_path, "/", a, ".csv"))){
          table <- suppressMessages(readr::read_csv(paste0(file_path, "/", a, ".csv")))
          table <- dplyr::bind_rows(table, output[[a]])
          readr::write_csv(table, paste0(file_path, "/", a, ".csv"))
          # if no table exists, simply write the output to start a new one
        } else {
          readr::write_csv(output[[a]], paste0(file_path, "/", a, ".csv"))
        }
      }
    }
  )
}
