#' Load Overwatch data
#'
#' Load data obtained by OWAPI and overwatchr into R sesson for analysis. The returned data describes all play between each OWAPI query, and automatically calculates statistics per 10 minutes.
#'
#' @param profile_name A platform-agnostic profile name (Blizzard BattleTag, Xbox Gamertag, PSN ID).
#' @param hero_table Text string specifying which hero to get data for (see hero_names()), or "profile" to get general profile information.
#' @param season_choice An integer specifying which competitive season to get data for.
#' @param file_path File path to where data has been saved by scrape_ow_data().
#' @return A [tibble][tibble::tibble-package] of records containing stats for competitive play between saved OWAPI queries.
#' @examples
#' load_ow_data("catmaps", "moira", 19, here::here("player_data"))
#' @export
load_ow_data <- function(profile_name, hero_table, season_choice, file_path){
  # strip trailing slash if present
  file_path <- gsub("/$", "", file_path)

  # load selected table
  suppressMessages(
    paste0(file_path, "/", hero_table, ".csv") %>%
      readr::read_csv() %>%
      # keep only records for selected profile
      dplyr::filter(profile == profile_name & season %in% season_choice) %>%
      # drop unneeded columns
      dplyr::select(-c(dplyr::ends_with("kill"), dplyr::ends_with("assist"), dplyr::ends_with("blow"),
                       dplyr::contains("best"), dplyr::contains("most"), dplyr::contains("game"), dplyr::contains("life"),
                       dplyr::ends_with("teleporter_pad_destroyed"), dplyr::ends_with("turret_destroyed"), dplyr::ends_with("elimination"),
                       dplyr::ends_with("date"), dplyr::ends_with("card"), dplyr::ends_with("death"))) %>%
      # add hero column
      dplyr::mutate(hero = hero_table) -> raw_data
  )

  # if table is empty, return an NA value
  if (nrow(raw_data) == 0) return(tibble::tibble())

  # if profile, do something else (create profile module eventually)
  # for now, return raw data without transforming
  if (hero_table == "profile") return(raw_data)

  # else recalculate hero stats (make this a module eventually)

  # split into columns to preserve as is (information, cumulative rates), and columns to re-calulate by day
  as_is <- dplyr::select(raw_data, profile, platform, hero, datetime, day, month, year, season, dplyr::contains("percentage"), dplyr::contains("accuracy"))
  re_calc <- raw_data[, names(raw_data) %in% names(as_is) == F]

  # fill in empty values of re_calc with 0
  re_calc[ is.na(re_calc) ] <- 0

  # return re_calc as a difference from the previous row
  mat1 <- as.matrix(re_calc[ 2:nrow(re_calc) ,])
  mat2 <- as.matrix(re_calc[ 1:(nrow(re_calc)-1) ,])
  diffs <- mat1 - mat2

  # assemble and return the first step of processed data
  dplyr::bind_rows(dplyr::slice(re_calc, 1), tibble::as_tibble(diffs)) %>%
    dplyr::bind_cols(as_is, .) %>%
    # re-do time in increments of 10 minutes, calculate time ratios
    dplyr::mutate(time_played_10m = time_played*6,
                  time_spent_on_fire_10m = time_spent_on_fire*6,
                  objective_time_10m = objective_time*6,
                  on_fire_time_ratio = time_spent_on_fire / time_played,
                  objective_time_ratio = objective_time / time_played) -> proc1

  # re-scale all count variables by time played
  non_time_vars <- dplyr::select(proc1[, names(proc1) %in% names(re_calc)], -dplyr::contains("time"))
  scaled <- purrr::map_dfr(non_time_vars, purrr::as_mapper(~ .x / proc1$time_played_10m))
  names(scaled) <- paste0(names(scaled), "_p10")

  # re-assemble data
  output <- dplyr::bind_cols(proc1, scaled)
  # drop rows with no time played and return
  dplyr::filter(output, time_played > 0)
}
