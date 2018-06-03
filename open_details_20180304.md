General elections 4 March 2018 (Chamber of Deputy and Senate of the
Republic)
================
Francesco Bailo
3 June 2018

The details on variables and decriptive statistics on the results of the
2018 elections. For both the Chamber and the Senate (formally two
different elections with different electorates), voters had the options
of either voting a *party* or the coaltion’s *candidate* either in the
case of monocoalitions (i.e. one-party coalition). Consequentially, for
each coalition the votes received by a candidate must equal or be
greater than the sum of votes received by the parties in the coalition.

# Count datasets

Count data for geographic entitiy (municipal level or lower) is provided
in the following files:

  - `open_csv_20180304_camera_party_count.csv`;
  - `open_csv_20180304_camera_candidate_count.csv`;
  - `open_csv_20180304_camera_geo_count.csv`;
  - `open_csv_20180304_senato_party_count.csv`;
  - `open_csv_20180304_senato_candidate_count.csv`;
  - `open_csv_20180304_senato_geo_count.csv`;

For each election, Chamber of Deputies (`camera`) and the Senate of the
Republic (`senato`), 3 open datasets are provided:

  - `party_count` with information on votes received by parties.
  - `candidate_count` with information on votes received by candidates
    (that is, coalitions since each candidate is the uninominal
    candidate of a coaltion).
  - `geo_count` with general electoral count information on the
    geographic entity.

## Variable description

### Character variables

  - `election` either `Senato` or `Camera`.
  - `date` in format `%Y-%m-%d`.
  - `geo_lev_1` to `geo_lev_4` the label as set by the original data
    provider for the the electoral boundaries (from larger to smaller)
    of the geographical entity described by the observation.
  - `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.
  - `candidate` name of the candidate as set by the original data
    provider.
  - `coalition` name of the coalition as set by the original data
    provider (in the case of a monocoalition, is the name of the party).
  - `istat_nam` name of `geo_entity` as set by [Italy’s National
    Institute of Statistics
    (Istat)](https://en.wikipedia.org/wiki/National_Institute_of_Statistics_\(Italy\)).
  - `minint_cod` identifier of the `geo_entity` as set by the Ministry
    of Interior (use this to join with the geographic files
    `open_shp_20180304_camera` and `open_shp_20180304_senato`).

### Numerical variables

  - `party_votes` the sum of votes received by a party in the
    geographical entity.
  - `candidate_votes` the sum of votes received by a candidate (that is,
    also by a coalition) in the geographical entity.
  - `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
  - `blank_votes`
  - `invalid_votes` the sum ofnon-assigned votes (it includes
    `blank_votes`) in the geographical entity.

### Variables linking to other resources

  - `party_wd_id` Wikidata URI of the party, in the format `Q[0-9]+` (to
    visit the resource page append `http://www.wikidata.org/wiki/`).
  - `coalition_wd_id` Wikidata URI of the coalition, in the format
    `Q[0-9]+` (in case of monocoalition, it corresponds to
    `party_wd_id`).

## Variable summary

### camera\_party\_count

| party\_votes |   % |
| -----------: | --: |
|   31,648,908 | 100 |

| party                                    | party\_votes |     % |
| :--------------------------------------- | -----------: | ----: |
| MOVIMENTO 5 STELLE                       |   10,253,522 | 32.40 |
| PARTITO DEMOCRATICO                      |    5,888,232 | 18.60 |
| LEGA                                     |    5,587,858 | 17.66 |
| FORZA ITALIA                             |    4,498,106 | 14.21 |
| FRATELLI D’ITALIA CON GIORGIA MELONI     |    1,398,312 |  4.42 |
| LIBERI E UGUALI                          |    1,032,713 |  3.26 |
| \+EUROPA                                 |      803,621 |  2.54 |
| NOI CON L’ITALIA - UDC                   |      417,702 |  1.32 |
| POTERE AL POPOLO\!                       |      351,208 |  1.11 |
| CASAPOUND ITALIA                         |      295,939 |  0.94 |
| IL POPOLO DELLA FAMIGLIA                 |      206,346 |  0.65 |
| ITALIA EUROPA INSIEME                    |      180,980 |  0.57 |
| CIVICA POPOLARE LORENZIN                 |      168,269 |  0.53 |
| SVP - PATT                               |      126,769 |  0.40 |
| ITALIA AGLI ITALIANI                     |      119,980 |  0.38 |
| PARTITO COMUNISTA                        |      102,030 |  0.32 |
| PARTITO VALORE UMANO                     |       45,785 |  0.14 |
| 10 VOLTE MEGLIO                          |       33,225 |  0.10 |
| PER UNA SINISTRA RIVOLUZIONARIA          |       27,138 |  0.09 |
| PARTITO REPUBBLICANO ITALIANO - ALA      |       18,866 |  0.06 |
| GRANDE NORD                              |       18,556 |  0.06 |
| AUTODETERMINATZIONE                      |       18,237 |  0.06 |
| PD-UV-UVP-EPAV                           |       14,429 |  0.05 |
| POUR TOUS PER TUTTI PE TCHEUT            |       12,118 |  0.04 |
| LISTA DEL POPOLO PER LA COSTITUZIONE     |        9,088 |  0.03 |
| PATTO PER L’AUTONOMIA                    |        5,871 |  0.02 |
| FI -FRAT. D’IT. -MOV.NUOVA VALLE D’AOSTA |        5,533 |  0.02 |
| BLOCCO NAZIONALE PER LE LIBERTA’         |        3,376 |  0.01 |
| RISPOSTA CIVICA                          |        2,623 |  0.01 |
| SIAMO                                    |        1,298 |  0.00 |
| RINASCIMENTO MIR                         |          676 |  0.00 |
| ITALIA NEL CUORE                         |          502 |  0.00 |

