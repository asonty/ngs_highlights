library(readr)
library(dplyr)

list_highlights <- function(highlights_index_=NULL, team_=NULL, season_=NULL) {
  teams <- c(
    "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
    "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
    "LA", "LAC", "MIA", "MIN", "NE", "NO", "NYG", "NYJ", 
    "OAK", "PHI", "PIT", "SEA", "SF", "TB", "TEN", "WAS",
    "AFC", "NFC", "LV"
  )
  min_season <- 2017
  max_season <- 2019
  
  if(!is.null(highlights_index_)) {
    highlights_index_ <- readr::read_tsv("https://raw.githubusercontent.com/asonty/ngs_highlights/intro/utils/data/nfl_ngs_highlights_index.tsv")
  }
  
  if (!is.null(team_)) {
    if (team_ %in% teams) {
      highlights_index_ <- highlights_index_ %>% filter(team == team_)
    } else {
      print("error: invalid team name")
      return()
    }
  }
  
  if (!is.null(season_)) {
    if (season_ %in% seq(min_season, max_season, 1)) {
      highlights_index_ <- highlights_index_ %>% filter(season == season_)
    } else {
      print(paste("error: season must be in", min_season, "-", max_season))
      return()
    }
  }
  
  return(highlights_index_)
}

get_play_data <- function(highlights_index_=NULL, playKey_) {
  if(!is.null(highlights_index_)) {
    highlights_index_ <- readr::read_tsv("https://raw.githubusercontent.com/asonty/ngs_highlights/intro/utils/data/nfl_ngs_highlights_index.tsv")
  }
  
  play <- highlights_index_ %>% filter(playKey == playKey_)
  
  play_file <- paste(
    "https://raw.githubusercontent.com/asonty/ngs_highlights/intro/data/",
    play$season, "_",
    play$team, "_",
    play$gameId, "_",
    play$playId, ".tsv", 
    sep=""
  )
  
  play_data <- readr::read_tsv(play_file)
  
  return(play_data)
}