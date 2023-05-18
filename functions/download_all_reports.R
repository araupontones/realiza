download_realiza <- function(report){
  
  rep <- get_report_bulk(url_app = "https://creator.zoho.com",
                               account_owner_name = "muvalink",
                               app_link_name = "realiza-app",
                               report_link_name = report,
                               access_token = "",
                               criteria = "ID != 0",
                               limit = 200,
                               from = 1,
                               client_id = "1000.70NUR07O0MQT8DK3A6XKKBTD6MFKOE",
                               client_secret = "3c381997fbcfed2112516e92e5d861a153d8c36e94",
                               refresh_token = "1000.09a7defc533da6ff339e5379cdf39b9b.f32f6b07f38c86d033ca791c7c8e12e0"
                               
  )                       
  
  
  return(rep)
  
  
  
  
}

