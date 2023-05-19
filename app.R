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
             
             # 
             # navbarMenu("test",
             #            tabPanel("Test",
             #                     value = "test_cresca",
             #                     tableOutput("table")
             #                     
             #            )
             #            ),
             
             #the value of the selected panel is defined within panels_cresca()
             panels_cresca_conecta(title = "Cresça" , value = "modulos_cresca"),
             panels_cresca_conecta(title = "Conecta" , value = "sessoes_conecta"),
             panels_cresca_conecta(title = "Movimienta" , value = "sessoes_movimenta"),
             
            panels_FNM("FNM"),
             
            panels_SGR("SGR"),
             
            panels_SGR_FNM("FNM + SGR"),
             
            panel_powerBI("Feedback"),
            
            tabPanel("Admin",
                     ui_admin("admin")),
             
         
                       
                 
           
            
            
  )
)




server <- function(input, output, session) {
#read presencas
  presencas <- rio::import("data/1.zoho/2.clean_reports_zoho.rds")
#read divs 
  divs <- rio::import('data/2.Dashboard/divs.rds')
  
  
#To check which is the active panel
  observe({

    print(active_grupo())
  })
  
  
#reactive data =================================================================
  #get the active group
  #for this function to work, all the values of the panels must include the words
  #cresca,moviementa or conecta
  
  active_grupo <- reactive({identify_grupo(input$Paneles)})
  
  # data_grupo <- reactive({
  #   
  #   #print(identify_grupo(input$Paneles))
  #   
  #   presencas %>%
  #     filter(Grupo == active_grupo())
  #   
  # })
  # 
  
#created in R_/3/
#get the id of all the botones
#This ID is created in R_/clean_repors.R
  botones <- c(presencas$rec_id)

  

  
  
  lapply(botones, function(id){
  
  
    data_boton <- reactive(
      
      filter(presencas, rec_id == id)
    )
    
    
      
    observeEvent(input[[id]], {
      showModal(modalDialog(
        title = HTML(glue("<b>{data_boton()$Emprendedora}</b> -Informacao do evento")),
        HTML(glue(
          '<b>Evento:</b> {data_boton()$Nome_do_evento} <br>
          <b>Facilitadora/Agente:</b> {data_boton()$Facilitadora}<br>
          <b>Data do evento:</b> {data_boton()$data_evento} <br>
          <b>Status:</b> {data_boton()$Status}
          '
        )),
        easyClose = TRUE,
        footer = NULL
      ))
    })
    
    
    
  })
  
 
  
 
  
last_refreshed <- rio::import("data/2.Dashboard/last_refreshed.rds")

output$last_refreshed <- renderUI({
  
  text <- paste("Última atualização:", last_refreshed)
  
  p(text)
})


#New server grupos ============================================================

rupos <- c("movimenta", "cresca", "conecta")
sessoes <- paste(c("sessoes"), grupos , sep = "_")
modulos <- paste(c("modulos"), grupos , sep = "_")

sessoes_modulos <- c(sessoes, modulos)


lapply(sessoes_modulos, function(active){
  
 
  observe({
    
    if(input$Paneles == active){
      message(paste("active panel:", active))
      serverSessoesObrigatorias(active, presencas)
      
    }
    
    
  })
  
})



#Server grupos  ================================================================
#Activate the servers of each gropu when the tab is selected
#For this to work the name id of the uis and values of panel should be consisten
#See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
# activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
#                      tipos = c("sessoes", "modulos", "cidades", "agenda"),
#                      input,
#                      session
#                      )

  



#server summary ================================================================
serverOverview("overview") 
serverSummary("summary")
  
  # observe({
  #   
  #   print(input$Paneles)
  # })
  
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