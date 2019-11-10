process_datetime <- function(datetime){
  day <- lubridate::day(datetime)
  month <- lubridate::month(datetime)
  year <- lubridate::year(datetime)

  # change this and update package whenever season changes?
  season <- 19
  # maybe the season is built into data now? soon?

  tibble::tibble(datetime, day, month, year, season)
}
