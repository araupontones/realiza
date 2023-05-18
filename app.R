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
             
             
             navbarMenu("test",
                        tabPanel("Test",
                                 value = "test",
                                 tableOutput("table")
                                 
                        )
                        ),
             
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
        title = "Informacao do evento",
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
  
 
  
  output$table <- renderTable({
    divs
    
    # DT::datatable(
    #   divs,
    #   escape = F,
    #   rownames = F,
    #   options = list(pageLength = 25,
    #                  dom = 't',
    #                  ordering = F,
    #                  selection = 'single'
    #                  #selector = "td:not(.not-selectable)"
    #                  )
    # )
    
  }, sanitize.text.function = function(x) x)
  
last_refreshed <- rio::import("data/2.Dashboard/last_refreshed.rds")

output$last_refreshed <- renderUI({
  
  text <- paste("Última atualização:", last_refreshed)
  
  p(text)
})

  
#Server grupos  ================================================================
#Activate the servers of each gropu when the tab is selected
#For this to work the name id of the uis and values of panel should be consisten
#See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
                     tipos = c("sessoes", "modulos", "cidades", "agenda"),
                     input,
                     session
                     )

  



#server summary ================================================================
serverOverview("overview") 
serverSummary("summary")
  
  observe({
    
    print(input$Paneles)
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