
#'@description remote Realiza & form grupo
remove_grupo_prefix <- function(Grupo){ stringr::str_trim(stringr::str_remove(Grupo, "Realiza & "))}