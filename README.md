# Analisis Data Spasial dengan R

Materi IDJN meet up 28 Nop 2019 oleh [Andi](https://www.twitter.com/terusterang__)

> Kita akan mengetahui keterjangkauan layanan kesehatan (rumah sakit dan puskesmas) pada suatu wilayah.

Akses materi melalui RStudio:

```R
if(!require("usethis")) install.packages("usethis")
usethis::use_course("https://github.com/akherlan/idjn-rspatial/archive/master.zip")
```

Apa yang akan kita pelajari?

- Pengenalan [#rspatial](https://twitter.com/hashtag/rspatial?src=hashtag_click)
- Menyiapkan data
- Memeriksa tipe & struktur data
- Plot data spasial
- Modifikasi data spasial

Piranti yang perlu disiapkan:

**Windows:**

- R | [unduh](https://cran.r-project.org/)
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- Rtools | [unduh](https://cran.r-project.org/bin/windows/Rtools/)

**Linux dan MacOS:**

- R
- RStudio | [unduh](https://rstudio.com/products/rstudio/download/)
- GEOS, GDAL, PROJ | [konfigurasi](https://github.com/r-spatial/sf/#linux)

*Instalasi R di Ubuntu*

```
sudo apt-get update
sudo apt-get install r-base
```

**Library (Windows, MacOS, Linux):**

```R
install.packages("sf")
install.packages("dplyr")
install.packages("rnaturalearth")
```

### Referensi dan Bahan Bacaan

- Pengolahan data spasial | [intro gis with R](https://www.jessesadler.com/post/gis-with-r-intro/)
- Kata Wikipedia tentang [simple features](https://en.wikipedia.org/wiki/Simple_Features)
- Penjelasan tentang `sf` | [dokumentasi](https://cran.r-project.org/web/packages/sf/vignettes/sf1.html)
- Modifikasi data spasial kelas `sf` | [tidy sf](http://strimas.com/r/tidy-sf/)
- Cara menggunakan `esri2sf` | [Materi meet up lalu oleh Wanulfa](https://github.com/wanulfa/argis-server)
- Plot peta dengan `sf` dan `ggplot2` | [artikel](https://www.r-bloggers.com/zooming-in-on-maps-with-sf-and-ggplot2/)
- Buku [Geocomputational in R](https://geocompr.robinlovelace.net/spatial-class.html) oleh Robin Lovelace & Jakub Nowosad