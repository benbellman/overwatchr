process_datetime <- function(datetime){
  day <- day(datetime)
  month <- month(datetime)
  year <- year(datetime)

  # change this and update package whenever season changes?
  season <- 19
  # maybe the season is built into data now? soon?

  as_tibble(data.frame(datetime, day, month, year, season))
}
