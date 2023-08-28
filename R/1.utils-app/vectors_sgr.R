#'@description Define the activities that belong to SGR and the labels that are
#'to be used in their charts
#' This vector is used many times in the code to:
#' 1. identify activities that belong to SGR
#' 2. Order activities 
#' 3. Create labels for graphs



activities_sgr <- c( "Sessão Inaugural" ,
                     "1.1",
                    "Introducao a sessao de parceiros",
                    "1.2", "1.3",
                    "2.1", "2.2", "2.3",
                    "Sessao intercalar de parceiros",  
                    "3.1", "3.2", "3.3",
                    "Sessao de encerramento de parceiros",
                    "Sessões de coaching 1",
                    "Sessões de coaching 2",
                    "Sessões de coaching 3",
                    "Sessões de coaching 4",
                    #added on august 28 2023 because Dercio asked
                    "Sessões individuais"
                    
)


#clean names for better display ---------------------------------------------
recode_sgr <- function(activities_sgr){
  
  recode(activities_sgr,  
         "Sessão Inaugural" = "Inaugural",
         "Introducao a sessao de parceiros" = "Intro parceiros",
         "Sessao intercalar de parceiros" = "Intercalar parceiros",
         "Sessao de encerramento de parceiros" = "Encerramento parceiros",
         "Sessões de coaching 1" = "Coaching 1",
         "Sessões de coaching 2" =  "Coaching 2",
         "Sessões de coaching 3" =  "Coaching 3",
         "Sessões de coaching 4" =  "Coaching 4",
         #added on august 28 2023 because Dercio asked
         "Sessões individuais" = "Individuais")
  
}