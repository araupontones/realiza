

panels_FNM <- function(id){
  

    
    navbarMenu(id,
               tabPanel("Sessoes Obligatorias",
                        value = "sessoes_fnm",
                        ui_sessoes("fnm_sessoes", grupo = "fnm")
                        
               ),
               tabPanel("Agendadas",
                        value = "agenda_fnm",
                        ui_agendas("fnm_agenda", grupo = "fnm")
                        )
    )
    
  
}


