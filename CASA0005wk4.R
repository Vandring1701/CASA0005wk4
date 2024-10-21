install.packages("countrycode")
library(countrycode)
library(sf)
library(dplyr)

GII <- read.csv("GII.csv")
GII$ISO2C <- countrycode(
  GII$country_code,
  origin = 'iso3c',
  destination = 'iso2c',
  warn = TRUE,
  nomatch = NA,
  custom_dict = NULL,
  custom_match = NULL,
  origin_regex = NULL
)
world <- st_read("world_countries.geojson")
GII_shape <- merge(GII, world, by.x = "ISO2C", by.y = "ISO")
GII_shape$difference = GII_shape$X2019_index - GII_shape$X2010_index
names(GII_shape)
GII_shape <- select(GII_shape, "ISO2C", "country", "X2010_index", 'X2019_index', 'geometry', 'difference')
st_write(GII_shape, "GII.shp")
