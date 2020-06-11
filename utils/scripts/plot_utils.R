library(ggplot2)
library(readr)
library(patchwork)

fetch_team_colors <- function(team_colors_=NULL, h_team_, a_team_, diverge_=FALSE) {
  team_colors_ <- suppressMessages(readr::read_tsv("https://raw.githubusercontent.com/asonty/ngs_highlights/master/utils/data/nfl_team_colors.tsv"))
  
  h_team_color1 <- team_colors_ %>% filter(teams == h_team_) %>% select(color1) %>% pull()
  h_team_color2 <- team_colors_ %>% filter(teams == h_team_) %>% select(color2) %>% pull()
  a_team_color1 <- team_colors_ %>% filter(teams == a_team_) %>% select(color1) %>% pull()
  a_team_color2 <- team_colors_ %>% filter(teams == a_team_) %>% select(color2) %>% pull()
  
  if (diverge_ == TRUE) {
    h_team_color1_family <- team_colors_ %>% filter(teams == h_team_) %>% select(color1_family) %>% pull()
    a_team_color1_family <- team_colors_ %>% filter(teams == a_team_) %>% select(color1_family) %>% pull()
    
    if (h_team_color1_family == a_team_color1_family) {
      a_team_color1 <- team_colors_ %>% filter(teams == a_team_) %>% select(color2) %>% pull()
      a_team_color2 <- team_colors_ %>% filter(teams == a_team_) %>% select(color1) %>% pull()
    }
  }
  
  return(c(h_team_color1, h_team_color2, a_team_color1, a_team_color2))
}

plot_field <- function(field_color="#a4c3b2", line_color = "#ffffff") {
  field_height <- 160/3
  field_width <- 120
  
  field <- ggplot() +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 13, hjust = 0.5),
      plot.subtitle = element_text(hjust = 1),
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

