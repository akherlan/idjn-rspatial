# visualisasi -----

library(ggplot2)
library(sf)
library(rnaturalearth)

# loading data -----

w <- ne_countries(
  scale = "medium",
  type = "map_units",
  returnclass = "sf"
  )

head(w[c("name","continent")])

# plot

ggplot() + 
  geom_sf(data = w) +
  theme_bw()

# filter -----

france <- w[w$name == "France",]

ggplot() + 
  geom_sf(data = france) + 
  theme_bw()

# crop -----

europe_cropped <-
  st_crop(europe,
    xmin = -20,
    xmax = 45,
    ymin = 30,
    ymax = 73
  )

# plot

ggplot() +
  geom_sf(data = europe_cropped) +
  coord_sf(expand = FALSE) +
  theme_bw()

# another method, same result

ggplot() +
  geom_sf(data = w) +
  coord_sf(xlim = c(-20, 45), ylim = c(30, 73), expand = FALSE) +
  theme_bw()

# using projection -----

ggplot() +
  geom_sf(data = w) +
  coord_sf(
    crs = st_crs("+proj=moll"),
    xlim = c(-20, 45),
    ylim = c(30, 73),
    expand = FALSE) +
  theme_bw()

# blank, huh?

# let's see globally

ggplot() + 
  geom_sf(data = w) +
  coord_sf(crs = st_crs("+proj=moll")) +
  theme_bw()

# create target projection

target_crs <- "+proj=moll"

# transform

w_trans <- st_transform(w, target_crs)

display_win_wgs84 <- st_sfc(
  st_point(c(-20, 30)),
  st_point(c(45, 73)),
  crs = 4326)

display_win_wgs84

display_win_transform <-
  st_transform(
    display_win_wgs84,
    crs = target_crs
  )

display_win_transform

coord_transform <- st_coordinates(display_win_transform)

# plot

ggplot() +
  geom_sf(data = w_trans) +
  coord_sf(
    xlim = coord_transform[,"X"],
    ylim = coord_transform[,"Y"],
    datum = target_crs,
    expand = FALSE) +
  theme_bw()

# zoom -----

zoom_to <- c(13.38, 52.52)

zoom_level <- 3

# span

lon_span <- 360 / 2^zoom_level
lat_span <- 180 / 2^zoom_level

# boundaries

lon_bounds <-
  c(zoom_to[1] - lon_span / 2, zoom_to[1] + lon_span / 2)
lat_bounds <-
  c(zoom_to[2] - lat_span / 2, zoom_to[2] + lat_span / 2)

# plot

ggplot() +
  geom_sf(data = w) +
  geom_sf(
    data = st_sfc(st_point(zoom_to), crs = 4326),
    color = "red"
  ) +
  coord_sf(
    xlim = lon_bounds,
    ylim = lat_bounds
  ) +
  theme_bw()

# Excercise: plot Indonesia -----

# get info

id <- w[w$name == "Indonesia",]
st_bbox(id)

# transform

to_trans <- st_sfc(
  st_point(c(95.206641, -10.909668)),
  st_point(c(140.976172, 5.907031)), crs = 4326
)

p_transformed <- st_transform(to_trans, target_crs)

p_transformed

# boundaries

xlim_id <- c(9435069, 14082689)
ylim_id <- c(-1345798, 729878.2)

# finally, plot

ggplot() + 
  geom_sf(data = w_trans) +
  coord_sf(xlim = xlim_id, ylim = ylim_id) +
  theme_bw()

# source: -----
#[mantap](https://datascience.blog.wzb.eu/2019/04/30/zooming-in-on-maps-with-sf-and-ggplot2/)