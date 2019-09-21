library(sf)
library(tmap)
library(spData)
load("data/nz_elev.rda")

tm_shape(nz_elev)  +
  tm_raster(title = "elev", 
            style = "cont",
            palette = "-RdYlGn") +
  tm_shape(nz) +
  tm_borders(col = "red", 
             lwd = 3) +
  tm_scale_bar(breaks = c(0, 100, 200),
               text.size = 1) +
  tm_compass(position = c("LEFT", "center"),
             type = "rose", 
             size = 2) +
  tm_credits(text = "J. Nowosad, 2019") +
  tm_layout(main.title = "My map",
            bg.color = "lightblue",
            inner.margins = c(0, 0, 0, 0))

# 1. Change the map title from "My map" to "New Zealand".
# 2. Update the map credits with your own name and today's date.
# 3. Change the color palette to "BuGn". (You can also try other palettes from http://colorbrewer2.org/)
# 4. Put the north arrow in the top right corner of the map.
# 5. Improve the legend title by adding the legend units.
# 6. Increase the number of breaks in the scale bar.
# 7. Change the borders' color of the New Zealand's regions to black. 
# Decrease the line width.
# 8. Change the background color to any color of your choice.
