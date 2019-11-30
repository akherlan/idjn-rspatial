# DOWNLOAD OSM DATA -----

library(osmdata)
library(tidyr)
library(sf)
library(ggmap)

# available key -----

head(available_features(), 10)
available_tags("amenity")
available_tags("highway")

# query -----

bb_palembang <- getbb("Palembang")
p <- opq(bb_palembang, 25)
query_palembang <-
  add_osm_feature(p, "amenity", "hospital")

str(query_palembang)

# query using pipe method

query_palembang <-
  getbb("Palembang") %>% 
  opq(timeout = 25) %>% 
  add_osm_feature(key = "amenity", value = "hospital")

str(rs_palembang)

# get data -----

rs_palembang <- osmdata_sf(query_palembang)

print(rs_palembang)

as_tibble(rs_palembang$osm_points)

# visualize -----

palembang_map <- 
  get_map(bb_palembang, maptype = "watercolor")

# type & struktur

class(palembang_map)
print(palembang_map)

# look

ggmap(palembang_map)

# plot

ggmap(palembang_map) +
  geom_sf(
    data = rs_palembang$osm_points, 
    inherit.aes = FALSE, 
    colour = "#030e3f",  # border
    fill = "#5391ba",    # fill
    alpha = 0.5,         # transparency
    size = 3,            # size
    shape = 21           # type
  ) +
  labs(x = "", y = "")

# TASK: RS Bandung -----

# bbox

bb_bandung <- getbb("Bandung")

bb_bandung

# own create bbox

# m <- matrix(c(1,2,3,4), ncol = 2, byrow = TRUE)
# rownames(m) <- c("x", "y")
# names(m) <- c("min", "max")

# query

q <- bb_bandung %>% 
  opq(timeout = 25) %>%
  add_osm_feature("amenity", "hospital")

# get data

bandung <- osmdata_sf(q)

bandung

# plot

ggplot(bandung$osm_points) +
  geom_sf(
    colour = "#08519c",
    fill = "#08306b",
    alpha = 0.4,
    size = 2,
    shape = 21
  ) +
  theme_void()

# export to shp for analysis in qgis

st_write(bandung$osm_points, "data/rs_bandung.shp")

# source: -----
# [link](https://dominicroye.github.io/en/2018/accessing-openstreetmap-data-with-r/)