### senato\_party\_count

| party\_votes |   % |
| -----------: | --: |
|   29,175,241 | 100 |

| party                                    | party\_votes |     % |
| :--------------------------------------- | -----------: | ----: |
| MOVIMENTO 5 STELLE                       |    9,299,974 | 31.88 |
| PARTITO DEMOCRATICO                      |    5,557,135 | 19.05 |
| LEGA                                     |    5,223,211 | 17.90 |
| FORZA ITALIA                             |    4,268,421 | 14.63 |
| FRATELLI D’ITALIA CON GIORGIA MELONI     |    1,259,640 |  4.32 |
| LIBERI E UGUALI                          |      922,108 |  3.16 |
| \+EUROPA                                 |      686,123 |  2.35 |
| NOI CON L’ITALIA - UDC                   |      353,788 |  1.21 |
| POTERE AL POPOLO\!                       |      303,282 |  1.04 |
| CASAPOUND ITALIA                         |      246,299 |  0.84 |
| IL POPOLO DELLA FAMIGLIA                 |      198,402 |  0.68 |
| ITALIA EUROPA INSIEME                    |      156,582 |  0.54 |
| CIVICA POPOLARE LORENZIN                 |      150,304 |  0.52 |
| ITALIA AGLI ITALIANI                     |      141,951 |  0.49 |
| SVP - PATT                               |      122,595 |  0.42 |
| PARTITO COMUNISTA                        |       97,148 |  0.33 |
| PARTITO VALORE UMANO                     |       37,197 |  0.13 |
| PER UNA SINISTRA RIVOLUZIONARIA          |       30,158 |  0.10 |
| PARTITO REPUBBLICANO ITALIANO - ALA      |       25,099 |  0.09 |
| AUTODETERMINATZIONE                      |       19,170 |  0.07 |
| GRANDE NORD                              |       16,191 |  0.06 |
| PD-UV-UVP-EPAV                           |       15,958 |  0.05 |
| POUR TOUS PER TUTTI PE TCHEUT            |        9,659 |  0.03 |
| LISTA DEL POPOLO PER LA COSTITUZIONE     |        9,323 |  0.03 |
| DESTRE UNITE - FORCONI                   |        5,830 |  0.02 |
| DEMOCRAZIA CRISTIANA                     |        5,232 |  0.02 |
| FI -FRAT. D’IT. -MOV.NUOVA VALLE D’AOSTA |        5,223 |  0.02 |
| PATTO PER L’AUTONOMIA                    |        4,262 |  0.01 |
| RISPOSTA CIVICA                          |        1,911 |  0.01 |
| SIAMO                                    |        1,284 |  0.00 |
| SMS - STATO MODERNO SOLIDALE             |        1,270 |  0.00 |
| RINASCIMENTO MIR                         |          511 |  0.00 |

### camera\_candidate\_count

| candidate\_votes |   % |
| ---------------: | --: |
|       32,907,395 | 100 |

