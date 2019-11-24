# Visualisasi Data Spasial dengan R

Materi IDJN meet up 28 Nop 2019 oleh [Andi](https://www.twitter.com/terusterang__)

**TL;DR**

> Menggunakan bahasa R untuk mengetahui keterjangkauan layanan kesehatan (rumah sakit dan puskesmas).

## Pengenalan [#rspatial](https://twitter.com/hashtag/rspatial?src=hashtag_click)

### Representasi Objek Nyata pada Komputer

**1. Simple features** <- diatur oleh GEOS

Menjelaskan bagaimana objek-objek dalam dunia nyata bisa diwakilkan ke dalam komputer, dengan penekanan pada bentuk (geometri) spasial objek tersebut.

- *geometry* menjelaskan tentang bentuk benda/objek di Bumi.
- *attributes* berhubungan dengan sifat-sifatnya (properties) atau keterangan tambahan.

Geometri yang sering digunakan adalah dalam dimensi 2, seperti:

- titik (point), misal: lokasi
- garis (line), misal: jalan, batas wilayah
- poligon (polygon), misal: luas area, kawasan hutan

![Perbedaan berbagai fitur](assets/features_diff.png "Feature geometry oleh Levinson")
Perbedaan berbagai feature (credit to [Levinson](https://transportist.org/2019/11/06/catchment-if-you-can-the-effect-of-station-entrance-and-exit-locations-on-accessibility/))

**2. Coordinates Reference System (CRS)** <- diatur oleh PROJ

Menjelaskan kedudukan benda/objek di muka Bumi.

- Proyeksi, misal: longlat, UTM
- Datum, misal: WGS 84 (EPSG:4326), NAD27 (EPSG:4267), etc.

### `sp` dan `sf`

`sp`: Classes and Methods for Spatial Data.

- Dokumentasinya -> [`help(sp)`](https://cran.r-project.org/web/packages/sp/index.html)
- Lebih lanjut tentang `sp` | [Edzer (the author)](https://edzer.github.io/sp/)

`sf`: Simple Features for R

- hadir untuk melengkapi "kekosongan" fungsional pada `sp`
- menggunakan format tabel (data.frames atau tibbles) dengan lengkap dengan geometry dan CRS-nya
- merepresentasikan 17 bentuk/tipe sf secara langsung di R untuk semua dimensi (XY, XYZ, XYM, XYZM)
- integrasi langsung dengan GEOS, PROJ, dan GDAL (`sp` dibantu dengan library `rgeos` dan `rgdal`)
- dll.

## Requirements (Tools)

**Windows:**

- R | [unduh](https://cran.r-project.org/)
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- Rtools | [unduh](https://cran.r-project.org/bin/windows/Rtools/)

**Linux and MacOS:**

- R | [cara install](#)
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- GDAL, GEOS, PROJ | [cara install](#)

**Library (Windows, MacOS, Linux):**

- `sp`, `sf` (rspatial) >> [installation and more about `sf`](http://r-spatial.github.io/sf/)
- `tidyr`, `dplyr` (tidy data)
- `ggplot2`, `ggmap` (visualization)
- `rnaturalearth`, `osmdata`, `esri2sf (dev)` (data sources)

```R
if(!require("sf")) install.packages("sf")
if(!require("dplyr")) install.packages("dplyr")
if(!require("rnaturalearth")) install.packages("rnaturalearth")
if(!require("osmdata")) install.packages("osmdata")
```

## Data Preparation

Pada meet up lalu, kita telah belajar bersama Ulfa tentang cara mendapatkan data titik sebaran lokasi rumah sakit dan puskesmas dari webgis menggunakan R library `esri2sf`.

Install `esri2sf` untuk mengunduh data Esri Shapefile (.shp) spasial dari server webgis melalui REST API Esri (Yongha's package):

```R
if(!require("devtools")) install.packages("devtools")
devtools::install_github("yonghah/esri2sf", force = TRUE)
library("esri2sf")
```

Mengunduh data dari portal geospasial Indonesia:

```R
url <- "https://portal.ina-sdi.or.id/arcgis/rest/services/Lingkungan_Terbangun/RBI_50K_Fasilitas_Kesehatan/MapServer/1"
rs <- esri2sf(url)
```
Atau muat langsung data yang sudah disimpan melalui cara-cara di atas dari file .rds yang sudah ada di dalam folder data:

```R
rs <- readRDS("data/rs.rds")
```

Mengetahui kelas data/objek dan strukturnya:

```R
class(rs)
str(rs)
head(rs, 10)
```

## Visualisasi Menggunakan `sf`

Secara default kita bisa menampilkan data spasial menggunakan library `sf`.

**1. Cara plot data dari objek `sf`**

```R
library("sf")
plot(st_geometry(rs))
```

Bagaimana jika datanya berbentuk tabular dalam berkas atau .csv?

```R
rs.tbl <- read.csv("data/rs.csv")
str(rs.tbl) # melihat struktur data/objek
head(rs.tbl)  # menampilkan 6 baris pertama data
```

*PR (1): bersihkan data*
*PR (2): ubah format tabular ke format sf*

**2. Plot data RS ke peta Indonesia**

```R
id <- rnaturalearth::ne_countries(country = "indonesia", returnclass = "sf")
plot(st_geometry(id))
plot(st_geometry(rs), add = TRUE)
```

**3. Menampilkan RS di wilayah Pontianak**

```R
# Memuat peta Kota Pontianak
pontianak <- read_sf("data/peta/pontianak_kota.shp")
plot(st_geometry(pontianak))

# plot titik dari area of interest, masih ada warning
bb_pontianak <- st_bbox(pontianak)

library(dplyr)
rs %>%
  st_crop(bb_pontianak) %>% 
  st_geometry() %>% 
  plot(add = TRUE)
```

Plot dengan `ggplot2`

```R
library(ggplot2)
ggplot() + geom_sf(data = pontianak) + theme_bw()
ggplot(add = TRUE) + geom_sf(data = st_crop(rs, bb_pontianak))
```

**4. Transformasi referensi koordinat (CRS)**

Memperoleh informasi CRS dari data sebaran RS dan peta:

```R
st_crs(rs)
st_crs(pontianak)
```

Untuk mengubah CRS ke nilai tertentu, lakukan:

```R
crs.id <- 23838 # ambil dari web epsg.io

rs.id <- st_transform(rs, crs.id)
pontianak.id <- st_transform(pontianak, crs.id)

st_crs(rs.id)
st_crs(pontianak.id)

pontianak %>% 
  st_geometry() %>% 
  plot()

pontianak.id %>% 
  st_geometry() %>% 
  plot(add = TRUE) # PR: harus diberi warna
```

Lalu di mana letak perbedaannya? Mari kita telaah:

```R
st_bbox(rs)
st_bbox(rs.id)
```

Apa yang berbeda?

**5. Membuat buffer area**

Membuat batas area:

```R
buff <- st_buffer(st_geometry(rs.id), dist = 1000)

aoi <- st_bbox(pontianak.id)

pontianak.id %>% 
  st_geometry() %>% 
  plot(border = "blue")

rs.id %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE)

buff %>%
  st_crop(aoi) %>% 
  st_geometry() %>% 
  plot(add = TRUE, border = "red")
```

Sekian. Terima kasih. Nanti kita modifikasi lagi.

## Referensi dan Bahan Bacaan

- Penjelasan tentang olah data spasial | [intro gis with R](https://www.jessesadler.com/post/gis-with-r-intro/)
- Kata Wikipedia tentang [simple features](https://en.wikipedia.org/wiki/Simple_Features)
- Penjelasan tentang `sf` | [dokumentasi](https://cran.r-project.org/web/packages/sf/vignettes/sf1.html)
- Modifikasi data spasial kelas `sf` | [tidy sf](http://strimas.com/r/tidy-sf/)
- Cara menggunakan `esri2sf` | [Materi meet up lalu oleh @wanulfa](https://github.com/wanulfa/argis-server)
- Plotting peta dengan `sf` dan `ggplot2` | [artikel](https://www.r-bloggers.com/zooming-in-on-maps-with-sf-and-ggplot2/)
- Baca buku Robin Lovelace dan Jakub Nowosad
