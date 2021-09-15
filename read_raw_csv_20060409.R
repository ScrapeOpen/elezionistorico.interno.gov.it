library(tidyverse)
library(sf)
library(stringi)

camera_italia.20060409 <- 
  rbind(read.csv("raw_csv_20060409/camera_italia-20060409.txt", sep=";",
                 encoding = "latin1") %>% 
        dplyr::mutate(VOTI_LISTA = VOTILISTA) %>%
          dplyr::select(-VOTILISTA),
        read.csv("raw_csv_20060409/camera_vaosta-20060409.txt", sep=";",
                 encoding = "latin1") %>%
          dplyr::mutate(CIRCOSCRIZIONE = "VALLE D'AOSTA",
                        PROVINCIA = "VALLE D'AOSTA",
                        ELETTORI = ELETTORI_TOTALI,
                        VOTANTI = VOTANTI_TOTALI) %>%
          dplyr::select(CIRCOSCRIZIONE, PROVINCIA, COMUNE, ELETTORI, ELETTORI_MASCHI,
                        VOTANTI, VOTANTI_MASCHI, SCHEDE_BIANCHE, LISTA, VOTI_LISTA))

comuni2006.sf <-
  read_sf("raw_shp_20060413/Com01012006_WGS84.shp")

comune_minint_2006 <- 
  data.frame(
    provincia = camera_italia.20060409$PROVINCIA,
    original = camera_italia.20060409$COMUNE) %>%
  dplyr::distinct(provincia, original) %>%
  dplyr::mutate(clean = 
                  stri_trans_general(str = tolower(gsub("'$", "", gsub("' |-|' ", " ", original))), 
                                     id = "Latin-ASCII"))
comune_istat_2006 <- 
  data.frame(
    PRO_COM_T = comuni2006.sf$PRO_COM_T,
    original = comuni2006.sf$COMUNE) %>%
  dplyr::distinct(PRO_COM_T, original) %>%
  dplyr::mutate(clean = 
                  stri_trans_general(str = tolower(gsub("'$", "", gsub("' |-|' ", " ", original))), 
                                     id = "Latin-ASCII"))  

comune_minint_2006$clean[comune_minint_2006$clean == "zeme lomellina"] <- "zeme" 
comune_minint_2006$clean[comune_minint_2006$clean == "sannicandro garganico"] <- "san nicandro garganico"
comune_minint_2006$clean[comune_minint_2006$clean == "cerrina"] <- "cerrina monferrato"
comune_minint_2006$clean[comune_minint_2006$clean == "cerreto langhe"] <- "cerretto langhe"
comune_minint_2006$clean[comune_minint_2006$clean == "cassano all ionio"] <- "cassano all'ionio"
comune_minint_2006$clean[comune_minint_2006$clean == "viale d'asti"] <- "viale" 
comune_minint_2006$clean[comune_minint_2006$clean == "monte grimano"] <- "monte grimano terme"
comune_minint_2006$clean[comune_minint_2006$clean == "roncegno"] <- "roncegno terme" 
comune_minint_2006$clean[comune_minint_2006$clean == "ruffre' mendola"] <- "ruffre mendola"
comune_minint_2006$clean[comune_minint_2006$clean == "montecompatri"] <- "monte compatri" 
comune_minint_2006$clean[comune_minint_2006$clean == "montebello ionico"] <- "montebello jonico" 
comune_minint_2006$clean[comune_minint_2006$clean == "santo stino di livenza"] <- "san stino di livenza"
comune_minint_2006$clean[comune_minint_2006$clean == "puegnago del garda"] <- "puegnago sul garda" 
comune_minint_2006$clean[comune_minint_2006$clean == "monticello"] <- "monticello brianza"
comune_minint_2006$clean[comune_minint_2006$clean == "santo stino di livenza"] <- "san stino di livenza" 
comune_minint_2006$clean[comune_minint_2006$clean == "massafiscaglia"] <- "massa fiscaglia"
comune_minint_2006$clean[comune_minint_2006$clean == "iolanda di savoia"] <- "jolanda di savoia" 

comune_minint_2006$clean[comune_minint_2006$clean == "ro ferrarese"] <- "ro" 
comune_minint_2006$clean[comune_minint_2006$clean == "baiardo"] <- "bajardo"
comune_minint_2006$clean[comune_minint_2006$clean == "cosio di arroscia"] <- "cosio d'arroscia"
comune_minint_2006$clean[comune_minint_2006$clean == "san remo"] <- "sanremo"

comune_minint_2006$clean[comune_minint_2006$clean == "lonato"] <- "lonato del garda" 
comune_minint_2006$clean[comune_minint_2006$clean == "pre' saint didier"] <- "pre saint didier" 
comune_minint_2006$clean[comune_minint_2006$clean == "san dorligo della valle"] <- "san dorligo della valle dolina" 

comune_minint_2006$clean[comune_minint_2006$clean == "cerreto delle langhe"] <- "cerretto langhe" 
comune_minint_2006$clean[comune_minint_2006$clean == "nughedu  san nicolo"] <- "nughedu san nicolo" 

comune_minint_2006$clean[comune_minint_2006$clean == "reana del roiale"] <- "reana del rojale" 
comune_minint_2006$clean[comune_minint_2006$clean == "ruffre"] <- "ruffre mendola" 

