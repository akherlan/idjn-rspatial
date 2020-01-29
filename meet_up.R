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

# 3. Eksplor data ----
print(rs)
head(rs)
tail(rs)

rs[,1:2]
rs[rs$REMARK=="Rumah Sakit Khusus",]
head(rs[rs$REMARK=="Rumah Sakit Khusus",]$NAMOBJ, 10)

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
jakarta <- read_sf("data/peta/jakarta_kota.shp")

# plot rs jakarta ke peta
plot(st_geometry(jakarta), graticule = TRUE, axes = TRUE)
ggplot() +
  geom_sf(data = jakarta) +
  geom_sf(data = rsjak) +
  theme_bw()

# 4. Modifikasi data ----
# sortir dan pilah data
rsjak <- rsjak[rsjak$name != "RSUD Kepulauan Seribu",]

# modifikasi crs, proyeksi, unit
st_bbox(rsjak)
st_bbox(jakarta)

st_crs(rsjak)
st_crs(jakarta)

rsjak.m <- st_transform(rsjak, crs = 32748)

# kita coba plot lagi
ggplot() +
  geom_sf(data = jakarta) +
  geom_sf(data = rsjak.m) +
  theme_bw()

# hilangkan di Tangsel
rsjak.m <- st_intersection(rsjak.m, jakarta)

# final data?
ggplot() +
  geom_sf(data = jakarta) +
  geom_sf(data = rsjak.m) +
  theme_bw()

# 5. Analisis ----
# kategori area layanan kesehatan
dekat <- st_buffer(st_geometry(rsjak.m), dist = 1000)
sedang <- st_buffer(st_geometry(rsjak.m), dist = 2000)
jauh <- st_buffer(st_geometry(rsjak.m), dist = 3000)

# plot area layanan
jakarta %>% 
  st_geometry() %>% 
  plot(border = "gray")

aoi <- st_bbox(jakarta)

rsjak.m %>%
  st_geometry() %>% 
  plot(add = TRUE)

dekat %>%
  st_geometry() %>% 
  plot(add = TRUE, border = "green")

sedang %>%
  st_geometry() %>% 
  plot(add = TRUE, border = "blue")

jauh %>%
  st_geometry() %>% 
  plot(add = TRUE, border = "red")

# Perbandingan:
# Palembang
palembang <- read_sf("data/peta/palembang_kota.shp")
rspal <- readRDS("data/data_rs_palembang.rds")
rspal.m <- st_transform(rspal, crs = 32748)

palembang %>% 
  st_geometry() %>% 
  plot(border = "gray")

layanan <- st_buffer(st_geometry(rspal.m), dist = 2000)
bbox.pal <- st_bbox(palembang)

rspal.m %>%
  st_geometry() %>% 
  plot(add = TRUE)

layanan %>%
  st_geometry() %>% 
  plot(add = TRUE, border = "blue")
