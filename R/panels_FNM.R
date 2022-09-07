

panels_FNM <- function(id){
  

<<<<<<< HEAD
    
    navbarMenu(id,
               tabPanel("Sessoes Obligatorias",
                        value = "sessoes_fnm",
                        ui_sessoes("fnm_sessoes", grupo = "fnm")
                        
               )
    )
||||||| aac116e
    
    navbarMenu(id,
               tabPanel("Sessoes Obligatorias",
                        value = "sessoes_fnm",
                        ui_sessoes("fnm_sessoes", grupo = "fnm")
                        
               ),
               tabPanel("Por Cidade",
                        value = "cidades_fnm",
                        ui_cidades("fnm_cidades")   
               )
    )
=======
    tabPanel(id,
             value = "cidades_fnm",
             ui_cidades("fnm_cidades") 
             )
    # navbarMenu(id,
    #            tabPanel("Por Cidade",
    #                     value = "cidades_fnm",
    #                     ui_cidades("fnm_cidades")   
    #            )
    # )
>>>>>>> 05666e92e81c499b64daacd3f8621b13889c9fb9
    
  
}


