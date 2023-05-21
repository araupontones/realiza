#UI of all grupos in the dashboard
#'@param title is the title of the navbarMenu
#'@param value the value of the selected tab

panels_UI <- function(title, value){

  
#identifies the group
grupo = identify_grupo(value)
  
#create title of the tab (the user passes it in lower)  
titulo_tab = paste(str_to_sentence(identify_mode(value)),"Obligatorios")

  
#create tab for the mandatory sessions 
tab_obligatorias <- tabPanel(titulo_tab,
                 value = value,
                 ui_sessoes_obligatorias(value))

#tab agendadas 
value_agendadas <- str_replace(value, "modulos|sessoes","agendadas")
tab_agendadas <- tabPanel("Agendadas",
                          value = value_agendadas,
                          ui_agendadas(value_agendadas))


#movimenta has on
if(grupo == "Movimenta"){

  navbarMenu(title,
             #sessoes obligatorios
             tab_obligatorias,
             #modulos obligatorios
             tabPanel("Modulos Obligatorios",
                      value = "modulos_movimenta",
                      ui_sessoes_obligatorias("modulos_movimenta")),
             tab_agendadas
  )


} else if (grupo == "Conecta"){
  navbarMenu(title,
             tab_obligatorias,
             tab_agendadas
  )
  
  
} else {

  navbarMenu(title,
             tab_obligatorias

  )

}

}
    
  
  
  
  
  
  
  
  
    
  



