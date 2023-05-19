

panels_cresca_conecta <- function(title, value){
  

  titulo = paste(str_to_sentence(identify_mode(value)),"Obligatorios")
  
    
  navbarMenu(title,
             tabPanel(titulo,
                      value = value,
                      ui_sessoes_obligatorias(value)
                      
             )
  )
    
  
}


