# Visualisasi Data Spasial dengan R

## Introduction to #rspatial

**TL;DR**

Plot buffer area using `sp` and `sf` packages.

### The Real Object Representation

Untuk menggambarkannya pada media lain (komputer) diperlukan hal-hal berikut:

**1. Simple features (sf)** describes how objects in the real world could be represented in computers, with emphasis on the spatial geometry of these objects.

There are *geometry* (describing where on Earth) and *attributes* (related to its properties).

Mostly 2-dimensional geometries such as:

- point
- line
- polygon
- multi-point
- multi-line
- etc.

**2. Coordinates Reference System (CRS)**

adalah ... 

### `sp` and `sf`

`sp`: Classes and Methods for Spatial Data [`help(sp)`](https://cran.r-project.org/web/packages/sp/index.html)

Lebih lanjut tentang sp: https://edzer.github.io/sp/

`sf`: represents natively in R all 17 simple feature types for all dimensions (XY, XYZ, XYM, XYZM)

`sf` hadir untuk melengkapi "kekosongan" fungsional pada `sp`.

## Requirements (Tools)

Windows:

- R from [CRAN](https://cran.r-project.org/)
- RStudio | [downlaod](https://rstudio.com/products/rstudio/download/)
- Rtools | [downlaod](https://cran.r-project.org/bin/windows/Rtools/)

Linux and MacOS:

- R from [CRAN](https://cran.r-project.org/)
- RStudio | [download](https://rstudio.com/products/rstudio/download/)
- GDAL, GEOS, PROJ

Library (Windows, MacOS, Linux):

- `sp`, `sf` (rspatial) >> [installation and more about `sf`](http://r-spatial.github.io/sf/)
- `tidyr`, `dplyr` (tidy data)
- `ggplot2` + `ggmap` (visualization)
- `rnaturalearth`, `esri2sf (dev)` (sources)

## Data Preparation

Pertemuan lalu: install `esri2sf` untuk mengunduh data spasial dari server webgis esri (Yongha's package):

```R
# install.packages("devtools")
devtools::install_github("yonghah/esri2sf")
library("esri2sf")
```

Mengunduh data dari portal geospasial Indonesia

```R
url <- "https://portal.ina-sdi.or.id/arcgis/rest/services/Lingkungan_Terbangun/RBI_50K_Fasilitas_Kesehatan/MapServer/1"
rs <- esri2sf(url)
```

Mempelajari struktur data dengan `str()` atau membaca data dengan `tibble::as_tibble()`

```R
str(rs)
tibble::as_tibble(rs)
```

Instead of download all unnecessary attributes, you could pick one the most nice to use.

```R
kat <- esri2sf::esri2sf(url = url, outFields = "REMARK") # subset data berdasar atribut
```

Plot data

```R
plot(rs["REMARK"], axes = TRUE, key.width = 0.1)
plot(bf["REMARK"], axes = TRUE)
```

Atau unduh melalui tautan [link] (format *.csv)

## Visualization: `sf`

**Contoh penggunaan:**

Memuat peta Indonesia dari Natural Earth

```R
id <- rnaturalearth::ne_countries(country = "indonesia")
```

Memuat data peta North Carolina dari sampel data milik `sf`

```R
nc <- st_read(system.file("shape/nc.shp", package = "sf"))
```

Periksa strukturnya dulu: `str(nc)`, lalu:

- untuk mengubah crs ke nilai tertentu lakukan `nc.utm <- st_transform(nc, crs)`
- untuk mengambil komponen geometri dari *`sf` object class* (sfc-nya): `geom <- sf_geometry(nc.utm)`

**Membuat buffer area:**

Memastikan satuan yang digunakan telah sesuai dengan mendefinisikan kembali CRS:

```R
library("sf")
crs <- "..."					# mendefinisikan CRS
rs.mod <- st_transform(rs, crs)			# transformasi CRS objek rs
units::set_units(rs.mod, km)			# mengubah satuan yang digunakan
```

Membuat area buffer:

```R
buf <- st_buffer(geom, dist = 1000)
plot(buf, border = "red")			# plot area buffer
plot(geom, add = TRUE)				# menambahkan titik lokasi RS
```

Sekian. Terima kasih.

## Referensi

- Penjelasan tentang olah data spasial: https://www.jessesadler.com/post/gis-with-r-intro/
- Penjelasan tentang sf: https://cran.r-project.org/web/packages/sf/vignettes/sf1.html
- Baca buku Robin Lovelace dan Jakub Nowosad
- Baca dulu: http://strimas.com/r/tidy-sf/
- Kata Wikipedia tentang sf: https://en.wikipedia.org/wiki/Simple_Features