comune_minint_2006$clean[comune_minint_2006$clean == "massalubrense"] <- "massa lubrense" 
comune_minint_2006$clean[comune_minint_2006$clean == "nocera tirinese"] <- "nocera terinese" 
comune_minint_2006$clean[comune_minint_2006$clean == "poiana maggiore"] <- "pojana maggiore" 
comune_minint_2006$clean[comune_minint_2006$clean == "lonato del garda"] <- "lonato" 
comune_minint_2006$clean[comune_minint_2006$clean == "serra de'conti"] <- "serra de conti" 
comune_minint_2006$clean[comune_minint_2006$clean == "torella de lombardi"] <- "torella dei lombardi" 
comune_minint_2006$clean[comune_minint_2006$clean == "costa di serina"] <- "costa serina" 
comune_minint_2006$clean[comune_minint_2006$clean == "monte castello"] <- "montecastello" 
comune_minint_2006$clean[comune_minint_2006$clean == "aquila di arroscia"] <- "aquila d'arroscia" 
comune_minint_2006$clean[comune_minint_2006$clean == "montalbano ionico"] <- "montalbano jonico" 
comune_minint_2006$clean[comune_minint_2006$clean == "castel mola"] <- "castelmola" 
comune_minint_2006$clean[comune_minint_2006$clean == "monaciilioni"] <- "monacilioni" 
comune_minint_2006$clean[comune_minint_2006$clean == "colledanchise"] <- "colle d'anchise" 
comune_minint_2006$clean[comune_minint_2006$clean == "boiano"] <- "bojano" 
comune_minint_2006$clean[comune_minint_2006$clean == "castronuovo di sicilia"] <- "castronovo di sicilia" 
comune_minint_2006$clean[comune_minint_2006$clean == "serra s. abbondio"] <- "serra sant'abbondio" 
comune_minint_2006$clean[comune_minint_2006$clean == "montegrimano"] <- "monte grimano terme" 
comune_minint_2006$clean[comune_minint_2006$clean == "santa vittoria in matemano"] <- "santa vittoria in matemano" 
comune_minint_2006$clean[comune_minint_2006$clean == "truggio"] <- "triuggio" 
comune_minint_2006$clean[comune_minint_2006$clean == "santa teresa di gallura"] <- "santa teresa gallura" 

comune_minint_2006$clean[comune_minint_2006$clean == "gonnasfanadiga"] <- "gonnosfanadiga" 

comune_minint_2006$clean[comune_minint_2006$clean == "buia"] <- "buja" 

# comune_minint_2006$clean[comune_minint_2006$clean == "calliano tn"] <- ???
# comune_minint_2006$clean[comune_minint_2006$clean == "valverde ct"] <- ???
# comune_minint_2006$clean[comune_minint_2006$clean == "samone tn"] <- ???
# comune_minint_2006$clean[comune_minint_2006$clean == "livo tn"] <- ???

comune_minint_2006$clean[comune_minint_2006$clean == "santa vittoria in matemano"] <- 
  "santa vittoria in matenano" 

comune_minint_2006$clean[!comune_minint_2006$clean %in%
                           comune_istat_2006$clean]

comune_istat_2006$clean[!comune_istat_2006$clean
                        %in% comune_minint_2006$clean]

comune_minint_2006$PRO_COM_T <- 
  comune_istat_2006$PRO_COM_T[match(comune_minint_2006$clean,
                                    comune_istat_2006$clean)]


comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "TRENTO" &
                               comune_minint_2006$original == "LIVO TN"] <- "022106"
comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "TRENTO" &
                               comune_minint_2006$original == "SAMONE TN"] <- "022165"
comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "CATANIA" &
                               comune_minint_2006$original == "VALVERDE CT"] <- "087052"
comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "TRENTO" &
                               comune_minint_2006$original == "CALLIANO TN"] <- "022035"
comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "BRESCIA" &
                               comune_minint_2006$original == "BRIONE"] <- "017030"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "TRENTO" &
                               comune_minint_2006$original == "CAGNO'"] <- "022030"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "LECCE" &
                               comune_minint_2006$original == "CASTRO"] <- "075096"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "CATANIA" &
                               comune_minint_2006$original == "PATERNO'"] <- "087033"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "COMO" &
                               comune_minint_2006$original == "PEGLIO"] <- "013178"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "OLBIA-TEMPIO" &
                               comune_minint_2006$original == "SAN TEODORO"] <- "104023"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "PESARO E URBINO" &
                               comune_minint_2006$original == "PEGLIO"] <- "041041"

comune_minint_2006$PRO_COM_T[comune_minint_2006$provincia == "BRESCIA" &
                               comune_minint_2006$original == "BRIONE"] <- "017030"


camera_italia.20060409 <-
  merge(camera_italia.20060409, 
        comune_minint_2006,
        by.x = c("PROVINCIA", "COMUNE"),
        by.y = c("provincia", "original"))


camera_italia.20060409$VOTI_LISTA_num <- 
  as.numeric(gsub(",00", "", camera_italia.20060409$VOTI_LISTA))

open_csv_20060409_camera_geo_count <- 
  camera_italia.20060409 %>%
  dplyr::mutate(election = "Camera",
                date = "2006-04-09",
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

open_csv_20060409_camera_party_count <- 
  camera_italia.20060409 %>%
  dplyr::mutate(election = "Camera",
                date = "2006-04-09",
                geo_lev_1 = CIRCOSCRIZIONE,
                geo_lev_2 = PROVINCIA,
                geo_entity = COMUNE,
                istat_cod = PRO_COM_T,
                party = LISTA,
                party_votes = VOTI_LISTA_num) %>%
  dplyr::select(election:party_votes)

write.csv(open_csv_20060409_camera_geo_count, 
          file = "open_csv_20060409_camera_geo_count.csv",
          row.names = F)

write.csv(open_csv_20060409_camera_party_count, 
          file = "open_csv_20060409_camera_party_count.csv",
          row.names = F)
