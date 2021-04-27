# Alberta Wind by plant
#
# Reads in Alberta merit data and outputs wind and asset id
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
meritData  <- fread(fileName)

wind <- meritData %>%
  group_by(date,he) %>%
  mutate(hourly_wind = sum(dispatched_mw*(Plant_Type=="WIND")),
         AKE1        = sum(dispatched_mw*(asset_id == "AKE1")),
         ARD1        = sum(dispatched_mw*(asset_id == "ARD1")),
         BSR1        = sum(dispatched_mw*(asset_id == "BSR1")),
         BTR1        = sum(dispatched_mw*(asset_id == "BTR1")),
         BUL1        = sum(dispatched_mw*(asset_id == "BUL1")),
         BUL2        = sum(dispatched_mw*(asset_id == "BUL2")),
         CR1         = sum(dispatched_mw*(asset_id == "CR1")),
         CRE3        = sum(dispatched_mw*(asset_id == "CRE3")),
         CRR1        = sum(dispatched_mw*(asset_id == "CRR1")),
         CRR2        = sum(dispatched_mw*(asset_id == "CRR2")),
         GWW1        = sum(dispatched_mw*(asset_id == "GWW1")),
         HAL1        = sum(dispatched_mw*(asset_id == "HAL1")),
         IEW1        = sum(dispatched_mw*(asset_id == "IEW1")),
         IEW2        = sum(dispatched_mw*(asset_id == "IEW2")),
         KHW1        = sum(dispatched_mw*(asset_id == "KHW1")),
         NEP1        = sum(dispatched_mw*(asset_id == "NEP1")),
         OWF1        = sum(dispatched_mw*(asset_id == "OWF1")),
         RIV1        = sum(dispatched_mw*(asset_id == "RIV1")),
         SCR2        = sum(dispatched_mw*(asset_id == "SCR2")),
         SCR3        = sum(dispatched_mw*(asset_id == "SCR3")),
         SCR4        = sum(dispatched_mw*(asset_id == "SCR4")),
         TAB1        = sum(dispatched_mw*(asset_id == "TAB1")),
         WHT1        = sum(dispatched_mw*(asset_id == "WHT1"))) %>%
  subset(Plant_Type == "WIND", 
         select = c(date,he,hourly_dispatch,hourly_wind,actual_posted_pool_price,AKE1,
                    ARD1,BSR1,BTR1,BUL1,BUL2,CR1,CRE3,CRR1,CRR2,GWW1,
                    HAL1,IEW1,IEW2,KHW1,NEP1,OWF1,RIV1,SCR2,SCR3,SCR4,
                    TAB1,WHT1)) %>%
  distinct(date,he,.keep_all = TRUE)

  

# ----- Output files -----------------------------------------------------------

# write df to csv master copy
outputfile <- file.path(getwd(),"windByPlant.csv")
write.csv(wind,outputfile, row.names = FALSE)

