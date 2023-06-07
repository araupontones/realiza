library(shiny)
library(dplyr)
library(shinythemes)
library(shinycssloaders)
library(ggplot2)
library(DT)
library(glue)
library(httr)
library(jsonlite)
library(zohor)
library(stringr)
library(forcats)
library(rio)


#load internal functions  
gmdacr::load_functions("functions")


ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  shinyjs::useShinyjs(),
  theme = shinytheme("yeti"),
  
  uiOutput("last_refreshed"),
  navbarPage("Realiza",
             id = "Paneles",
             
             
             #the value of the selected panel is defined within panels_cresca()
             #panels_cresca_conecta(title = "Cresça"),
             panels_UI(title = "Cresça" , value = "modulos_cresca"),
             panels_UI(title = "Conecta" , value = "sessoes_conecta"),
             panels_UI(title = "Movimienta" , value = "sessoes_movimenta"),
             
           
            
            tabPanel("Admin",
                     ui_admin("admin")),
             
         
                       
                 
           
            
            
  )
)




server <- function(input, output, session) {
#read presencas
  #paths are defined in R/0.define_paths.R
  
  if(!file.exists("data/2.clean_presencas.rds")){

    message('creating data')
    source('R_/X.Run_flow.R')
    #source('R/Run-ALL-folders.R')
  }

  
  
  presencas <- rio::import(path_clean_presencas)
  last_refreshed <- rio::import(path_last_refreshed)
  
  
#reactive data =================================================================
  #get the active group
  #for this function to work, all the values of the panels must include the words
  #cresca,moviementa or conecta
  
  active_grupo <- reactive({identify_grupo(input$Paneles)})
  
  
  
 

#Text of last refresehed =======================================================
  
  output$last_refreshed <- renderUI({
    
    text <- paste("Última atualização:", last_refreshed)
    
    p(text)
  })


#New server grupos ============================================================

grupos <- c("movimenta", "cresca", "conecta")
  
sessoes <- paste(c("sessoes"), grupos , sep = "_")
modulos <- paste(c("modulos"), grupos , sep = "_")
agendadas <- paste(c("agendadas"), grupos , sep = "_")

sessoes_modulos <- c(sessoes,modulos, agendadas)

#run servers 
lapply(sessoes_modulos, function(active){
  
 
  observe({
    
    #tell me where we are
    if(input$Paneles == active){
      message(paste("active panel:", active))
      
      if(active %in% c(sessoes, modulos)){
        #run server sessoes and return data for the selected agente
        data_agente <- serverSessoesObrigatorias(active, presencas)
        
        #create the events to get the modals of each boton
        observeEvent(data_agente(),{
          
          
          #get id of each boton
          botones <- c(data_agente()$rec_id)

          lapply(botones, function(id){

          #filter this event from the presencas data
            data_boton <- reactive(

              filter(presencas, rec_id == id)
            )

            #when the bolinha is clicked, provide this information
            observeEvent(input[[id]], {
              showModal(modalDialog(
                title = HTML(glue("{data_boton()$actividade}: <b>{data_boton()$Emprendedora}</b>")),
                HTML(glue(
                  '<b>Evento:</b> {data_boton()$Nome_do_evento} <br>
                  <b>Facilitadora/Agente:</b> {data_boton()$Facilitadora}<br>
                  <b>Data do evento:</b> {data_boton()$data_evento} <br>
                  <b>Status:</b> {data_boton()$Status}
                  '
                )),
                easyClose = TRUE,
                footer = NULL
              )) #show modal
            }) #observe event input$id



          }) #lapply botones
          
          
        }) #Observe event data agente
        
        #serverAgendadas(active, presencas)
      } else if(active %in% agendadas) {
        serverAgendadas(active, presencas)
        
      }
      
      
     
      
    }
    
    
  })
  
})





#Password admin ===============================================================
#"Feedback", "sessoes_fnm", "modulos_sgr", "sessoes_sgr_fnm"
paneles <- c("Admin")

lapply(paneles, function(x){
  
  observe({
    if (input$Paneles == x)  {
      
      showModal(
        ModalAdmin()
      )
      
    }
  })
  
  
})
  
  

  
  observeEvent(input$ok,{
    
    password_user <- data_login$password[data_login$user == input$user]
    
    #If user doesnt exist
    if(length(password_user)==0){
      
      showModal(
        ModalAdmin(TRUE)
      ) 
      #if password is incorrect
    } else if(input$password != password_user){
      
      showModal(
        ModalAdmin(TRUE)
      ) 
    } else {
      
      removeModal()
    }
   
    
    
  })
  
  
  serverAdmin("admin")
  
}

shinyApp(ui, server)
