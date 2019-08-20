# ggturtle

Use ggplot2 to draw like turtle in LOGO language.

## Installation

```{r}
if (!require(devtools)) install.packages("devtools")
devtools::install_github("yanlinlin82/ggturtle")
```

## Usage Example

```{r}
library(ggturtle)

turtle_init() %>%
  go_forward(100) %>%
  turn_right(120) %>%
  go_forward(100) %>%
  turn_right(120) %>%
  go_forward(100) %>%
  turtle_draw()

a <- turtle_init()
for (i in 1:8) {
  a <- a %>% go_forward(1000) %>% turn_right(135)
}
a %>% turtle_draw("RP 8 [ FW 100, TR 135 ]")
```
