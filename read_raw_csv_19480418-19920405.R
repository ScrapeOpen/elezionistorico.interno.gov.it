setwd('~/public_git/ScrapeOpen/elezionistorico.interno.gov.it') # Change this!
options(warn=2) # Warnings into errors!

dir <- "~/Downloads/raw_csv_19480418-19920405/" # Change this
files <- list.files(dir)

# Check files
library(stringr)
filename_head <- str_extract(files, "^[A-Z]+-[A-Z][a-z]+")
table(filename_head)

## Missing
files_camera <- files[grepl("Camera", files)]
files_camera_scrutini <- gsub("SCRUTINI-", "", files_camera[grepl("SCRUTINI", files_camera)])
files_camera_liste <- gsub("LISTE-", "", files_camera[grepl("LISTE", files_camera)])
files_camera_scrutini[!files_camera_scrutini %in% files_camera_liste]
files_camera_liste[!files_camera_liste %in% files_camera_scrutini]

files_senato <- files[grepl("Senato", files)]
files_senato_scrutini <- gsub("SCRUTINI-", "", files_senato[grepl("SCRUTINI", files_senato)])
files_senato_liste <- gsub("LISTE-", "", files_senato[grepl("LISTE", files_senato)])
files_senato_scrutini[!files_senato_scrutini %in% files_senato_liste]
files_senato_liste[!files_senato_liste %in% files_senato_scrutini]

# Load
scrutini_list <- list()
liste_list <- list()

# Collegi
getRegioneFromFilename <- function(x) {
    x <- gsub("FRIULI-VENEZIA", "FRIULI~VENEZIA", x)
    x <- gsub("EMILIA-ROMAGNA", "EMILIA~ROMAGNA", x)
    x <- gsub("TRENTINO-ALTO", "TRENTINO~ALTO", x)
    this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
    return(gsub("_", " ", this_split[5]))
}

getDateFromFilename <- function(x) {
  require(stringr)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  return(as.character(as.Date(this_split[3], "%d_%m_%Y")))
}

getTypeFromFilename <- function(x) {
  require(stringr)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  return(this_split[1])
}

getWhatFromFilename <- function(x) {
  require(stringr)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  return(this_split[2])
}


preprocessString <- function(str) {
  require(stringr)
  str <- stri_trans_general(str, "Latin-ASCII")
  str <- gsub("[^[:alnum:]]", " ", str)
  str <- tolower(str)
  str <- gsub("j", "i", str)
  str <- str_trim(str)
  str <- str_squish(str)
  return(str)
}

char = "	SAINT-RHEMY	"
vec = c("Saint-Rhémy-en-Bosses", "Saint-Marcel")
char <- preprocessString(char)
vec <- preprocessString(vec)

char <- "viva bordo diddo"
vec <- c("viva bordo", "bpdfss")

matchGeonames <- function(char, vec) {
  
  require(stringr)
  
  res_1 <- which(char == vec)
  if (length(res_1) > 1) {
    print(sprintf("More than one exact match for %s", char))
    return(NA)
  } else if (length(res_1) == 1) {
    return(res_1)
  }
  
  char_split <- unlist(str_split(char, " "))
  len_char_split <- length(char_split)
  
  if (len_char_split > 1) {
    for (i in len_char_split:1) {
      vec_split <- str_split(vec, " ") 
      res_2 <- 
        which(paste(char_split[1:i], collapse = " ") == 
                unlist(lapply(vec_split, FUN = 
                                function(x) paste(x[1:i], collapse = " "))))
      if (length(res_2) > 1) {
        print(sprintf("More than one exact split-match for %s", char))
        return(NA)
      } else if (length(res_2) == 1) {
        return(res_2)
      }
    }
  }
  
  return(NA)
}


