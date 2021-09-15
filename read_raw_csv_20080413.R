library(tidyverse)
library(sf)
library(stringi)

camera_italia.20080413 <- 
  rbind(read.csv("raw_csv_20080413/camera_italia-20080413.txt", sep=";"),
        read.csv("raw_csv_20080413/camera_vaosta-20080413.txt", sep=";") %>%
          dplyr::mutate(CIRCOSCRIZIONE = "VALLE D'AOSTA",
                        PROVINCIA = "VALLE D'AOSTA",
                        ELETTORI = ELETTORI_TOTALI,
                        VOTANTI = VOTANTI_TOTALI) %>%
          dplyr::select(CIRCOSCRIZIONE, PROVINCIA, COMUNE, ELETTORI, ELETTORI_MASCHI,
                        VOTANTI, VOTANTI_MASCHI, SCHEDE_BIANCHE, LISTA, VOTI_LISTA))


comuni2008.sf <-
  read_sf("raw_shp_20080413/Com01012008_WGS84.shp")

comune_minint_2008 <- 
  data.frame(
    provincia = camera_italia.20080413$PROVINCIA,
    original = camera_italia.20080413$COMUNE) %>%
  dplyr::distinct(provincia, original) %>%
  dplyr::mutate(clean = 
                  stri_trans_general(str = tolower(gsub("'$", "", gsub("' |-|' ", " ", original))), 
                                     id = "Latin-ASCII"))
comune_istat_2008 <- 
  data.frame(
    PRO_COM_T = comuni2008.sf$PRO_COM_T,
    original = comuni2008.sf$COMUNE) %>%
  dplyr::distinct(PRO_COM_T, original) %>%
  dplyr::mutate(clean = 
                  stri_trans_general(str = tolower(gsub("'$", "", gsub("' |-|' ", " ", original))), 
                                     id = "Latin-ASCII"))  

comune_minint_2008$clean[comune_minint_2008$clean == "zeme lomellina"] <- "zeme" 
comune_minint_2008$clean[comune_minint_2008$clean == "sannicandro garganico"] <- "san nicandro garganico"
comune_minint_2008$clean[comune_minint_2008$clean == "cerrina"] <- "cerrina monferrato"
comune_minint_2008$clean[comune_minint_2008$clean == "cerreto langhe"] <- "cerretto langhe"
comune_minint_2008$clean[comune_minint_2008$clean == "cassano all ionio"] <- "cassano all'ionio"
comune_minint_2008$clean[comune_minint_2008$clean == "viale d'asti"] <- "viale" 
comune_minint_2008$clean[comune_minint_2008$clean == "monte grimano"] <- "monte grimano terme"
comune_minint_2008$clean[comune_minint_2008$clean == "roncegno"] <- "roncegno terme" 
comune_minint_2008$clean[comune_minint_2008$clean == "ruffre' mendola"] <- "ruffre mendola"
comune_minint_2008$clean[comune_minint_2008$clean == "montecompatri"] <- "monte compatri" 
comune_minint_2008$clean[comune_minint_2008$clean == "montebello ionico"] <- "montebello jonico" 
comune_minint_2008$clean[comune_minint_2008$clean == "santo stino di livenza"] <- "san stino di livenza"
comune_minint_2008$clean[comune_minint_2008$clean == "puegnago del garda"] <- "puegnago sul garda" 
comune_minint_2008$clean[comune_minint_2008$clean == "monticello"] <- "monticello brianza"
comune_minint_2008$clean[comune_minint_2008$clean == "santo stino di livenza"] <- "san stino di livenza" 
comune_minint_2008$clean[comune_minint_2008$clean == "massafiscaglia"] <- "massa fiscaglia"
comune_minint_2008$clean[comune_minint_2008$clean == "iolanda di savoia"] <- "jolanda di savoia" 

comune_minint_2008$clean[comune_minint_2008$clean == "ro ferrarese"] <- "ro" 
comune_minint_2008$clean[comune_minint_2008$clean == "baiardo"] <- "bajardo"
comune_minint_2008$clean[comune_minint_2008$clean == "cosio di arroscia"] <- "cosio d'arroscia"
comune_minint_2008$clean[comune_minint_2008$clean == "san remo"] <- "sanremo"

