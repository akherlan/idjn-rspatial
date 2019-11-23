# Visualisasi Data Spasial dengan R

**TL;DR**

Menggunakan bahasa R untuk mengetahui keterjangkauan layanan kesehatan (rumah sakit dan puskesmas).

## Introduction to #rspatial

### Representasi Objek Nyata pada Komputer

**1. Simple features** <- diatur oleh GEOS

Menjelaskan bagaimana objek-objek dalam dunia nyata bisa diwakilkan ke dalam komputer, dengan penekanan pada bentuk (geometri) spasial objek tersebut.

- *geometry* menjelaskan tentang bentuk benda/objek tersebut di Bumi.
- *attributes* berhubungan dengan sifat-sifatnya (properties).

Geometri yang sering digunakan adalah dalam dimensi 2, seperti:

- titik (point), misal: lokasi
- garis (line), misal: jalan, batas wilayah
- poligon (polygon), misal: luas area, kawasan hutan
- kumpulan titik (multi-point)
- kumpulan garis (multi-line)
- dll.

**2. Coordinates Reference System (CRS)** <- diatur oleh PROJ

Menjelaskan kedudukan benda/objek di muka Bumi.

- Proyeksi, misal: longlat, UTM
- Datum, misal: WGS 84 (EPSG:4326), NAD27 (EPSG:4267), etc.

### `sp` dan `sf`

`sp`: Classes and Methods for Spatial Data.

- Dokumentasinya -> [`help(sp)`](https://cran.r-project.org/web/packages/sp/index.html)
- Lebih lanjut tentang `sp`: https://edzer.github.io/sp/

`sf`: Simple Features for R

- `sf` hadir untuk melengkapi "kekosongan" fungsional pada `sp`
- provides simple features are data.frames or tibbles with a geometry list-column
- represents natively in R all 17 simple feature types for all dimensions (XY, XYZ, XYM, XYZM)
- interfaces to GEOS to support the DE9-IM
- interfaces to GDAL, supporting all driver options, Date and DateTime (POSIXct) columns, and coordinate reference system transformations through PROJ
- uses well-known-binary serialisations written in C++/Rcpp for fast I/O with GDAL and GEOS
- reads from and writes to spatial databases such as PostGIS using DBI
- is extended by pkg lwgeom for further liblwgeom/PostGIS functions, including spherical geometry functions

## Requirements (Tools)

**Windows:**

- R from [CRAN](https://cran.r-project.org/)
- RStudio | [downlaod](https://rstudio.com/products/rstudio/download/)
- Rtools | [downlaod](https://cran.r-project.org/bin/windows/Rtools/)

**Linux and MacOS:**

- R | installation
- RStudio | [download](https://rstudio.com/products/rstudio/download/)
- GDAL, GEOS, PROJ

**Library (Windows, MacOS, Linux):**

- `sp`, `sf` (rspatial) >> [installation and more about `sf`](http://r-spatial.github.io/sf/)
- `tidyr`, `dplyr` (tidy data)
- `ggplot2`, `ggmap`, `leaflet` (visualization)
- `rnaturalearth`, `esri2sf (dev)` (data sources)

## Data Preparation

Pertemuan lalu: install `esri2sf` untuk mengunduh data Esri Shapefile (.shp) spasial dari server webgis melalui REST API Esri (Yongha's package):

```R
# install.packages("devtools")
devtools::install_github("yonghah/esri2sf")
library("esri2sf")
```

Mengunduh data dari portal geospasial Indonesia:

```R
url <- "https://portal.ina-sdi.or.id/arcgis/rest/services/Lingkungan_Terbangun/RBI_50K_Fasilitas_Kesehatan/MapServer/1"
rs <- esri2sf(url)
```
Atau load langsung dari file .rds yang sudah ada di dalam folder data:

```R
rs <- readRDS("data/rs.rds")
```

Mengetahui kelas data/objek dan strukturnya:

```R
class(rs)
str(rs)
tibble::as_tibble(rs)
```

## Visualization using `sf`

Plot data:

```R
library("sf")
plot(st_geometry(rs))
```

*Q: Bagaimana jika datanya berbentuk tabular xlsx atau csv?*

*My homework: Sediakan cara impor data dari xlsx atau csv.*

**Plot data RS ke peta Indonesia**

Memuat peta Indonesia dari Natural Earth

```R
id <- rnaturalearth::ne_countries(country = "indonesia")
plot(id) # sometimes error, modification is needed
plot(st_geometry(rs), add = TRUE)
```

*Q : Bagaimana cara menampilkan potongan hanya untuk wilayah tertentu?*

*My homework: Potong/subset dengan mendefinisikan bbox-nya.*

Contoh lain: Memuat data peta North Carolina dari sampel data milik `sf`

```R
nc <- st_read(system.file("shape/nc.shp", package = "sf"))
class(nc)
plot(nc)
plot(nc, max.plot = 14)
plot(nc["AREA"])
plot(st_geometry(nc))     # apa bedanya dengan cuma plot?
```

**Bermain dengan CRS**

Mengetahui CRS:

```R
st_crs(nc)
```

Untuk mengubah crs ke nilai tertentu lakukan:

```R
nc.utm <- st_transform(nc, crs)
```

Untuk mengambil komponen geometri dari kelas objek `sf` (sfc-nya): `geom <- sf_geometry(nc.utm)`

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

Sekian. Terima kasih. Nanti kita modifikasi lagi.

## Referensi

- Penjelasan tentang olah data spasial: https://www.jessesadler.com/post/gis-with-r-intro/
- Penjelasan tentang sf: https://cran.r-project.org/web/packages/sf/vignettes/sf1.html
- Baca buku Robin Lovelace dan Jakub Nowosad
- Bacaan: http://strimas.com/r/tidy-sf/
- Kata Wikipedia [tentang simple features](https://en.wikipedia.org/wiki/Simple_Features)
- Cara menggunakan `esri2sf` | [Materi meet up lalu oleh @wanulfa](https://github.com/wanulfa/argis-server)