collegio <- gsub("-Comune.csv", "", str_extract(gsub("_-_", "", files), "[A-Z_']+-Comune.csv"))
regione <- toupper(sapply(files, getRegioneFromFilename, USE.NAMES = FALSE))
date <- sapply(files, getDateFromFilename, USE.NAMES = FALSE)
type <- sapply(files, getTypeFromFilename, USE.NAMES = FALSE)
what <- sapply(files, getWhatFromFilename, USE.NAMES = FALSE)

regione[regione == "ANCONA"] <- "MARCHE"
regione[regione == "AOSTA"] <- "VALLE D'AOSTA"
regione[regione == "BARI"] <- "PUGLIA"
regione[regione == "BENEVENTO"] <- "CAMPANIA"
regione[regione == "BOLOGNA"] <- "EMILIA~ROMAGNA"
regione[regione == "BRESCIA"] <- "LOMBARDIA"
regione[regione == "CAGLIARI"] <- "SARDEGNA"
regione[regione == "CAMPOBASSO" & date < as.Date("1963-01-01")] <- "ABRUZZI E MOLISE"
regione[regione == "CAMPOBASSO" & date > as.Date("1963-01-01")] <- "MOLISE"
regione[regione == "CATANIA"] <- "SICILIA"
regione[regione == "CATANZARO"] <- "CALABRIA"
regione[regione == "COMO"] <- "LOMBARDIA"
regione[regione == "CUNEO"] <- "PIEMONTE"
regione[regione == "FIRENZE"] <- "TOSCANA"
regione[regione == "GENOVA"] <- "LIGURIA"
regione[regione == "L'AQUILA" & date < as.Date("1963-01-01")] <- "ABRUZZI E MOLISE"
regione[regione == "L'AQUILA" & date > as.Date("1963-01-01")] <- "ABRUZZO"
regione[regione == "LECCE"] <- "PUGLIA"
regione[regione == "MANTOVA"] <- "LOMBARDIA"
regione[regione == "MILANO"] <- "LOMBARDIA"
regione[regione == "NAPOLI"] <- "CAMPANIA"
regione[regione == "PALERMO"] <- "SICILIA"
regione[regione == "PARMA" ] <- "EMILIA~ROMAGNA"
regione[regione == "PERUGIA"] <- "UMBRIA"
regione[regione == "PISA"] <- "TOSCANA"
regione[regione == "POTENZA"] <- "BASILICATA"
regione[regione == "ROMA"] <- "LAZIO"
regione[regione == "SIENA"] <- "TOSCANA"
regione[regione == "TORINO"] <- "PIEMONTE"
regione[regione == "TRENTO"] <- "TRENTINO~ALTO ADIGE"
regione[regione == "TRIESTE"] <- "FRIULI~VENEZIA GIULIA"
regione[regione == "UDINE"] <- "FRIULI~VENEZIA GIULIA"
regione[regione == "VENEZIA"] <- "VENETO"
regione[regione == "VERONA"] <- "VENETO"

file_dat <- data.frame(file = files,
                       regione,
                       collegio,
                       date,
                       what,
                       type,
                       stringsAsFactors = F)

