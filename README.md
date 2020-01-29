# Analisis Data Spasial dengan R

IDJN meet up 29 Jan 2019 | [Twitter](https://www.twitter.com/terusterang__)

> Kita akan mengetahui keterjangkauan layanan kesehatan (rumah sakit, puskesmas) pada suatu wilayah dengan bantuan bahasa pemrograman R.

### Akses materi melalui RStudio:

```R
if(!require("usethis")) install.packages("usethis")
usethis::use_course("https://github.com/akherlan/idjn-rspatial/archive/master.zip")
```

### Apa yang akan kita lakukan?

- Pengenalan [#rspatial](https://twitter.com/hashtag/rspatial?src=hashtag_click)
- Menyiapkan data
- Memeriksa tipe & struktur data
- Eksplorasi data
- Modifikasi data spasial
- Analisis

### Piranti yang perlu disiapkan:

**Windows:**

- R | [unduh](https://cran.r-project.org/)
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- Rtools | [unduh](https://cran.r-project.org/bin/windows/Rtools/)

**Linux dan MacOS:**

- R | [instalasi](https://r-spatial.github.io/sf/#linux)
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- GEOS, GDAL, PROJ | [konfigurasi](https://github.com/r-spatial/sf/#linux)

**Instalasi paket dari console di RStudio**

```R
install.packages("dplyr")
install.packages("sf")
install.packages("rnaturalearth")
install.packages("mapview")
```

### Referensi dan Bahan Bacaan

- Pengolahan data spasial | [intro gis with R](https://www.jessesadler.com/post/gis-with-r-intro/)
- Kata Wikipedia tentang [simple features](https://en.wikipedia.org/wiki/Simple_Features)
- Penjelasan tentang `sf` | [dokumentasi](https://cran.r-project.org/web/packages/sf/vignettes/sf1.html)
- Modifikasi data spasial kelas `sf` | [tidy sf](http://strimas.com/r/tidy-sf/)
- Cara menggunakan `esri2sf` | [Materi meet up lalu oleh Wanulfa](https://github.com/wanulfa/argis-server)
- Plot kelas data `sf` menggunakan `ggplot2` | [artikel](https://datascience.blog.wzb.eu/2019/04/30/zooming-in-on-maps-with-sf-and-ggplot2/)
- Buku [Geocomputational in R](https://geocompr.robinlovelace.net/spatial-class.html) oleh Robin Lovelace & Jakub Nowosad
- Instalasi R, GEOS, Proj4 (Linux & MacOS) | [r-spatial](https://r-spatial.github.io/sf/#linux)