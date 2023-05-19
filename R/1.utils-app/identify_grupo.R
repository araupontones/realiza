#'@description the naming of the ids of the modules always include the name of
#'the grupo. Thus, to avoid the use of if statements, this function detects the 
#'group and returns the name of the group used in the data.


identify_grupo <- function(tab){
  
  if(str_detect(tab, "cresca")){
    
    grupo = "Cresça"
  } else if(str_detect(tab, "movimenta")){
    
    grupo = "Movimenta"
  } else if(str_detect(tab, "conecta")){
    
    grupo = "Conecta"
  } else {
    
    stop('The value must include any of "cresca", "movimenta" or "conecta"')
  }
  
  return(grupo)
  
}
