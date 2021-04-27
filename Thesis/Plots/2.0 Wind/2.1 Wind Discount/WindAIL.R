# Alberta Wind vs AIL
#
# Reads in Alberta merit data and outputs wind, AIL, and on/off peak columns
#
# ----- Begin Code -------------------------------------------------------------

# ----- Load required libraries ------------------------------------------------
library(tidyverse)
library(dbplyr)
library(lubridate)
library(data.table)

# ----- Load in Data File ------------------------------------------------------

# Read in merit data csv file (>2 GB so it'll take a while)
setwd("G:/My Drive/MSc/Thesis/1.0 Wind Discount/Add or Subtract Wind")
fileName   <- file.path(getwd(), "2021_Mar_09.csv.gz")
meritData  <- fread(fileName) %>%
  # Subset the required columns
  subset(year > 2015 & year < 2021,
         select = c(date,he,merit,Plant_Type,dispatched_mw,hourly_dispatch,
                    actual_posted_pool_price,on_peak))

# ----- Run program ------------------------------------------------------------

windAIL <- meritData %>%
  # Group and arrange  
  group_by(date,he) %>% 
  # Mutate hourly demand and hourly wind
  mutate(hourlyWind = sum(dispatched_mw*(Plant_Type=="WIND"),na.rm=TRUE)) %>%
  summarise(hourlyWind = hourlyWind[!duplicated(hourlyWind)],
            hourly_dispatch = hourly_dispatch[!duplicated(hourly_dispatch)],
            pool_price = actual_posted_pool_price[!duplicated(actual_posted_pool_price)],
            on_peak = on_peak[!duplicated(on_peak)])%>%
  # Regroup
  group_by(date,he) %>% 
  # Clean frame
  subset(select = c(date,he,hourlyWind,hourly_dispatch,pool_price,on_peak))

# ----- Output files -----------------------------------------------------------

# write df to csv master copy
outputfile <- file.path(getwd(),"windAIL.csv")
write.csv(windAIL,outputfile, row.names = FALSE)

