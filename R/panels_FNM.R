

panels_FNM <- function(id){
  

    
    navbarMenu(id,
               tabPanel("Sessoes Obligatorias",
                        value = "sessoes_fnm",
                        ui_sessoes("fnm_sessoes", grupo = "fnm")
                        
               )
    )
    
  
}


