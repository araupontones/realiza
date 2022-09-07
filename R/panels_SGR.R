

panels_SGR <- function(id){
  

    
<<<<<<< HEAD
  navbarMenu("SGR",
             tabPanel("Modulos Obligatorios",
                      value = "modulos_sgr",
                      ui_sessoes("sgr_modulos", grupo = "sgr")
                      
||||||| aac116e
  navbarMenu("SGR",
             tabPanel("Modulos Obligatorios",
                      value = "modulos_sgr",
                      ui_sessoes("sgr_modulos", grupo = "sgr")
                      
             ),
             tabPanel("Por Cidade",
                      value = "cidades_sgr",
                      ui_cidades("sgr_cidades")   
=======
             tabPanel(id,
                      value = "cidades_sgr",
                      ui_cidades("sgr_cidades")   
>>>>>>> 05666e92e81c499b64daacd3f8621b13889c9fb9
             )
  
    
  
}


