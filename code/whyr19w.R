## pkgs = c(
##   "sf",
##   "raster",
##   "dplyr",
##   "tmap",
##   "spData",
## )
## to_install = !pkgs %in% installed.packages()
## if(any(to_install)) {
##   install.packages(pkgs[to_install])
## }

library(sf)
polska = st_read("data/polska.gpkg")

plot(polska)

polska

library(raster)
dem = raster("data/polska_srtm.tif")

plot(dem)

dem

library(tmap)

tm_shape(polska) + 
  tm_polygons()

tm_shape(polska) + 
  tm_polygons() + 
  tm_scale_bar(position = c("left", 
                            "bottom")) 

tm_shape(polska) + 
  tm_polygons() + 
  tm_scale_bar(position = c("left", 
                            "bottom")) + 
  tm_compass()

tm_shape(polska) + 
  tm_polygons() + 
  tm_scale_bar(position = c("left", 
                            "bottom")) + 
  tm_compass() +
  tm_layout(title = "Poland")

## tmap_mode("view")

## tm_shape(polska) +
##   tm_polygons() +
##   tm_layout(title = "Poland")

## tmap_mode("plot")

tm_shape(dem) + 
  tm_raster()

tm_shape(dem) + 
  tm_raster(style = "cont",
            midpoint = NA)

tm_shape(dem) + 
  tm_raster(style = "cont", 
            midpoint = NA,
            palette = "-RdYlGn")
## tmaptools::palette_explorer()

tm_shape(dem) + 
  tm_raster(style = "fixed",
            breaks = c(-99, 0, 300,
                       600, 9999), 
            midpoint = NA,
            palette = "-RdYlGn",
            title = "") + 
  tm_layout(legend.position = c("LEFT", 
                                "BOTTOM"))

tm_shape(dem) + 
  tm_raster(style = "fixed",
            breaks = c(-99, 0, 300,
                       600, 9999), 
            labels = c("Depressions", 
                       "Plains", 
                       "Hills",
                       "Mountains"),
            midpoint = NA,
            palette = "-RdYlGn",
            title = "") + 
  tm_layout(legend.position = c("LEFT", 
                                "BOTTOM"))

tm_shape(dem) + 
  tm_raster(style = "fixed",
            breaks = c(-99, 0, 300,
                       600, 9999), 
            labels = c("Depressions", 
                       "Plains", 
                       "Hills",
                       "Mountains"),
            midpoint = NA,
            palette = c("#5E8B73",
                        "#DAE97A", 
                        "#EADC70", 
                        "#AF8D5C"),
            title = "") + 
  tm_layout(legend.position = c("LEFT",
                                "BOTTOM"))

map1 = tm_shape(dem) + 
  tm_raster(style = "fixed",
            breaks = c(-99, 0, 300, 600, 9999),
            labels = c("Depressions", "Plains", "Hills", "Mountains"),
            midpoint = NA, 
            palette = c("#5E8B73", "#DAE97A", "#EADC70", "#AF8D5C"),
            title = "") +
  tm_layout(legend.position = c("LEFT", "BOTTOM"))

## tmap_save(map1, "my_first_map.png")

library(dplyr)

meteo_data = read.csv("data/polska_meteo_2017.csv", encoding = "UTF-8")
head(meteo_data)

meteo_stations = st_read("data/polska_stacje.gpkg")
plot(st_geometry(meteo_stations))

meteo_data_sel = meteo_data %>% 
  filter(Nazwa.stacji %in% unique(meteo_stations$NAZWA_ST))


meteo_data_sel = meteo_data %>% 
  filter(Nazwa.stacji %in% unique(meteo_stations$NAZWA_ST)) %>% 
  mutate(data = as.Date(paste0(Rok, "-", Miesiac, "-", Dzien)))



meteo_data_sel = meteo_data %>% 
  filter(Nazwa.stacji %in% unique(meteo_stations$NAZWA_ST)) %>% 
  mutate(data = as.Date(paste0(Rok, "-", Miesiac, "-", Dzien))) %>% 
  dplyr::select(-Rok, -Miesiac, -Dzien)



meteo_data_sel = meteo_data %>% 
  filter(Nazwa.stacji %in% unique(meteo_stations$NAZWA_ST)) %>% 
  mutate(data = as.Date(paste0(Rok, "-", Miesiac, "-", Dzien))) %>% 
  dplyr::select(-Rok, -Miesiac, -Dzien) %>% 
  summarize(tavg = mean(tavg), pressure = mean(pressure))



meteo_data_sel = meteo_data %>% 
  filter(Nazwa.stacji %in% unique(meteo_stations$NAZWA_ST)) %>% 
  mutate(data = as.Date(paste0(Rok, "-", Miesiac, "-", Dzien))) %>% 
  dplyr::select(-Rok, -Miesiac, -Dzien) %>% 
  group_by(Kod.stacji) %>% 
  summarize(tavg = mean(tavg), pressure = mean(pressure))



meteo = meteo_stations %>% 
  left_join(meteo_data_sel, by = c("KOD_SZS" = "Kod.stacji"))



meteo = meteo_stations %>% 
  inner_join(meteo_data_sel, by = c("KOD_SZS" = "Kod.stacji"))



plot(dem)

plot(st_geometry(meteo), axes = TRUE)

meteo = meteo_stations %>% 
  inner_join(meteo_data_sel, by = c("KOD_SZS" = "Kod.stacji")) %>% 
  st_transform(4326)

tm_shape(dem) +
  tm_raster() +
  tm_shape(meteo) +
  tm_symbols(col = "tavg", palette = "RdBu")

meteo$elev = extract(dem, meteo)
head(meteo)

lc = raster("data/polska_lc.tif")
plot(lc)

wlkp_pn = st_read("data/wlkp_pn.gpkg", quiet = TRUE)
plot(st_geometry(wlkp_pn), axes = TRUE)

wlkp_pn_lc = crop(lc, wlkp_pn)
plot(wlkp_pn_lc)

wlkp_pn_lc2 = mask(wlkp_pn_lc, wlkp_pn)
plot(wlkp_pn_lc2)
