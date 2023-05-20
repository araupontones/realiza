#'@description Define the activities that belong to FNM and the labels that are
#'to be used in their charts
#' This vector is used many times in the code to:
#' 1. identify activities that belong to FNM
#' 2. Order activities 
#' 3. Create labels for graphs


#vector of activities-----------------------------------------------------------
activities_fnm <- c(   "Sessão Inaugural" ,
                       "De mulher para mulher: Conecta!" ,
                       "Eventos de matchmaking" ,
                       "Eventos de networking" ,
                       #feira financeira
                       "Feira Financeira" ,
                       #"Modulos Obligatorios" ,
                       "Sessões de coaching",
                       "Sessões individuais",
                       "Workshops temáticos" 
)



#clean names for better display ---------------------------------------------
recode_fnm <- function(activities_fnm){
  
  recode(activities_fnm,  
         "Sessão Inaugural" = "Inaugural",
         "De mulher para mulher: Conecta!" = "Conecta",
         "Eventos de matchmaking" = "Matchmaking",
         "Eventos de networking" = "Networking",
         #feira financeira
         "Feira Financeira" = "Feiras",
         "Modulos Obligatorios" = "Modulos",
         "Sessões de coaching" = "Coaching",
         "Sessões individuais" = "Individuais",
         "Workshops temáticos" = "Workshops"
  )
  
}
