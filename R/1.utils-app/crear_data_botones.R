#'@description creates divs (botones) for each actividad that an emprededora will attend
#'this data is used for the table with the bolinhas
#'@param .data data of presencas (created in R_/1.Get_data_zoho/2.clean_reports)



#create a function to create HTML element of the boton =========================
div_boton <- function(id, class=c('red', 'green', 'blue')){

  glue('<button id="{id}" type="button" class="btn btn-default action-button shiny-bound-input dot {class}"></button>')

}

# div_boton <- function(id, class){
#   
#   glue('<button id="{id}" type="button" class="action-button shiny-bound-input dot {class}"></button>')
#   
# }

##<div class="dot green"></div>
#Create data with divs ==========================================================
  
crear_data_botones <- function(.data){
  .data %>%
  #green for presente
  #red ausente
  #blue agendado but pendiente
  mutate(boton = case_when(presente ~ div_boton(rec_id, 'green'),
                           ausente ~ div_boton(rec_id, 'red'),
                           T ~ div_boton(rec_id, 'blue')
  )
  ) %>%
  #Create a single row by emprendodora, and a column for each type of activity
  group_by(Emprendedora, actividade) %>%
  summarise(divs = paste(boton, collapse = ""),
            .groups = 'drop') %>%
  pivot_wider(id_cols = Emprendedora,
              names_from = actividade,
              values_from = divs)
  
}