| coalition                                | coalition\_votes |     % |
| :--------------------------------------- | ---------------: | ----: |
| Centro-destra                            |       12,152,345 | 36.93 |
| MOVIMENTO 5 STELLE                       |       10,748,065 | 32.66 |
| Centro-sinistra                          |        7,410,415 | 22.52 |
| LIBERI E UGUALI                          |        1,114,799 |  3.39 |
| POTERE AL POPOLO\!                       |          373,879 |  1.14 |
| CASAPOUND ITALIA                         |          313,637 |  0.95 |
| IL POPOLO DELLA FAMIGLIA                 |          219,633 |  0.67 |
| ITALIA AGLI ITALIANI                     |          125,949 |  0.38 |
| PARTITO COMUNISTA                        |          106,816 |  0.32 |
| SVP - PATT                               |           96,308 |  0.29 |
| PARTITO VALORE UMANO                     |           49,128 |  0.15 |
| 10 VOLTE MEGLIO                          |           37,354 |  0.11 |
| PER UNA SINISTRA RIVOLUZIONARIA          |           29,364 |  0.09 |
| PARTITO REPUBBLICANO ITALIANO - ALA      |           20,943 |  0.06 |
| GRANDE NORD                              |           19,846 |  0.06 |
| AUTODETERMINATZIONE                      |           19,307 |  0.06 |
| PD-UV-UVP-EPAV                           |           14,429 |  0.04 |
| POUR TOUS PER TUTTI PE TCHEUT            |           12,118 |  0.04 |
| LEGA                                     |           11,588 |  0.04 |
| LISTA DEL POPOLO PER LA COSTITUZIONE     |            9,921 |  0.03 |
| PATTO PER L’AUTONOMIA                    |            7,079 |  0.02 |
| FI -FRAT. D’IT. -MOV.NUOVA VALLE D’AOSTA |            5,533 |  0.02 |
| BLOCCO NAZIONALE PER LE LIBERTA’         |            3,628 |  0.01 |
| RISPOSTA CIVICA                          |            2,623 |  0.01 |
| SIAMO                                    |            1,428 |  0.00 |
| RINASCIMENTO MIR                         |              686 |  0.00 |
| ITALIA NEL CUORE                         |              574 |  0.00 |

### senato\_candidate\_count

| candidate\_votes |   % |
| ---------------: | --: |
|       30,272,301 | 100 |

| coalition                                | coalition\_votes |     % |
| :--------------------------------------- | ---------------: | ----: |
| Centro-destra                            |       11,327,549 | 37.42 |
| MOVIMENTO 5 STELLE                       |        9,748,326 | 32.20 |
| Centro-sinistra                          |        6,857,723 | 22.65 |
| LIBERI E UGUALI                          |          991,159 |  3.27 |
| POTERE AL POPOLO\!                       |          322,181 |  1.06 |
| CASAPOUND ITALIA                         |          260,925 |  0.86 |
| IL POPOLO DELLA FAMIGLIA                 |          211,759 |  0.70 |
| ITALIA AGLI ITALIANI                     |          149,907 |  0.50 |
| PARTITO COMUNISTA                        |          101,648 |  0.34 |
| SVP - PATT                               |           89,476 |  0.30 |
| PARTITO VALORE UMANO                     |           39,639 |  0.13 |
| PER UNA SINISTRA RIVOLUZIONARIA          |           32,623 |  0.11 |
| PARTITO REPUBBLICANO ITALIANO - ALA      |           27,384 |  0.09 |
| AUTODETERMINATZIONE                      |           20,468 |  0.07 |
| GRANDE NORD                              |           17,507 |  0.06 |
| PD-UV-UVP-EPAV                           |           15,958 |  0.05 |
| LEGA                                     |           11,004 |  0.04 |
| LISTA DEL POPOLO PER LA COSTITUZIONE     |           10,356 |  0.03 |
| POUR TOUS PER TUTTI PE TCHEUT            |            9,659 |  0.03 |
| DESTRE UNITE - FORCONI                   |            6,229 |  0.02 |
| DEMOCRAZIA CRISTIANA                     |            5,532 |  0.02 |
| FI -FRAT. D’IT. -MOV.NUOVA VALLE D’AOSTA |            5,223 |  0.02 |
| PATTO PER L’AUTONOMIA                    |            5,015 |  0.02 |
| RISPOSTA CIVICA                          |            1,911 |  0.01 |
| SIAMO                                    |            1,402 |  0.00 |
| SMS - STATO MODERNO SOLIDALE             |            1,384 |  0.00 |
| RINASCIMENTO MIR                         |              354 |  0.00 |

### camera\_geo\_count

| registered\_voters | effective\_voters | % (effective) | blank\_votes | invalid\_votes | % (invalid) |
| -----------------: | ----------------: | ------------: | -----------: | -------------: | ----------: |
|         46,604,897 |        33,995,268 |         72.94 |      391,498 |      1,087,873 |         3.2 |

### senato\_geo\_count

| registered\_voters | effective\_voters | % (effective) | blank\_votes | invalid\_votes | % (invalid) |
| -----------------: | ----------------: | ------------: | -----------: | -------------: | ----------: |
|         42,872,120 |        31,298,484 |            73 |      378,396 |      1,026,183 |        3.28 |
