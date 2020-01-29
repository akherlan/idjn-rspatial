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
class(rs)   # simple feature
typeof(rs)
str(rs)

# 3. Exploring data ----
print(rs)
head(rs)
tail(rs)

rs[,1:2]
rs[rs$REMARK=="Rumah Sakit Khusus",]
head(rs[rs$REMARK=="Rumah Sakit Khusus",]$ALAMAT, 10)

# basic R plot
library(sf)
st_geometry(rs) # fungsi-fungsi
st_bbox(rs)     # fungsi-fungsi
st_crs(rs)      # fungsi-fungsi

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
    colour = "red", # bisa kode hexa
    alpha = 0.3
  ) +
  theme_void()

# perlu yang interaktif?
library(mapview)
mapview(rs)
mapview(
  x = rs, 
  col.region = "#2f6f40", 
  color = "gray", 
  cex = 4, 
  layer = "Rumah Sakit",
  label = rs$NAMOBJ
)

# unduh data dari osm:
# buka script/get-osm-data-rs.R
# muat data rs jakarta
rsjak <- readRDS("data/data_rs_jakarta.rds")

# muat peta dari format Esri shapefile
jakarta <- read_sf("data/peta/jakarta.shp")

# plot rs jakarta ke peta
plot(st_geometry(jakarta), graticule = TRUE, axes = TRUE)
ggplot() +
  geom_sf(data = jakarta) +
  geom_sf(data = rsjak) +
  theme_bw()

# 4. Analisis ----
# perbandingan crs, proyeksi, unit
st_bbox(rsjak)
st_bbox(jakarta)

st_crs(rsjak)
st_crs(jakarta)

# mengubah crs, memiliki unit = meter
rsjak.m <- st_transform(rsjak, crs = 32748)

ggplot() +
  geom_sf(data = jakarta) +
  geom_sf(data = rsjak.m) +
  theme_bw() +

# kota pontianak
pontianak <- read_sf("data/peta/pontianak_kota.shp") # data
st_crs(pontianak)
st_crs(rs)

crs.idn <- 23838 # ambil dari web epsg.io

pontianak.idn <- st_transform(pontianak, crs.idn)
rs.idn <- st_transform(rs, crs.idn)

st_crs(pontianak.idn)
st_crs(rs.idn)

# plot rs ke peta pontianak
pontianak %>% 
  st_geometry() %>% 
  plot(graticule = TRUE, axes = TRUE)

aoi <- st_bbox(pontianak.idn)

ggplot() +
  geom_sf(data = pontianak.idn) +
  geom_sf(
    data = rs.idn,
    col = "red",
    alpha = 0.4
  ) +
  coord_sf(xlim = as.vector(aoi)[c(1,3)], 
           ylim = as.vector(aoi)[c(2,4)]) +
  ggthemes::theme_map()

# kategori area layanan kesehatan
dekat <- st_buffer(st_geometry(rs.idn), dist = 1000)
sedang <- st_buffer(st_geometry(rs.idn), dist = 2000)
jauh <- st_buffer(st_geometry(rs.idn), dist = 3000)

# plot area layanan
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

# perbandingan:
# pontianak
ggplot() +
  geom_sf(data = pontianak) +
  ggthemes::theme_map() +
  geom_sf(data = st_crop(st_geometry(sedang), aoi),
          fill = "green", size = 0,
          alpha = 0.1) +
  geom_sf(data = st_crop(rs.idn, aoi), col = "#2f6f40", size = 0.7)

# jakarta
ggplot() +
  geom_sf(data = jakarta) +
  ggthemes::theme_map() +
  geom_sf(data = st_geometry(st_buffer(rsjak.m, 2000)),
          fill = "green", size = 0,
          alpha = 0.1) +
  geom_sf(data = rsjak.m, col = "#2f6f40", size = 0.7)