plot_play_frame <- function(play_data_, frame_, velocities_=F, voronoi_=F, caption_=T) {
  
  if(is.null(play_data_)) {
    print("error: need to provide play data")
    return()
  }
  if(is.null(frame_)) {
    print("error: need to provide frame of play to visualize")
    return()
  }
  
  # * get play metadata ----
  play_desc <- play_data_$playDescription %>% .[1]
  play_dir <- play_data_$playDirection %>% .[1]
  yards_togo <- play_data_$yardsToGo %>% .[1]
  los <- play_data_$absoluteYardlineNumber %>% .[1]
  togo_line <- if(play_dir=="left") los-yards_togo else los+yards_togo
  first_frame <- play_data_ %>%
    filter(event == "line_set") %>% 
    distinct(frame) %>% 
    slice_max(frame) %>% 
    pull()
  final_frame <- play_data %>% 
    filter(event == "tackle" | event == "touchdown" | event == "out_of_bounds") %>% 
    distinct(frame) %>% 
    slice_max(frame) %>% 
    pull() + 10
  
  # * separate player and ball tracking data ----
  player_data <- play_data_ %>% 
    filter(frame == frame_) %>% 
    select(frame, homeTeamFlag, teamAbbr, displayName, jerseyNumber, position, positionGroup,
           x, y, s, o, dir, event) %>% 
    filter(displayName != "ball")
  ball_data <- play_data_ %>% 
    filter(frame == frame_) %>% 
    select(frame, homeTeamFlag, teamAbbr, displayName, jerseyNumber, position, positionGroup,
           x, y, s, o, dir, event) %>% 
    filter(displayName == "ball")
  
  # * get team details ----
  h_team <- play_data_ %>% filter(homeTeamFlag == 1) %>% distinct(teamAbbr) %>% pull()
  a_team <- play_data_ %>% filter(homeTeamFlag == 0) %>% distinct(teamAbbr) %>% pull()
  team_colors <- fetch_team_colors(h_team_ = h_team, a_team_ = a_team)
  h_team_color1 <- team_colors[1]
  h_team_color2 <- team_colors[2]
  a_team_color1 <- team_colors[3]
  a_team_color2 <- team_colors[4]
  
  # * compute velocity components ----
  #  velocity angle in radians
  player_data$dir_rad <- player_data$dir * pi / 180
  
  #  velocity components
  player_data$v_x <- sin(player_data$dir_rad) * player_data$s
  player_data$v_y <- cos(player_data$dir_rad) * player_data$s
  
  # * create plot ----
  if (voronoi_ == T) {
    div_team_colors <- fetch_team_colors(h_team_ = h_team, a_team_ = a_team, diverge_ = T)
    
    colors_df <- tibble(a = div_team_colors[1], b = div_team_colors[3])
    colnames(colors_df) <- c(h_team, a_team)
    
    play_frame_plot <- plot_field(field_color = "white", line_color = "#343a40") +
      geom_voronoi_tile(
        data = player_data %>% filter(x >= 0, x <= 120, y >= 0, y <= 160/3), 
        bound = c(0, 120, 0, 160/3),
        mapping = aes(x = x, y = y, fill = teamAbbr, group = -1L),
        colour = "white",
        size = 0.5,
        alpha = 0.5
      ) +
      scale_fill_manual(values = colors_df, name = "Team")
  } else {
    play_frame_plot <- plot_field()
  }
  
  play_frame_plot <- play_frame_plot +
    # line of scrimmage
    annotate(
      "segment",
      x = los, xend = los, y = 0, yend = 160/3,
      colour = "#0d41e1"
    ) +
    # 1st down marker
    annotate(
      "segment",
      x = togo_line, xend = togo_line, y = 0, yend = 160/3,
      colour = "#f9c80e"
    )
  
  if (velocities_ == T) {
    play_frame_plot <- play_frame_plot +
      # away team velocities
      geom_segment(
        data = player_data %>% filter(teamAbbr == a_team),
        mapping = aes(x = x, y = y, xend = x + v_x, yend = y + v_y),
        colour = a_team_color1, size = 1, arrow = arrow(length = unit(0.01, "npc"))
      ) + 
      # home team velocities
      geom_segment(
        data = player_data %>% filter(teamAbbr == h_team),
        mapping = aes(x = x, y = y, xend = x + v_x, yend = y + v_y),
        colour = h_team_color1, size = 1, arrow = arrow(length = unit(0.01, "npc"))
      ) 
  }
  
  play_frame_plot <- play_frame_plot +
    # away team locs and jersey numbers
    geom_point(
      data = player_data %>% filter(teamAbbr == a_team),
      mapping = aes(x = x, y = y),
      fill = "#ffffff", color = a_team_color2,
      shape = 21, alpha = 1, size = 6
    ) +
    geom_text(
      data = player_data %>% filter(teamAbbr == a_team),
      mapping = aes(x = x, y = y, label = jerseyNumber),
      color = a_team_color1, size = 3.5, #family = "mono"
    ) +
    # home team locs and jersey numbers
    geom_point(
      data = player_data %>% filter(teamAbbr == h_team),
      mapping = aes(x = x, y = y),
      fill = h_team_color1, color = h_team_color2,
      shape = 21, alpha = 1, size = 6
    ) +
    geom_text(
      data = player_data %>% filter(teamAbbr == h_team),
      mapping = aes(x = x, y = y, label = jerseyNumber),
      color = h_team_color2, size = 3.5, #family = "mono"
    ) +
    # ball
    geom_point(
      data = ball_data,
      mapping = aes(x = x, y = y),
      fill = "#935e38", color = "#d9d9d9",
      shape = 21, alpha = 1, size = 4
    ) +
    NULL
  
  play_frame_plot <- play_frame_plot +
    labs(
      subtitle = paste("Frame: ", frame_)
    )
  
  if (caption_ == T) {
    play_frame_plot <- play_frame_plot +
      labs(
        caption = "Source: NFL Next Gen Stats"
      )
  }
  
  return(play_frame_plot)
}

plot_play_sequence <- function(play_data_, first_frame_, final_frame_, n_=9, velocities_=F, voronoi_=F) {
  if(is.null(play_data_)) {
    print("error: need to provide play data")
    return()
  }
  if(is.null(first_frame_)) {
    print("error: need to provide first frame of play to visualize")
    return()
  }
  if(is.null(final_frame_)) {
    print("error: need to provide final frame of play to visualize")
    return()
  }
  if(final_frame_ <= first_frame_) {
    print("error: need to provide frames in proper order")
    return()
  }
  
  frames <- round(seq(first_frame_, final_frame_, by = (final_frame_-first_frame_)/(n_-1)))
  play_frames <- vector(mode = "list", length = n_)
  
  for(i in 1:n_) {
    play_frames[[i]] <- plot_play_frame(play_data_, frame_ = frames[i], velocities_, voronoi_, caption_ = F)
  }
  
  play_sequence_plot <- wrap_plots(play_frames, ncol = 1) + 
    plot_annotation(
      caption = "Source: NFL Next Gen Stats",
      theme = theme(
        legend.position = 'top',
      )
    ) + 
    plot_layout(
      guides = "collect"
    )
  
  return(play_sequence_plot)
}





