library(data.table)
for (i in 1:nrow(file_dat)) {
  print(nrow(file_dat) - i)
  this_dat <- read.csv(paste0(dir, file_dat$file[i]), sep = ";", row.names = NULL, colClasses = 'character')
  if (file_dat$type[i] == 'SCRUTINI') {
    this_dat <- this_dat[,1:5]
    colnames(this_dat) <- 
      c("Ente", "Numero.elettori", "Numero.votanti", "Schede.bianche",
        "Schede.non.valide")
    this_dat$Numero.elettori <- as.numeric(gsub("\\.", "", this_dat$Numero.elettori))
    this_dat$Numero.votanti <- as.numeric(gsub("\\.", "", this_dat$Numero.votanti))
    this_dat$Schede.bianche <- as.numeric(gsub("\\.", "", this_dat$Schede.bianche))
    this_dat$Schede.non.valide <- as.numeric(gsub("\\.", "", this_dat$Schede.non.valide))
    scrutini_list[[length(scrutini_list) + 1]] <-
      data.frame(type = file_dat$type[i],
                 election = file_dat$what[i],
                 date = file_dat$date[i],
                 geo_lev_1 = "ITALIA",
                 geo_lev_2 = file_dat$regione[i],
                 geo_lev_3 = file_dat$collegio[i],
                 geo_entity = this_dat$Ente,
                 registered_voters = this_dat$Numero.elettori,
                 effective_voters = this_dat$Numero.votanti,
                 blank_votes = this_dat$Schede.bianche,
                 invalid_votes = this_dat$Schede.non.valide,
                 stringsAsFactors = F)
  } else if (file_dat$type[i] == 'LISTE') {
    this_dat <- this_dat[,1:3]
    colnames(this_dat) <- c("Ente", "Liste.Gruppi", "Voti")
    this_dat$Voti <- as.numeric(gsub("\\.", "", this_dat$Voti))
    liste_list[[length(liste_list) + 1]] <- 
      data.frame(type = file_dat$type[i],
                 election = file_dat$what[i],
                 date = file_dat$date[i],
                 geo_lev_1 = "ITALIA",
                 geo_lev_2 = file_dat$regione[i],
                 geo_lev_3 = file_dat$collegio[i],
                 geo_entity = this_dat$Ente,
                 party_votes = this_dat$Voti,
                 party = this_dat$Liste.Gruppi,
                 stringsAsFactors = F)
  }
}

scrutini_dat <- 
  rbindlist(scrutini_list)
liste_dat <- 
  rbindlist(liste_list)

scrutini_dat$geo_entity <- str_trim(scrutini_dat$geo_entity)
liste_dat$geo_entity <- str_trim(liste_dat$geo_entity)

scrutini_dat$geo_lev_2 <- 
  gsub("~", "-", scrutini_dat$geo_lev_2)
liste_dat$geo_lev_2 <- 
  gsub("~", "-", liste_dat$geo_lev_2)


all_geo_entities <- 
  unique(liste_dat %>% select(geo_entity, geo_lev_2, date))

all_geo_entities$geo_lev_2[all_geo_entities$geo_lev_2 %in% c("ABRUZZO","MOLISE")] <- 
  "ABRUZZI E MOLISE"

all_geo_entities <- 
  unique(all_geo_entities)

load("/Users/143852/Downloads/01_place_table.RData") # EDIT THIS
load("/Users/143852/Downloads/06_hierarchical_setting.RData") # EDIT THIS
load("/Users/143852/Downloads/04_toponymal_setting.RData") # EDIT THIS

comuni <- 
  place_table[place_table$tmp_type == "<http://www.wikidata.org/entity/Q747074>",]
province <-
  place_table[place_table$tmp_type == "<http://www.wikidata.org/entity/Q15089>",]
regioni <-
  place_table[place_table$tmp_type == "<http://www.wikidata.org/entity/Q16110>",]

require(dplyr)
comuni_reg <- 
  merge(comuni %>% select(id), 
        hierarchical_setting %>% select(id, part_of), 
        by.x = "id", by.y = "id", all = FALSE)
comuni_reg <- 
  merge(comuni_reg, 
        hierarchical_setting %>% select(id, part_of), 
        by.x = "part_of", by.y = "id", all = FALSE)
comuni_reg <-
  unique(comuni_reg[,c("id","part_of.y")])
comuni_reg$region <- 
  regioni$tmp_name[match(comuni_reg$part_of.y,regioni$id)]

comuni_reg$region <- toupper(comuni_reg$region)
comuni_reg$region[comuni_reg$region %in% c("ABRUZZO","MOLISE")] <- 
  "ABRUZZI E MOLISE"

comuni_reg <- 
  merge(comuni_reg, toponymal_setting %>% 
          select(id, label_it, from_date, to_date), by = "id")
comuni_reg$tmp_name_prep <- 
  preprocessString(comuni_reg$label_it)

