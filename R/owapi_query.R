owapi_query <- function(profile, platform){
  # set date and time of query from system
  datetime <- Sys.time()

  # query the API and parse JSON data
  owapi_url <- paste0("https://owapi.net/api/v3/u/", profile, "/blob?platform=", platform)
  api_obj <- rjson::fromJSON(file = owapi_url)

  # create row of general account stats from competitive play
  overall_stats <- api_obj$any$stats$competitive$overall_stats
  overall_stats[["profile"]] <- profile
  overall_stats[["platform"]] <- platform
  overall_stats[purrr::map_lgl(overall_stats, is.null)] <- NA
  overall_stats <- overall_stats %>%
    data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::select(tank_comprank, damage_comprank, support_comprank, games, wins, endorsement_level, prestige, endorsement_sportsmanship, ties, endorsement_shotcaller, win_rate, endorsement_teammate, losses, level, profile, platform) %>%
    dplyr::bind_cols(process_datetime(datetime))
  game_stats <- api_obj$any$stats$competitive$game_stats %>%
    data.frame() %>%
    tibble::as_tibble()
  profile_stats <- dplyr::bind_cols(overall_stats, game_stats)

  # initialize list for exporting different table rows
  output <- list(profile = profile_stats)

  # create row of stats for each hero in competitive play
  for(a in hero_names()){
    hero_stats <- api_obj$any$heroes$stats$competitive[[a]]$general_stats

    # check if object is empty, if it is, convert to empty list
    if (is.null(hero_stats)){
      hero_stats <- tibble::tibble()
      output[[a]] <- hero_stats
      next()
    }

    hero_stats[["profile"]] <- profile
    hero_stats[["platform"]] <- platform

    hero_stats <- hero_stats %>%
      data.frame() %>%
      tibble::as_tibble() %>%
      dplyr::bind_cols(process_datetime(datetime))

    output[[a]] <- hero_stats
  }

  # convert all factors to character/numeric
  suppressWarnings(
    for (a in names(output)){
      for (b in names(output[[a]])){
        f <- output[[a]][[b]]
        # continue if column is not a factor
        if (class(f) != "factor"){
          next()
          # if it is a factor, determine if data is numeric or character and convert
        } else {
          output[[a]][[b]] <- factor_converter_1L(f)
        }
      }
    }
  )

  # return list of all rows
  output
}
