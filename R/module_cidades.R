#Module sessoes
library(dplyr)
library(ggplot2)

ui_cidades <- function(id){
  
  tagList(
    
    
    sidebarLayout(
      sidebarPanel(width = 2,
                   #Inputs Cidade
                   selectInput(NS(id,"cidades"), "Cidade",
                               c("Beira", "Maputo", "Nampula")
                   )
                  
      ),
      mainPanel(width = 10,
                #Header of Agente (name and % of assistance)
                uiOutput(NS(id,"header")),
                #table with presences
                plotOutput(NS(id,"plot"))
      )
    )
    
    
    
  )
  
}



#Server ======================================================================
serverCidade <- function(id, grupo) {
  moduleServer(id, function(input, output, session) {
    
    if(grupo %in% c("sgr", "fnm")){
      
      infile_stats <- glue::glue("data/2.Dashboard/{grupo}_stats.rds") 
      data_stats <- rio::import(infile_stats) %>% dplyr::filter(grupo_accronym == define_accronym(grupo))
      
    } else {
      
      infile_stats_sgr <- glue::glue("data/2.Dashboard/sgr_stats.rds") 
      infile_stats_fnm <- glue::glue("data/2.Dashboard/fnm_stats.rds") 
      
      data_stats_fnm <- rio::import(infile_stats_fnm) %>% dplyr::filter(grupo_accronym == define_accronym(grupo))
      data_stats_sgr <- rio::import(infile_stats_sgr) %>% dplyr::filter(grupo_accronym == define_accronym(grupo))
      
      data_stats <- plyr::rbind.fill(data_stats_sgr, data_stats_fnm)
    }
   
    
    #Reactive elements ========================================================
    
    
    confirmadas <- reactive({
      
      length(unique(
      data_stats$Emprendedora[data_stats$status_realiza == "CONFIRMADA" & data_stats$Cidade == input$cidades]
      ))
      
    })      
    
    #react to selected cidade
    data_cidade <- reactive({
      
      data_stats %>%
        dplyr::filter(Cidade == input$cidades,
                      status_realiza == "CONFIRMADA") %>%
        group_by(actividade_label) %>%
        avg_presencas()
    })
    
   
    #Summary of all cidades
    data_all <- data_stats %>%
      group_by(actividade_label) %>%
     avg_presencas()
    
    
    
    
    #Main page ================================================================
    
    
    output$header <- renderUI({
      #get average of presencas of this agente
      avg <- scales::percent(mean(data_cidade()$presencas_avg_num, na.rm =T))
      
      tags$div(
      h1(input$cidades),
      h2(glue("{confirmadas()} emprendedoras confirmadas")),
      h3(paste0("Taxa de presenças (das confirmadas): ", avg))
     
     
      )
      
    })
    
    output$plot <- renderPlot({
      
      data_cidade() %>%
        ggplot(aes(x = actividade_label,
                   y = presencas_avg_num)
               
               ) +
        geom_col() +
        
        geom_point(data = data_all,
                   aes(x = actividade_label,
                       y = presencas_avg_num,
                       fill = "blue"),
                   shape = 21,
                   size = 4
        ) +
        scale_fill_manual(name = "Avg.Realiza (tudas cidades)",
                          breaks = "blue",
                          values = c("blue")) +
        scale_y_continuous(labels = function(x){x*100})
      
    })
    
    
    
 
    
  })
}