comuni_reg_temp <- comuni_reg %>% 
  select(id, region, tmp_name_prep, from_date, to_date) %>% distinct()

comuni_reg <- comuni_reg %>% 
  select(id, region, tmp_name_prep) %>% distinct()

all_geo_entities_temp <- all_geo_entities 
all_geo_entities <- all_geo_entities %>% select(geo_entity, geo_lev_2, tmp_id) %>% distinct()

all_geo_entities$tmp_id <- NA

for (i in 1:nrow(all_geo_entities)) {
  print(i)
  
  this_reg <- 
    comuni_reg[comuni_reg$region == all_geo_entities$geo_lev_2[i],]
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- this_reg$id[res_i]
    next
  }
}

all_geo_entities_temp <- 
  merge(all_geo_entities_temp, 
        all_geo_entities[is.na(all_geo_entities$tmp_id),],
        by = c("geo_entity", "geo_lev_2"))

for (i in 1:nrow(all_geo_entities_temp)) {
  print(i)
  
  this_reg <- 
    comuni_reg_temp[comuni_reg_temp$region == all_geo_entities_temp$geo_lev_2[i] &
                 (comuni_reg_temp$from_date <= as.Date(all_geo_entities_temp$date[i]) &
                 (comuni_reg_temp$to_date >= as.Date(all_geo_entities_temp$date[i]) | 
                    is.na(comuni_reg_temp$to_date))),]
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities_temp$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities_temp$tmp_id[i] <- this_reg$id[res_i]
    next
  }
  
  this_reg <- 
    comuni_reg_temp[comuni_reg_temp$region == all_geo_entities_temp$geo_lev_2[i],]
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities_temp$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities_temp$tmp_id[i] <- this_reg$id[res_i]
  }
}

unique(all_geo_entities_temp$geo_entity[is.na(all_geo_entities_temp$tmp_id)])

