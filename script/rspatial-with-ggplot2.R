# sf + ggplot2 + ggpatial -----

# load library -----
library(sf)
library(ggplot2)
  theme_set(theme_bw())
library(rnaturalearth)

# get data
w <- ne_countries(scale = "medium", returnclass = "sf")

# plot
ggplot(data = w) + geom_sf()

# add title, subtitle, axis -----
ggplot(data = w) + 
  geom_sf() +
  xlab("Longitude") + 
  ylab("Latitude") +
  ggtitle(
    "Peta Dunia",
    subtitle = 
      paste0("(", length(unique(w$name)), " negara)")
  )

# using color -----
ggplot(data = w) +
  geom_sf(
    color = "black",  # border
    fill = "lightgreen"   # fill
  )

ggplot(w) +
  geom_sf(aes(fill = pop_est)) +
  scale_fill_viridis_c(option = "plasma", trans = "sqrt")

# projection <- coord_sf() -----
# available for SRID and EPSG
laea = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs"

ggplot(w) +
  geom_sf() +
  coord_sf(crs = laea)

ggplot(w) +
  geom_sf() +
  coord_sf(crs = "+init=epsg:3035")

ggplot(w) +
  geom_sf() +
  coord_sf(crs = st_crs(3035))

# limit and expand map -----
ggplot(w) +
  geom_sf() +
  coord_sf(
    xlim = c(-102.15, -74.12),
    ylim = c(7.65, 33.97),
    expand = FALSE
  )

# add north arrow & scalebar using ggspatial -----
library(ggspatial)
ggplot(w) +
  geom_sf() +
  annotation_scale(
    location = "bl",
    width_hint = 0.5
  ) +
  annotation_north_arrow(
    location = "bl",
    which_north = "true",
    pad_x = unit(0.75, "in"),
    pad_y = unit(0.5, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  coord_sf(
    xlim = c(-102.15, -74.12),
    ylim = c(7.65, 33.97)
  )

# add names geom_text + annotate -----
library(sf)

w_points <- st_centroid(w)
w_points <- cbind(w, st_coordinates(st_centroid(w$geometry)))

# plot
ggplot(w) +
  geom_sf() +
  geom_text(
    data = w_points,
    aes(
      x = X, y = Y, label = name
    ),
    color = "darkblue",
    fontface = "bold",
    check_overlap = FALSE
  ) +
  annotate(
    geom = "text",
    x = -90, 
    y = 26,
    label = "Gulf of Mexico",
    fontface = "italic",
    color = "grey22",
    size = 6
  ) +
  coord_sf(
    xlim = c(-102.15, -74.12),
    ylim = c(7.65, 33.97),
    expand = FALSE
  )

# Custom looks and themes -----

ggplot(w) +
  geom_sf(fill = "antiquewhite") +
  geom_text(
    data = w_points,
    aes(
      x = X, y = Y, label = name
    ),
    color = "darkblue",
    fontface = "bold",
    check_overlap = FALSE
  ) +
  annotate(
    geom = "text",
    x = -90, 
    y = 26,
    label = "Gulf of Mexico",
    fontface = "italic",
    color = "grey22",
    size = 6
  ) +
  annotation_scale(
    location = "bl",
    width_hint = 0.5
  ) +
  annotation_north_arrow(
    location = "bl",
    which_north = TRUE,
    pad_x = unit(0.75, "in"),
    pad_y = unit(0.5, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  coord_sf(
    xlim = c(-102.15, -74.12),
    ylim = c(7.65, 33.97),
    expand = FALSE
  ) +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Map of the Gulf of Mexico and the Caribbean Sea") +
  theme(
    panel.grid.major = element_line(
      color = gray(0.5), 
      linetype = "dashed",
      size = 0.5
    ),
    panel.background = element_rect(
      fill = "aliceblue"
    )
  )

# Source: -----
# [Part 1](https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html)