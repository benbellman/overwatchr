process_datetime <- function(datetime){
  day <- lubridate::day(datetime)
  month <- lubridate::month(datetime)
  year <- lubridate::year(datetime)

  # Setting the season using system time at time of query
  # Based on information from Retail Patch Notes on Dec 10, 2019
  season <- dplyr::case_when(
    datetime < strptime("2020-01-02 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") ~ 19,
    datetime >= strptime("2020-01-02 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") &
      datetime < strptime("2020-03-05 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") ~ 20,
    datetime >= strptime("2020-03-05 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") &
      datetime < strptime("2020-05-07 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") ~ 21,
    datetime >= strptime("2020-05-07 13:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "EST") ~ 22
  )

  tibble::tibble(datetime, day, month, year, season)
}
