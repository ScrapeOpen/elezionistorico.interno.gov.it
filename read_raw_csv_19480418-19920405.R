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
  str <- stringi::stri_trans_general(str, "Latin-ASCII")
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


library(dplyr)
all_geo_entities <- 
  unique(liste_dat %>% dplyr::select(geo_entity, geo_lev_2, date))

all_geo_entities$geo_lev_2[all_geo_entities$geo_lev_2 %in% c("ABRUZZO","MOLISE")] <- 
  "ABRUZZI E MOLISE"

all_geo_entities <- 
  unique(all_geo_entities)

load("~/Desktop/projects/historical_geographic_entity_database/reboot/01_place_table/01_place_table.RData") # EDIT THIS
load("~/Desktop/projects/historical_geographic_entity_database/reboot/06_hierarchical_setting/06_hierarchical_setting.RData") # EDIT THIS
load("~/Desktop/projects/historical_geographic_entity_database/reboot/04_toponymal_setting/04_toponymal_setting.RData") # EDIT THIS

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


# all_geo_entities_bkup <- all_geo_entities # Remove


all_geo_entities_temp <- 
  merge(all_geo_entities_temp, 
        all_geo_entities[is.na(all_geo_entities$tmp_id),],
        by = c("geo_entity", "geo_lev_2"))

all_toponymal_setting <-
  toponymal_setting %>% 
  dplyr::distinct(id, label_it)

for (i in 1:nrow(all_geo_entities)) {
  
  if (!is.na(all_geo_entities$tmp_id[i])) {
    next
  } 
  
  print(i)
  
  this_reg <- 
    comuni_reg_temp[comuni_reg_temp$region == all_geo_entities$geo_lev_2[i] &
                 (comuni_reg_temp$from_date <= as.Date(all_geo_entities$date[i]) &
                 (comuni_reg_temp$to_date >= as.Date(all_geo_entities$date[i]) | 
                    is.na(comuni_reg_temp$to_date))),]
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- this_reg$id[res_i]
    next
  }
  
  this_reg <- 
    comuni_reg_temp[comuni_reg_temp$region == all_geo_entities$geo_lev_2[i],]
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- this_reg$id[res_i]
    next
  }
  
  # Lazio Abruzzo Molise
  if (all_geo_entities$geo_lev_2[i] %in% c("ABRUZZI E MOLISE", "LAZIO", "UMBRIA")) {
    this_reg <- 
      comuni_reg_temp[comuni_reg_temp$region %in% c("ABRUZZI E MOLISE", "LAZIO", "UMBRIA"),]
    this_reg <-
      this_reg[!duplicated(this_reg$id),]
    res_i <- 
      matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                    this_reg$tmp_name_prep)
    if (!is.na(res_i)) {
      all_geo_entities$tmp_id[i] <- this_reg$id[res_i]
      next
    }
  }
  
  this_reg <- comuni_reg_temp %>% 
    dplyr::distinct(id, tmp_name_prep)
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  this_reg$tmp_name_prep)
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- this_reg$id[res_i]
    next
  }
  
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  preprocessString(all_toponymal_setting$label_it))
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- all_toponymal_setting$id[res_i]
    next
  }
  
  res_i <- 
    matchGeonames(preprocessString(all_geo_entities$geo_entity[i]),
                  preprocessString(comuni$tmp_name))
  if (!is.na(res_i)) {
    all_geo_entities$tmp_id[i] <- comuni$id[res_i]
    next
  }
}

# Manual missing
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "TORELLA DE' LOMBARDI"] <- 
  "9375"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CALVI" &
                          all_geo_entities$geo_lev_2 == "CAMPANIA"] <- 
  "1561"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAN NAZZARO" &
                          all_geo_entities$geo_lev_2 == "CAMPANIA"] <- 
  "8162"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MASSAFISCAGLIA"] <- 
  "5129"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MIGLIARO"] <- 
  "5300"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BERBENNO"] <- 
  "911"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "COSTA DI SERINA"] <- 
  "3209"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "DALMINE"] <- 
  "3349"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "FILAGO"] <- 
  "3689"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONTELLO"] <- 
  "5677"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BRENO"] <- 
  "1273"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CASTELVERRINO"] <- 
  "2389"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CASTEL MOLA"] <- 
  "2331"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONTICELLO" &
                          all_geo_entities$geo_lev_2 == "LOMBARDIA"] <- 
  "5770"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "VIGANO'"] <- 
  "10064"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CERRINA" &
                          all_geo_entities$geo_lev_2 == "PIEMONTE"] <- 
  "2638"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAN REMO"] <- 
  "8336"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MASSALUBRENSE"] <- 
  "5131"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ACCUMOLI"] <- 
  "157"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "AMATRICE"] <- 
  "395"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ANTRODOCO"] <- 
  "449"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BORBONA"] <- 
  "1106"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "PIGNOLA"] <- 
  "6754"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ROCCASECCA"] <- 
  "7552"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONTECOMPATRI"] <- 
  "5539"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CIVITACASTELLANA"] <- 
  "2869"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SORAGA"] <- 
  "8985"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "LONGARONE"] <- 
  "4769"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAVOGNA"] <- 
  "8610"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CERRETO DELLE LANGHE"] <- 
  "2637"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CASTELLO LAVAZZO"] <- 
  "2271"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SVELLI"] <- 
  "9145"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BANNARI DI USELLUS"] <- 
  "10160"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "DOMUSDEMARIA"] <- 
  "3434"	
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "LASPLASSAS"] <- 
  "4559"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAN GIOVINO MONREALE"] <- 
  "7968"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MACCHIA VALFORTE"] <- 
  "4877"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BORGOCOLLEFEGATO"] <- 
  "1168"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAM GIOVANNI IN MARIGNANO"] <- 
  "8028"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BARRUMINI"] <- 
  "808"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SANT AGATA FRIUS"] <- 
  "8452"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "VILLA URBANA"] <- 
  "10246"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ESCOLA"] <- 
  "3538"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "NORAGUS"] <- 
  "6081"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAN GIULIANO IN PUGLIA"] <- 
  "8043"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BALABIO"] <- 
  "722"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CERRETO LOMELLINO"] <- 
  "2613"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "BASSANODISUTRI"] <- 
  "831"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "VANZANO CON S CARLO"] <- 
  "9858"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CANALE SAN BOVO"] <- 
  "1689"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "GARNICA"] <- 
  "4026"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "VALFIORIANA"] <- 
  "9757"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ZIANO" &
                          all_geo_entities$geo_lev_2 ==  "TRENTINO-ALTO ADIGE"] <- 
  "10391"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "PASIANO"] <- 
  "6451"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONTICELLI DI BORGOGNA"] <- 
  "5677"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SAN VITO LA TORRE"] <- 
  "8301"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "VILLA VINCENTINA"] <- 
  "10162"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CORNI AVOLTRI"] <- 
  "3821"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONTERONE"] <- 
  "5859"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "ANTRONASCHIERANCO"] <- 
  "450"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "CASTELLAMMARE"] <- 
  "2256"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "SANTA MARAI DI ROVAGNATE"] <- 
  "8387"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "PORTOCIVITANOVA"] <- 
  "7010"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "RICCHETTA A VOLTURNO"] <- 
  "7565"
all_geo_entities$tmp_id[all_geo_entities$geo_entity == "MONACILIOI"] <- 
  "5422"

unique(all_geo_entities$geo_entity[is.na(all_geo_entities$tmp_id)])
