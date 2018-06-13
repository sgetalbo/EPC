# Load required packages
library("data.table")
library("tidyr")
library("dplyr")



# Read in Postcode headcount data files. Only need 1c while working on Oldham sample.
#df1a <- fread("~/Google_Drive/PhD/Papers/Paper_1_research/data/DEP/Raw_data/Postcode_estimates/Postcode_Estimates_1_A_F.csv", header = TRUE)
#df1b <- fread("~/Google_Drive/PhD/Papers/Paper_1_research/data/DEP/Raw_data/Postcode_estimates/Postcode_Estimates_1_G_L.csv", header = TRUE)
df1c <- fread("~/Google_Drive/PhD/Papers/Paper_1_research/data/DEP/Raw_data/Postcode_estimates/Postcode_Estimates_1_M_R.csv", header = TRUE)
#df1d <- fread("~/Google_Drive/PhD/Papers/Paper_1_research/data/DEP/Raw_data/Postcode_estimates/Postcode_Estimates_1_S_Z.csv", header = TRUE)

# Compile into one dataframe 
#df1 <- rbind(df1a, df1b, df1c, df1d)

#Load in Energy Performance Certificate data - Oldham only at this stage.

#Clean data to one file 
#list of file names 
#l <- list.dirs(path = "~/Dropbox/raw_data/EPC_domestic_certificates/all-domestic-certificates", 
 #              full.names = TRUE, 
  #             recursive = TRUE)
#make a counter
#cnt <- 0
#loop for moving each .csv file with a counter on name
#for (i in l) {
 # cnt <- cnt + 1 
#  file.copy(paste0(i, "/certificates.csv"), paste0("~/Dropbox/raw_data/EPC_domestic_certificates/certificates/", as.character(cnt), "_certificates.csv"))
#}
#load all files and rbind
#files <- list.files(path = "~/Dropbox/raw_data/EPC_domestic_certificates/certificates/",pattern = ".csv",full.names = T)
#dlist <- lapply(files, fread, sep= ",")
#data <- rbindlist(dlist)
#write file complete
#fwrite(data, "~/Dropbox/chapters_and_papers/paper_2/epc_certificates.csv", row.names = F)

EPC <- fread("~/Google_Drive/PhD/Papers/all-domestic-certificates-2/domestic-E08000004-Oldham/certificates.csv")[,c(2:5, 7:13, 17:18)]
EPC_OA <- fread("Data/epcoa.csv")


#Keep unique values and take record for the most recent date only
EPC$LODGEMENT_DATE <- as.POSIXct(EPC$LODGEMENT_DATE)

EPC %>% 
  group_by(ADDRESS1) %>%  
  filter(LODGEMENT_DATE == max(LODGEMENT_DATE)) -> EPC_unique

#Compare EPC numbers to NSPD occupied household counts 
EPC_coverage <- EPC_unique[,4] %>%
  group_by(POSTCODE) %>%
  mutate(count = n()) %>%
  distinct(POSTCODE, .keep_all = TRUE)

EPC_coverage <- merge(EPC_coverage, df1c[,c(1,5)], by.x = "POSTCODE", by.y = "Postcode", all.x=TRUE)
EPC_coverage$Percentage <- round(EPC_coverage$count / EPC_coverage$Occupied_Households  * 100, 2)

#Read in LSOA shapefile
LSOA <- readOGR("Data/Lower_Layer_Super_Output_Areas_December_2011_Generalised_Clipped__Boundaries_in_England_and_Wales/Lower_Layer_Super_Output_Areas_December_2011_Generalised_Clipped__Boundaries_in_England_and_Wales.shp")
