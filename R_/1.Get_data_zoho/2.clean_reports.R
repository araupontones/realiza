cli::cli_alert_info("Cleaning reports------------------------------------------")

#'@Description Takes all the downloeaded reports and creates a single and 
#'clean data with all the presencas. This data has the following columns:
#' from_report: Zoho report from which the record comes
#' actividade
#' Cidade
#' Data_do_registro: Date when activity was scheduled
#' data_Evento: Date when evento occured
#' Emprendedora
#' Facilitadora
#' Grupo
#' Modulo
#' Nome_do_evento: Unique name for each evento
#' Parceiro: Status of the parceiro to the evento
#' Status: Presente, Ausente, Pendente
#' Turma
#' agendada: TRUE/FALSE
#' presente: TRUE/FALSE
#' ausente: TRUE/FALSE


source('R/0.define_paths.R', encoding = 'UTF-8') #define paths
gmdacr::load_functions('functions')

#Import all raw reports=========================================================
#These reports are created in R_/1.Download reports
# all the reports are saved into a single list object
raw_data <- import(path_raw_data) 
emprendedoras <- import('data/0look_ups/emprendedoras.rds')

#clean the names of the variables of all the reports
#For each report in the list
clean_names <- lapply(seq_along(raw_data), function(i){
  
  #get the name of the report
  from_report <- as.character(names(raw_data[i]))
  
  #get the data of the report
  report <- raw_data[[i]]
  
  #delete redundant variables and create one that identifies which resource
  #the record is comming from
  report <- report %>% select(-ends_with("ID")) %>%
    mutate(from_report = from_report)
  
  #some names come with a prefix that indicate the table of origin of the variables
  #this is redundant for us
  #so lets remove them
  has_dots <- which(str_detect(names(report), "\\.")) #identify those variables
  names(report)[has_dots] <- str_extract(names(report)[has_dots],'(?<=\\.).*') # remove the prefix
  
  #make names consistent accross forms
  n <- names(report)
  names(report)[which(n=="Emprendedoras")] <- "Emprendedora"
  names(report)[which(n=="Facilitadoras")] <- "Facilitadora"
  names(report)[which(n=="Grupos")] <- "Grupo"
  names(report)[which(n=="Grupo_fixo")] <- "Turma"
  #for SGR train the Date_Field is the date of the evento
  #And for FNM grupal is Data_e_hora
  names(report)[which(n %in% c("Data_e_hora", "Date_field"))] <- "data_evento"
  
  #For FNM is Presenca and for SGR is status
  names(report)[which(n=="Presenca")] <- "Status"
  
  
  #return the report
  return(report)  
  
})

#append all reports into a single one =========================================


appended <- do.call(plyr::rbind.fill, clean_names) %>%
  #all the IDs from other tables are redundant
  #Presencas fixas is the ID of the activity and it is not needed
  select(-starts_with("ID_"), -Presencas_fixas, -Actividades, -status_realiza, - Grupo) %>%
  #doing this for checking only
  relocate(sort(names(.))) %>%
  #putting the name of the report at the begining to simplify inspection
  relocate(from_report)


#clean discrepancies between reports ===========================================

clean <- appended %>%
  mutate(
    
    #fOR sgr_ind all the sessoes individuais are sessoes de coaching    
    Modulo = ifelse(from_report == "SGR_ind", "Sessões de coaching", Modulo),
    actividade = ifelse(from_report %in% c("SGR_train","SGR_ind"), Modulo, actividade),
    #for fnm_ind, all sessoes individuais are sessoes individuais
    actividade = ifelse(from_report =="FNM_ind", "Sessões individuais", actividade),
    
    #data_evento for the ind the date is the same as data do registro
    data_evento = ifelse(from_report %in% c("FNM_ind","SGR_ind"), Data_do_registro, data_evento),
    
    #create nome do evento for sessoes individuais
    Nome_do_evento = ifelse(actividade == "Sessões individuais",
                            glue("Sessao individual - {Emprendedora} - {data_evento}"),
                            Nome_do_evento),
    
    #and for sessoes inagurais de SGR for each Turma
    Nome_do_evento = ifelse(actividade == "Sessão Inaugural" & from_report == "SGR_train",
                            glue("Sessão Inaugural - {Turma} - {data_evento}"),
                            Nome_do_evento),
    
    #and for sessoes de coaching
    Nome_do_evento = ifelse(actividade == "Sessões de coaching" & from_report == "SGR_ind",
                            glue("Coaching - {Emprendedora} - {data_evento}"),
                            Nome_do_evento),
    
    #and for modulos
    Nome_do_evento = ifelse(!is.na(Modulo) & is.na(Nome_do_evento),
                            glue("Modulo - {Modulo} - {Emprendedora}"),
                            Nome_do_evento
                            ),
    
    #record ID, later used in the bottons of the table
    rec_id = glue('R{row_number()}')
    
    
  )




#clean status of Emprendedora ==================================================



clean_status <- clean %>%
  mutate(Status = ifelse(Status == "", "Pendiente", Status),
         agendada = T,
         presente = Status == "Presente",
         ausente = Status == "Ausente"
         ) %>%
  #artificially create sessos de coaching 1, 2 ,3, 4, etc
  create_coaching(.) %>%
  relocate(from_report, Cidade, Emprendedora, data_evento) %>%
  arrange(Cidade, Emprendedora, data_evento)



#Clean information from emprendedora ==========================================
clean_emprendedoras <- clean_status %>%
  #get the correct grupo and IDs of Emprendedoras
  left_join(emprendedoras %>%select(Emprendedora, Grupo, ID_BM, grupo_accronym),
            by = "Emprendedora") 
  
 

#export
rio::export(clean_emprendedoras, path_clean_presencas)
cli::cli_alert_success(glue::glue("Clean data saved in {path_clean_presencas}"))

#last refreshed ---------------------------------------------------------------
last_refreshed <-Sys.time()
rio::export(last_refreshed, path_last_refreshed)

#remove environment to clean space
rm(list = ls())
