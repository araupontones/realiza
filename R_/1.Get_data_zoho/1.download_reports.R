#'Data for dashboard

#load dependencies -------------------------------------------------------------
library(rio)
library(stringr)
gmdacr::load_functions("functions")
source('R/0.define_paths.R', encoding = 'UTF-8') #define paths




#Define reports to download ----------------------------------------------------
# Only the dynamic reports from the system
# All the static ones are downloaded by R_/lookups/create_lookups.R

fetch_this <- c(
  FNM_grupal = "Presencas_grupales_FNM_Report", 
  FNM_ind = "Presencas_IND_FNM_Report",
  SGR_train = "Presencas_Fixas_roster_Report",
  SGR_ind = "Presencas_IND_SGR_report"
  # Calendar created by Tatiana with the details of all the events
  #"Calendario_Report")
)



# Download reports
cli::cli_alert_info("Downloading reports---------------------------------------")

# #download data ===============================================================
# it is saved in a list variable 


reportes <- purrr::map(fetch_this, download_realiza)
names(reportes) <- names(fetch_this)

#Export ========================================================================
# export list of reportes
rio::export(reportes, path_raw_data)


