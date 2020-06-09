library(readr)
library(dplyr)
library(ggplot2)

highlights_index <- readr::read_tsv("ngs_highlights_index.tsv")

# * create reduced highlight index ----
# red_index <- highlights_index %>% 
#   select(playKey,
#          playDesc = play.playDescription, 
#          team = teamAbbr,
#          season, 
#          week,
#          gameId,
#          playId) %>% 
#   arrange(season, team, week) %>% 
#   mutate(playKey = seq.int(nrow(.))) %>% 
#   readr::write_tsv("./00_ngs_highlights_index.tsv")

# * create team metadata df ----
# teams_metadata <- tibble(
#   teams = c(
#     "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
#     "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
#     "LA", "LAC", "MIA", "MIN", "NE", "NO", "NYG", "NYJ", 
#     "OAK", "PHI", "PIT", "SEA", "SF", "TB", "TEN", "WAS",
#     "AFC", "NFC", "LV"
#   ),
#   color1 = c(
#     "#97233F", "#a71930", "#241773", "#00338D", "#C60C30", "#0B162A", "#fb4f14", "#311D00",
#     "#041E42", "#FB4F14", "#0076b6", "#203731", "#03202f", "#002C5F", "#006778", "#E31837",
#     "#003594", "#0080C6", "#008E97", "#4F2683", "#002244", "#D3BC8D", "#0B2265", "#125740", 
#     "#000000", "#004C54", "#FFB612", "#002244", "#AA0000", "#D50A0A", "#0C2340", "#773141",
#     "#D50A0A", "#013369", "#000000"
#   ),
#   color1_family = c(
#     "red", "red", "blue", "blue", "light_blue", "blue", "red", "black",
#     "blue", "red", "light_blue", "green", "blue", "blue", "green", "red",
#     "blue", "light_blue", "green", "blue", "blue", "yellow", "blue", "green", 
#     "black", "green", "yellow", "blue", "red", "red", "blue", "red",
#     "red", "blue", "black"
#   ),
#   color2 = c(
#     "#000000", "#000000", "#000000", "#C60C30", "#101820", "#c83803", "#000000", "#ff3c00",
#     "#869397", "#002244", "#B0B7BC", "#FFB612", "#A71930", "#A2AAAD", "#D7A22A", "#FFB81C",
#     "#ffd100", "#FFC20E", "#FC4C02", "#FFC62F", "#C60C30", "#101820", "#a71930", "#000000", 
#     "#A5ACAF", "#A5ACAF", "#101820", "#69BE28", "#B3995D", "#34302B", "#4B92DB", "#FFB612",
#     "#A5ACAF", "#A5ACAF", "#A5ACAF"
#   )
# ) %>% 
#   write_tsv("./team_colors.tsv")


filter_highlights <- function(highlights_index, team_=NULL, season_=NULL) {
  teams <- c(
    "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
    "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
    "LA", "LAC", "MIA", "MIN", "NE", "NO", "NYG", "NYJ", 
    "OAK", "PHI", "PIT", "SEA", "SF", "TB", "TEN", "WAS",
    "AFC", "NFC", "LV"
    )
  min_season <- 2017
  max_season <- 2019
  
  if (!is.null(team_)) {
    if (team_ %in% teams) {
      highlights_index <- highlights_index %>% filter(team == team_)
    } else {
      print("error: invalid team name")
      return()
    }
  }
  
  if (!is.null(season_)) {
    if (season_ %in% seq(min_season, max_season, 1)) {
      highlights_index <- highlights_index %>% filter(season == season_)
    } else {
      print(paste("error: season must be in", min_season, "-", max_season))
      return()
    }
  }
  
  return(highlights_index)
}

get_play_data <- function(highlights_index, playKey_) {
  play <- highlights_index %>% filter(playKey == playKey_)
  
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

plot_field <- function(field_color="#52b788", line_color = "#ffffff") {
  field_height <- 160/3
  field_width <- 120
  
  field <- ggplot() +
    theme_minimal() +
    theme(
      # plot.title = element_text(family = "Lekton", color = "#212529", size = 16, hjust = 0.5),
      legend.position = "bottom",
      # legend.title = element_text(color = "#212529", size = 12, vjust = 1),
      legend.title.align = 1,
      # legend.text = element_text(color = "#343a40", size = 10),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      axis.line = element_blank(),
      # panel.background = element_blank(),
      panel.background = element_rect(fill = field_color, color = "white"),
      panel.border = element_blank(),
      aspect.ratio = field_height/field_width
    ) +
    # major lines
    annotate(
      "segment",
      x = c(0, 0, 0,field_width, seq(10, 110, by=5)),
      xend = c(field_width,field_width, 0, field_width, seq(10, 110, by=5)),
      y = c(0, field_height, 0, 0, rep(0, 21)),
      yend = c(0, field_height, field_height, field_height, rep(field_height, 21)),
      colour = line_color
    ) +
    # hashmarks
    annotate(
      "segment",
      x = rep(seq(10, 110, by=1), 4),
      xend = rep(seq(10, 110, by=1), 4),
      y = c(rep(0, 101), rep(field_height-1, 101), rep(160/6 + 18.5/6, 101), rep(160/6 - 18.5/6, 101)),
      yend = c(rep(1, 101), rep(field_height, 101), rep(160/6 + 18.5/6 + 1, 101), rep(160/6 - 18.5/6 - 1, 101)),
      colour = line_color
    ) +
    # yard numbers
    annotate(
      "text",
      x = seq(20, 100, by = 10),
      y = rep(12, 9),
      label = c(seq(10, 50, by = 10), rev(seq(10, 40, by = 10))),
      size = 7,
      family = "mono",
      colour = line_color, # "#495057",
    ) +
    # yard numbers upside down
    annotate(
      "text",
      x = seq(20, 100, by = 10),
      y = rep(field_height-12, 9),
      label = c(seq(10, 50, by = 10), rev(seq(10, 40, by = 10))),
      angle = 180,
      size = 7,
      family = "mono",
      colour = line_color, 
    )
  
  return(field)
}
plot_field()


filter_highlights(red_index, team_ = "BAL", season_ = 2019)
play_data <- get_play_data(red_index, 242)

first_frame <- play_data %>%
  filter(event == "line_set") %>% 
  distinct(frame) %>% 
  slice_max(frame) %>% 
  pull()

final_frame <- play_data %>% 
  filter(event == "tackle" | event == "touchdown") %>% 
  distinct(frame) %>% 
  slice_max(frame) %>% 
  pull() + 10






