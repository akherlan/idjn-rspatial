library(osmdata)
library(sf)

available_tags("amenity")

key = "amenity"
tag = "hospital"

# tentukan batas Jakarta
bbox.jak <- getbb("jakarta")

# bbox manual, contoh: Jawa
xmin = 105
xmax = 115
ymin = -9
ymax = -6.5

bbox.java <- matrix(c(xmin, xmax, ymin, ymax), ncol = 2, byrow = TRUE)
row.names(bbox_java) <- c("x", "y")
colnames(bbox_java) <- c("min", "max")

bbox.java

# buat query osmdata
q <-
  bbox.jak %>% 
  opq(timeout = 250) %>% 
  add_osm_feature(key = key, value = tag)

# ambil data dari osm dalam format sf
rs.jak <- osmdata_sf(q)

# untuk perbandingan data (credit to: Open Data Jakarta)
rsdatjak <- read.csv("data/rs_data_jakarta.csv", stringsAsFactors = F)

nrow(rs.jak$osm_polygons)
nrow(rs.jak$osm_points)
nrow(rsdatjak)

# subset data dari osm
rsosmjak <- st_centroid(rs.jak$osm_polygons)

# mengamati data
mapview(rsosmjak)
as.factor(rsosmjak$addr.city)
rsjak <- dplyr::filter(rsosmjak, addr.city == "DKI Jakarta")
nrow(rsjak)
rsjakna <- dplyr::filter(rsosmjak, is.na(addr.city))
mapview(rsjakna)

# plot data
library(ggplot2)
ggplot(rsjak) +
  geom_sf(
    color = "blue",
    fill = "blue",
    alpha = .5,
    size = 1,
    shape = 21
  ) +
  coord_sf() +
  theme_void()

# simpan data
saveRDS(rsjak, "data/data_rs_jakarta.rds")
st_write(rsjak, "data/shp/rs_jak_osm.shp")
