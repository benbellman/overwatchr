process_datetime <- function(date_time){
  day <- lubridate::day(date_time)
  month <- lubridate::month(date_time)
  year <- lubridate::year(date_time)

  # change this and update package whenever season changes?
  season <- 19
  # maybe the season is built into data now? soon?

  tibble::tibble(datetime, day, month, year, season)
}
