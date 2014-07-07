# script to extract data from the Ushahidi API #

library(rjson)
library(RCurl)

# collecting data
message('Collecting Ushahidi / Crowdmap data.')
base_url <- 'https://worldushahidis.crowdmap.com/api?task=incidents'
limit_url <- '&limit='
limit <- 1000
url <- paste0(base_url, limit_url, limit)
raw_data <- fromJSON(getURL(url))
data <- raw_data$payload$incidents

# Selecting only relevant fields.
message('Selecting relevant fields.')
getLocation <- function(df = NULL) {
    for (i in 1:length(df)) {
        name = df[[i]]$incident$incidenttitle
        location_name = df[[i]]$incident$locationname
        latitude = df[[i]]$incident$locationlatitude
        longitude = df[[i]]$incident$locationlongitude
        data <- data.frame(name, location_name, latitude, longitude)
        if (i == 1) z <- data
        else z <- rbind(z, data)
    }
    return(z)
}
geo_data <- getLocation(data)

# Writing CSV
message('Writing CSV.')
write.csv(geo_data, 'data/ushahidi_instances.csv', row.names = F)

message('Done.')