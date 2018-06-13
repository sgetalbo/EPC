library(data.table)
library(rgdal)
library(tmap)
library(RColorBrewer)
library(classInt)

#Read in gas data (2016 data)
df <- fread("Data/LSOA_domestic_gas_2016.csv")

#Clean column types
df$`Consumption (kWh)` <- as.numeric(df$`Consumption (kWh)`)
df$`Number of meters` <- as.numeric(df$`Number of meters`)
df$`Mean consumption (kWh per meter)` <- as.numeric(df$`Mean consumption (kWh per meter)`)
df$`Median consumption (kWh per meter)` <- as.numeric(df$`Median consumption (kWh per meter)`)

#Read in LSOA shapefile
LSOA <- readOGR("Data/Lower_Layer_Super_Output_Areas_December_2011_Generalised_Clipped__Boundaries_in_England_and_Wales/Lower_Layer_Super_Output_Areas_December_2011_Generalised_Clipped__Boundaries_in_England_and_Wales.shp")

#Merge gas consumption data to shapefile
LSOA@data <- merge(LSOA@data, df, by.x="lsoa11cd", by.y="LSOA")

#Map number of meters
breaks <- classIntervals(LSOA@data$`Number of meters`, n = 5, style = "fisher")
my_colours <- brewer.pal(6, "YlOrRd") 
colours_to_map <- findColours(breaks, my_colours)
plot(LSOA,col=colours_to_map, border = NA)
legend("bottomleft", legend = leglabs(breaks$brks, between = " to "), fill = my_colours, bty = "n",cex=0.6)

#Map consumption
breaks1 <- classIntervals(LSOA@data$`Consumption (kWh)`, n = 5, style = "fisher")
my_colours1 <- brewer.pal(6, "YlOrRd") 
colours_to_map1 <- findColours(breaks1, my_colours1)
plot(LSOA,col=colours_to_map1, border = NA)

#Map mean consmption
breaks2 <- classIntervals(LSOA@data$`Mean consumption (kWh per meter)`, n = 5, style = "fisher")
my_colours2 <- brewer.pal(6, "YlOrRd") 
colours_to_map2 <- findColours(breaks2, my_colours2)
plot(LSOA,col=colours_to_map2, border = NA)
