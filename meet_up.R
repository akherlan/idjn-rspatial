# library yang dibutuhkan
if(!require("sf")) install.packages("sf")
if(!require("dplyr")) install.packages("dplyr")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("mapview")) install.packages("mapview")
if(!require("rnaturalearth")) install.packages("rnaturalearth")
# if(!require("osmdata")) install.packages("osmdata")

# 1. Menyiapkan data ----
rs <- readRDS("data/data.rds")

# 2. Mengenal tipe & struktur data ----
class(rs)
typeof(rs)
str(rs)

# 3. Exploring data ----
print(rs, n = 5)
head(rs)
tail(rs)
rs[,1:2]

# fungsi-fungsi
library(sf)
st_geometry(rs)
st_bbox(rs)

# basic R plot
geomrs <- st_geometry(rs)
plot(st_geometry(rs))
plot(geomrs, pch = 5)

# butuh peta?
library(rnaturalearth)
idn <- ne_countries(
  country = "indonesia", 
  scale = "medium",
  returnclass = "sf"
)

# plot rs ke peta
plot(st_geometry(idn))
plot(geomrs, add = TRUE)

# ggplot2
library(ggplot2)
ggplot() + 
  geom_sf(
    data = idn
  ) +
  geom_sf(
    data = rs,
    colour = "red",
    alpha = 0.3
  ) +
  theme_void()

# perlu yang interaktif?
library(mapview)
mapview(
  x = rs, 
  col.region = "red", 
  color = "gray", 
  cex = 4, 
  layer = "Rumah Sakit"
)

# unduh data dari osm:
# buka script/get-osm-data-rs.R

# muat peta dari format Esri shapefile
pontianak <- read_sf("data/peta/pontianak_kota.shp")
plot(st_geometry(pontianak), graticule = TRUE, axes = TRUE)

bb_pontianak <- st_bbox(pontianak)

library(dplyr)
rs %>% 
  st_crop(bb_pontianak) %>% 
  st_geometry() %>% 
  plot(add = TRUE)

st_crs(rs)
st_crs(pontianak)

crs.idn <- 23838 # ambil dari web epsg.io

rs.idn <- st_transform(rs, crs.idn)
pontianak.idn <- st_transform(pontianak, crs.idn)

st_crs(rs.idn)
st_crs(pontianak.idn)

pontianak %>% 
  st_geometry() %>% 
  plot(graticule = TRUE, axes = TRUE)

st_bbox(rs)
st_bbox(rs.idn)

dekat <- st_buffer(st_geometry(rs.idn), dist = 1000)
sedang <- st_buffer(st_geometry(rs.idn), dist = 2000)
jauh <- st_buffer(st_geometry(rs.idn), dist = 3000)

aoi <- st_bbox(pontianak.idn)

pontianak.idn %>% 
  st_geometry() %>% 
  plot(border = "gray")

rs.idn %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE)

dekat %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE, border = "green")

sedang %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE, border = "blue")

jauh %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE, border = "red")

library(ggplot2)
ggplot() +
  geom_sf(data = pontianak) +
  theme_bw() +
  geom_sf(data = st_crop(st_geometry(sedang), aoi),
          fill = "green",
          alpha = 0.05) +
  geom_sf(data = st_crop(rs.idn, aoi))
