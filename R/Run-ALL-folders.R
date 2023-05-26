#run all modules within folders in R

#read all folders
all_modules <- list.dirs("R", recursive = T, full.names = T)


cli::cli_alert_info("Reading these scripts:")
read_all <- lapply(all_modules, function(module){
  
  
  #dont read R directory
  if(module != "R") {
    cli::cli_alert_info(glue::glue('{module}-----------------------------------'))
    
    #list of files within each directory
    module_scripts <- list.files(module,pattern = ".R", full.names = T, recursive = T)
    
    #print(module_scripts)
    
    #read script
    for(script in module_scripts) {
      
      cli::cli_alert_success(stringr::str_extract(script, '([^\\/]+$)'))
      
      source(script, encoding = "UTF-8")
      
      
    }
    
  }
  
  
  
})
