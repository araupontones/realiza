

panels_cresca_conecta <- function(title, value){
  

  titulo_tab = paste(str_to_sentence(identify_mode(value)),"Obligatorios")
  grupo = identify_grupo(value)
  
  
  tab_obligatorias <- tabPanel(titulo_tab,
                   value = value,
                   ui_sessoes_obligatorias(value))
  
  
  if(grupo == "Movimenta"){
    
    navbarMenu(title,
               tab_obligatorias,
               tabPanel("Modulos Movimenta",
                        value = "modulos_movimenta",
                        ui_sessoes_obligatorias("modulos_movimenta"))
    )
               
    
  } else {
    
    navbarMenu(title,
               tab_obligatorias
               
    )
    
  }
  
  
  
  
  
  
  
    
  
}


