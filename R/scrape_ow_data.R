#' Scrape OWAPI
#'
#' Obtain and save current competitive season statistics for a public Overwatch profile.
#'
#' @param profile_name Account name of public Overwatch profile (Blizzard BattleTag, Xbox Gamertag, PSN ID). If using a Blizzard BattleTag, "#" will be replaced with "-" in saved data.
#' @param platform Profile's gaming platform. One of c("pc", "xbl", "psn"). Nintendo Switch not yet supported.
#' @param file_path File path to save/append all hero-specific data files.
#' @return No value returned in R session.
#' @examples
#' scrape_ow_data("catmaps", "psn", here::here("player_data"))
#' @export
scrape_ow_data <- function(profile_name, platform, file_path){
  profile_name <- gsub("\\#", "\\-", profile_name)
  save_owapi_data(owapi_query(profile_name, platform), file_path)
}
