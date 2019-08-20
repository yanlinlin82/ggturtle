#' Use ggplot2 to draw like turtle in LOGO language.
#'
#' @name ggturtle
#' @aliases turtle_init, go_to, go_home, go_forward, go_back, pen_on, pen_off, turn_left, turn_right, set_size, set_color, set_alpha, turtle_draw
#' @examples
#' library(ggturtle)
#'
#' a <- turtle_init(); for (i in 1:8) { a <- a %>% go_forward(100) %>% turn_right(135) }; a %>% turtle_draw("RP 8 [ FW 100, TR 135 ]")

#' @export
turtle_init <- function() {
  return(tibble(x = 0, y = 0,
                pen = TRUE, theta = pi / 2,
                size = 1, color = "black", alpha = 1))
}

#' @export
go_to <- function(d, x, y) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d <- d[c(1:i, i), ]
  d$x[[i + 1]] <- x
  d$y[[i + 1]] <- y
  return(d)
}

#' @export
go_home <- function(d) {
  return(go_home(d, 0, 0))
}

#' @export
go_forward <- function(d, size) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  return(go_to(d,
               d$x[[i]] + size * cos(d$theta[[i]]),
               d$y[[i]] + size * sin(d$theta[[i]])))
}

#' @export
go_back <- function(d, size) {
  return(go_forward(-size))
}

#' @export
pen_on <- function(d) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$pen[[i]] <- TRUE
  return(d)
}

#' @export
pen_off <- function(d) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$alpha[[i]] <- FALSE
  return(d)
}

#' @export
turn_left <- function(d, angle) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$theta[[i]] = d$theta[[i]] + pi * angle / 180
  return(d)
}

#' @export
turn_right <- function(d, angle) {
  return(turn_left(d, -angle))
}

#' @export
set_size <- function(d, size) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$size[[i]] <- size
  return(d)
}

#' @export
set_color <- function(d, color) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$color[[i]] <- color
  return(d)
}

#' @export
set_alpha <- function(d, alpha) {
  stopifnot(nrow(d) >= 1)
  i <- nrow(d)
  d$alpha[[i]] <- alpha
  return(d)
}

#' @export
turtle_draw <- function(d, title = "", title_offset = .05) {
  a <- cbind(d[-nrow(d), ],
             d[-1, c("x","y")] %>%
               rename(x2 = x, y2 = y)) %>%
    filter(pen)
  a %>%
    ggplot() +
    geom_segment(aes(x = x, y = y, xend = x2, yend = y2,
                     size = size, color = color, alpha = alpha)) +
    geom_text(data = tibble(x = min(a$x), y = max(a$y), label = title),
              aes(x = x, y = y * (1 + title_offset), label = label),
              size = 6, hjust = 0, vjust = 0) +
    scale_color_manual(values = unique(a$color)) +
    scale_size(range = range(a$size)) +
    guides(size = FALSE, color = FALSE, alpha = FALSE) +
    theme_void()
}
