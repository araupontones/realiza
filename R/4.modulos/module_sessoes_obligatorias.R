#Module sessoes
library(dplyr)
ui_sessoes_obligatorias <- function(id){
  
  #Define the title of the main selector (agente for fnm, Turma for sgr)
  #this is based on the id given by the user
  #the id must contain cresca, movimenta or conecta for this to work
  title_selector <- define_selector(identify_grupo(id))
 
  
  tagList(
    
    
    sidebarLayout(
      sidebarPanel(width = 2,
                   #Inputs Cidade
                   selectInput(NS(id,"cidades"), "Cidade",
                               c("Maputo", "Nampula", "Beira"),
                               selected = "Maputo"
                   ),
                   
                   #Inputs Agente
                   selectInput(NS(id,"agentes"), title_selector,
                               c("")
                   )
      ),
      mainPanel(width = 10,
                #Header of Agente (name and % of assistance)
                uiOutput(NS(id,"header")),
                #table with presences
                withSpinner(tableOutput(NS(id,"table")), color = 'black')
      )
    )
    
    
    
  )
  
}



#Server ======================================================================
serverSessoesObrigatorias <- function(id,
                                      data_presencas
                                      #grupo, 
                                      ) {
  moduleServer(id, function(input, output, session) {
    

    #Sessoes obligatorias del grupo
    sessoes_obligatorias = 9
    #to fetch which grupo this is about
    grupo <- reactive({

      identify_grupo(id)

    })
    
    mode <- identify_mode(id)
    
    #message(id)
    actividades_panel <- identify_actividades(id)
    
    
    
#Update data for this panel based on user inputs ===============================
    data_panel <- reactive({
      
      dt <- data_presencas 
      #%>%
       # filter(actividade %in% actividades_panel)
      
      #for the modulos, the selector is the Turma
      if(mode == "modulos"){
        
        dt <- dt %>%
          select(-Facilitadora) %>%
          rename(Facilitadora = Turma)
        
      }
      
      #for sessoes Facilitadora remains
      dt <- dt %>%
        filter(Cidade == input$cidades) %>%
        filter(Grupo == grupo())
      
      #print(tabyl(dt, Grupo))  
      #print(tabyl(dt, Facilitadora))
      
      dt
      
    })
    
#Update list of agentes =======================================================
    
    agentes_reactive <- reactive({

      
            sort(unique(data_panel()$Facilitadora))

    })
    
    label_reactive <- reactive({

      #identify mode is defined in R/utils-app
      #it returns either modulos or sessoes
      if(identify_mode(id) == "modulos"){

        label = "Turma"

      } else {

        label = "Agente"
      }

      label

    })
    
    #update options of input agentes
    observeEvent(agentes_reactive(),{

      updateSelectInput(session, "agentes",
                        label = label_reactive(),
                        choices =  sort(unique(data_panel()$Facilitadora))

      )

    })

  
#update data of user based on selected agente =================================

    data_agente <- reactive(

      data_panel() %>%
        filter(Facilitadora == input$agentes)
    )



# #data stats agente ============================================================


    stats_agente <- reactive(
      data_agente() %>%
        #count presencas by emprendedoras
        group_by(Emprendedora, Facilitadora) %>%
        #count whether emprendedoras have completed sessoes obligatorias
        summarise(sessoes = sum(agendada, na.rm = T),
                  presencas = sum(presente, na.rm = T),
                  #sesoes obligatorias is defined at the begining of the script
                  #it varies based on the grupo
                  cumple_obligatorias = presencas == sessoes_obligatorias,
                  .groups = 'drop'
                   ) %>%
        group_by(Facilitadora) %>%
        summarise(emprendedoras = n(),
                  sessoes = sum(sessoes, na.rm = T),
                  presencas = sum(presencas, na.rm = T),
                  avg = scales::percent(presencas/sessoes),
                  cumple_obligatorias = sum(cumple_obligatorias, na.rm = 1),
                  avg_cumple = cumple_obligatorias/emprendedoras,
                  .groups = 'drop'
                  )


        )



# # Transform data to botones ===================================================

    output$table <- renderTable({
      data_agente() %>%
        crear_data_botones(.)

      #divs


    }, sanitize.text.function = function(x) x)



    output$header <- renderUI({
      #print(id)
      #get average of presencas of this agente
      avg <- stats_agente()$avg
      avg_cumple <- stats_agente()$avg_cumple

      tags$div(
      h1(identify_grupo(id)),
      h3(paste0(input$agentes), tags$span(class = "media-presencas", "- Média de presenças: ", avg, "| Completo numero de sessoes obligatorias:", avg_cumple)),
      tags$p(class = "note",
             "O número de bolinhas representa o número de sessões agendadas por tipo de evento."
      ),
        tags$div(
          #created in R/define_parameters_grupos.R
          define_legend(x = id)
        )

      )

    })


    
   
    
  })
}