[1] "ACCUMOLI"                     "ACQUA DEI CORSARI"            "ACQUASANTA"                  
[4] "AGORDO"                       "ALANO DI PIAVE"               "ALLEGHE"                     
[7] "ALTARELLO"                    "AMATRICE"                     "ANTRODOCO"                   
[10] "ANTRONASCHIERANCO"            "ARSIE'"                       "AURONZO DI CADORE"           
[13] "BALABIO"                      "BANDITA"                      "BANNARI DI USELLUS"          
[16] "BARRUMINI"                    "BASSANODISUTRI"               "BASTIA"                      
[19] "BELLUNO"                      "BOCCADIFALCO"                 "BORBONA"                     
[22] "BORCA DI CADORE"              "BORGO"                        "BORGO VELINO"                
[25] "BORGOCOLLEFEGATO"             "BORGOROSE"                    "BRANCACCIO"                  
[28] "CALALZO DI CADORE"            "CALVI"                        "CANALE SAN BOVO"             
[31] "CANTALICE"                    "CASTEL MOLA"                  "CASTEL SANT ANGELO"          
[34] "CASTEL SANT'ANGELO"           "CASTELLAMMARE"                "CASTELLAVAZZO"               
[37] "CASTELLO LAVAZZO"             "CASTELVERRINO"                "CENCENIGHE AGORDINO"         
[40] "CENTRISOLO"                   "CENTRO URBANO"                "CERRETO DELLE LANGHE"        
[43] "CERRETO LOMELLINO"            "CERRINA"                      "CESIOMAGGIORE"               
[46] "CHIAVELLI"                    "CHIES D'ALPAGO"               "CIACULLI"                    
[49] "CIBIANA DI CADORE"            "CITTADUCALE"                  "CITTAREALE"                  
[52] "CIVITACASTELLANA"             "COLLE DI TORA"                "COLLE SANTA LUCIA"           
[55] "COLLI SUL VELINO"             "COMELICO SUPERIORE"           "CORNI AVOLTRI"               
[58] "CORTINA D'AMPEZZO"            "CUBA"                         "DANTA"                       
[61] "DANTA DI CADORE"              "DOMEGGE DI CADORE"            "DOMUSDEMARIA"                
[64] "DUOMO"                        "ESCOLA"                       "FALCADE"                     
[67] "FELTRE"                       "FIAMIGNANO"                   "FILANDERIA"                  
[70] "FONZASO"                      "FORNO DI CANALE"              "FORNO DI ZOLDO"              
[73] "FRIGNANO"                     "GARNICA"                      "GOSALDO"                     
[76] "LA VALLE AGORDINA"            "LAMON"                        "LASPLASSAS"                  
[79] "LENTIAI"                      "LEONESSA"                     "LIMANA"                      
[82] "LIVINALLONGO DEL COL DI LANA" "LONGARONE"                    "LORENZAGO DI CADORE"         
[85] "LOZZO DI CADORE"              "MACCHIA VALFORTE"             "MASSAFISCAGLIA"              
[88] "MASSALUBRENSE"                "MEL"                          "MEZZOMONREALE"               
[91] "MICIGLIANO"                   "MONACILIOI"                   "MONDELLO"                    
[94] "MONTE PIETA'"                 "MONTECOMPATRI"                "MONTELLO"                    
[97] "MONTERONE"                    "MONTICELLI DI BORGOGNA"       "MONTICELLO"                  
[100] "NORAGUS"                      "ORETO"                        "ORSINI"                      
[103] "OSPITALE DI CADORE"           "PADERGNAGA ORIANO"            "PAGANICO"                    
[106] "PALLAVICINO"                  "PASIANO"                      "PEDAVENA"                    
[109] "PERAROLO DI CADORE"           "PESCOROCCHIANO"               "PETRELLA SALTO"              
[112] "PIEVE D'ALPAGO"               "PIEVE DI CADORE"              "PIGNOLA"                     
[115] "PONTE NELLE ALPI"             "PORTOCIVITANOVA"              "POSTA"                       
[118] "PUOS D'ALPAGO"                "QUERO"                        "RICCHETTA A VOLTURNO"        
[121] "RIVAMONTE AGORDINO"           "ROCCA PIETORE"                "ROCCASECCA"                  
[124] "ROMAGNOLO"                    "SAM GIOVANNI IN MARIGNANO"    "SAN GIOVINO MONREALE"        
[127] "SAN GIULIANO IN PUGLIA"       "SAN GREGORIO NELLE ALPI"      "SAN LORENZO"                 
[130] "SAN NICOLO' DI COMELICO"      "SAN REMO"                     "SAN TOMASO AGORDINO"         
[133] "SAN VITO LA TORRE"            "SANT AGATA FRIUS"             "SANTA MARAI DI ROVAGNATE"    
[136] "SAPPADA"                      "SAVOGNA"                      "SEDICO"                      
[139] "SELVA DI CADORE"              "SEREN DEL GRAPPA"             "SETTECANNOLI"                
[142] "SFERRACAVALLO"                "SORAGA"                       "SOSPIROLO"                   
[145] "SOVERZENE"                    "SOVRAMONTE"                   "SVELLI"                      
[148] "TAIBON AGORDINO"              "TAMBRE"                       "TERRANUOVA DEI PASSERINI"    
[151] "TOMMASO NATALE"               "TRIBUNALE"                    "TRIBUNALI"                   
[154] "TRICHIANA"                    "UDITORE"                      "VALDESI"                     
[157] "VALFIORIANA"                  "VALLADA AGORDINA"             "VANZANO CON S CARLO"         
[160] "VAS"                          "VIGANO'"                      "VIGO DI CADORE"              
[163] "VILLA URBANA"                 "VILLA VERDE"                  "VILLA VINCENTINA"            
[166] "VILLAGGI"                     "VILLAGRAZIA"                  "VODO CADORE"                 
[169] "VOLTAGO AGORDINO"             "ZIANO"                        "ZISA"                        
[172] "ZOLDO ALTO"                   "ZOPPE' DI CADORE"