comune_minint_2008$clean[comune_minint_2008$clean == "lonato"] <- "lonato del garda" 
comune_minint_2008$clean[comune_minint_2008$clean == "pre' saint didier"] <- "pre saint didier" 
comune_minint_2008$clean[comune_minint_2008$clean == "san dorligo della valle"] <- "san dorligo della valle dolina" 


comune_minint_2008$clean[!comune_minint_2008$clean %in%
                           comune_istat_2008$clean]

comune_istat_2008$clean[!comune_istat_2008$clean
                        %in% comune_minint_2008$clean]

comune_minint_2008$PRO_COM_T <- 
  comune_istat_2008$PRO_COM_T[match(comune_minint_2008$clean,
                                    comune_istat_2008$clean)]

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "BRESCIA" &
                               comune_minint_2008$original == "BRIONE"] <- "017030"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "TRENTO" &
                               comune_minint_2008$original == "CAGNO'"] <- "022030"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "TRENTO" &
                               comune_minint_2008$original == "CALLIANO"] <- "022035"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "LECCE" &
                               comune_minint_2008$original == "CASTRO"] <- "075096"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "TRENTO" &
                               comune_minint_2008$original == "LIVO"] <- "022106"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "CATANIA" &
                               comune_minint_2008$original == "PATERNO'"] <- "087033"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "COMO" &
                               comune_minint_2008$original == "PEGLIO"] <- "013178"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "TRENTO" &
                               comune_minint_2008$original == "SAMONE"] <- "022165"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "OLBIA-TEMPIO" &
                               comune_minint_2008$original == "SAN TEODORO"] <- "104023"

comune_minint_2008$PRO_COM_T[comune_minint_2008$provincia == "CATANIA" &
                               comune_minint_2008$original == "VALVERDE"] <- "087052"

camera_italia.20080413 <-
  merge(camera_italia.20080413, 
        comune_minint_2008,
        by.x = c("PROVINCIA", "COMUNE"),
        by.y = c("provincia", "original"))


camera_italia.20080413$VOTI_LISTA_num <- 
  as.numeric(gsub(",00", "", camera_italia.20080413$VOTI_LISTA))

open_csv_20080413_camera_geo_count <- 
  camera_italia.20080413 %>%
  dplyr::mutate(election = "Camera",
                date = "2008-04-13",
                geo_lev_1 = CIRCOSCRIZIONE,
                geo_lev_2 = PROVINCIA,
                geo_entity = COMUNE,
                istat_cod = PRO_COM_T,
                registered_voters = as.numeric(ELETTORI),
                registered_male_voters = as.numeric(ELETTORI_MASCHI),
                effective_voters =  as.numeric(VOTANTI),
                effective_male_voters = as.numeric(VOTANTI_MASCHI),
                blank_votes =  as.numeric(SCHEDE_BIANCHE),
                VOTI_LISTA = VOTI_LISTA_num) %>%
  dplyr::group_by(election, date, geo_lev_1, geo_lev_2, geo_entity,
                  istat_cod, 
                  registered_voters, registered_male_voters, 
                  effective_voters, effective_male_voters,
                  blank_votes) %>%
  dplyr::summarise(tot_party_votes = sum(VOTI_LISTA))

open_csv_20080413_camera_party_count <- 
  camera_italia.20080413 %>%
  dplyr::mutate(election = "Camera",
                date = "2008-04-13",
                geo_lev_1 = CIRCOSCRIZIONE,
                geo_lev_2 = PROVINCIA,
                geo_entity = COMUNE,
                istat_cod = PRO_COM_T,
                party = LISTA,
                party_votes = VOTI_LISTA_num) %>%
  dplyr::select(election:party_votes)

write.csv(open_csv_20080413_camera_geo_count, 
          file = "open_csv_20080413_camera_geo_count.csv",
          row.names = F)

write.csv(open_csv_20080413_camera_party_count, 
          file = "open_csv_20080413_camera_party_count.csv",
          row.names = F)
