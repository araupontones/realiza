zoho_scripts <- list.files("R_/1.Get_data_zoho", full.names = T)
for_dashboard <- list.files("R_/2.create_data_dashboard", full.names = T)
dir_lkps <- "data/0look_ups"

#Downlaod data from zoho
#Append groups and individual sessions
#Clean data
zoho_data <- lapply(zoho_scripts, function(x){
  
  
  source(x, encoding = "UTF-8")
  
})


dashboard_data <- lapply(for_dashboard, function(x){
  
  source(x, encoding = "UTF-8")
})


