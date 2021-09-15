General elections 13 April 2008 (Chamber of Deputy)
================
Francesco Bailo
16 September 2021

read\_raw\_csv\_20080413.R

The details on variables and decriptive statistics on the results of the
2008 elections for the Chamber of Deputies only.

# Count datasets

Count data for geographic entitiy (municipal level) is provided in the
following files:

-   `open_csv_20080413_camera_geo_count.csv`;
-   `open_csv_20080413_camera_party_count.csv`.

For the Chamber of Deputies (`camera`), 2 open datasets are provided:

-   `party_count` with information on votes received by parties (“liste”
    in Italian).
-   `geo_count` with general electoral count information on the
    geographic entity.

## Variable description

### Character variables

-   `election` set to `Camera`.
-   `date` in format `%Y-%m-%d`.
-   `geo_lev_1` to `geo_lev_2` the label as set by the original data
    provider for the the electoral boundaries (from larger to smaller)
    of the geographical entity described by the observation.
-   `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.
-   `party` name of the list as set by the original data provider.
-   `istat_cod` code of `geo_entity` as set by [Italy’s National
    Institute of Statistics
    (Istat)](https://en.wikipedia.org/wiki/National_Institute_of_Statistics_(Italy))
    (also `PRO_COM_T`). Use this to join with the geographic files
    `raw_shp_20080413`.)

### Numerical variables

-   `party_votes` the sum of votes received by a party in the
    geographical entity.
-   `tot_party_votes` the sum of votes received by all parties in the
    geographical entity.
-   `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
-   `registered_male_voters`
-   `effective_voters` the sum of voters actually casting a vote in the
    election
-   `effective_male_voters`
-   `blank_votes`
-   `invalid_votes` the sum ofnon-assigned votes (it includes
    `blank_votes`) in the geographical entity.

## Variable summary

### camera\_party\_count

| party\_votes |   % |
|-------------:|----:|
|   36,527,230 | 100 |

| party                                    | party\_votes |     % |
|:-----------------------------------------|-------------:|------:|
| IL POPOLO DELLA LIBERTA’                 |   13,642,742 | 37.35 |
| PARTITO DEMOCRATICO                      |   12,092,998 | 33.11 |
| LEGA NORD                                |    3,026,844 |  8.29 |
| UNIONE DI CENTRO                         |    2,050,319 |  5.61 |
| DI PIETRO ITALIA DEI VALORI              |    1,593,675 |  4.36 |
| LA SINISTRA L’ARCOBALENO                 |    1,124,418 |  3.08 |
| LA DESTRA - FIAMMA TRICOLORE             |      885,229 |  2.42 |
| MOVIMENTO PER L’AUTONOMIA ALL.PER IL SUD |      410,487 |  1.12 |
| PARTITO SOCIALISTA                       |      355,581 |  0.97 |
| PARTITO COMUNISTA DEI LAVORATORI         |      208,394 |  0.57 |
| SINISTRA CRITICA                         |      167,673 |  0.46 |
| SVP                                      |      147,666 |  0.40 |
| ASS.DIFESA DELLA VITA ABORTO?NO,GRAZIE   |      135,578 |  0.37 |
| PER IL BENE COMUNE                       |      119,420 |  0.33 |
| FORZA NUOVA                              |      108,837 |  0.30 |
| P.LIBERALE ITALIANO                      |      103,760 |  0.28 |
| UNIONE DEMOCRATICA PER I CONSUMATORI     |       91,486 |  0.25 |
| LISTA DEI GRILLI PARLANTI                |       66,844 |  0.18 |
| LG.VENETA REPUBBLICA                     |       31,353 |  0.09 |
| AUT.LIB. DEMOCRATIE                      |       29,311 |  0.08 |
| VALLEE D’AOSTE                           |       28,349 |  0.08 |
| DIE FREIHEITLICHEN                       |       28,347 |  0.08 |
| M.E.D.A.                                 |       16,449 |  0.05 |
| PS D’AZ.                                 |       14,856 |  0.04 |
| LEGA PER L’AUTONOMIA ALL.LOMB. LEGA PENS |       14,003 |  0.04 |
| UNION FUR SUD TIROL                      |       12,836 |  0.04 |
| SARDIGNA NATZIONE                        |        7,182 |  0.02 |
| LEGA SUD                                 |        4,346 |  0.01 |
| L’INTESA VENETA                          |        2,388 |  0.01 |
| PARTITO DI ALTERNATIVA COMUNISTA         |        2,049 |  0.01 |
| IL LOTO                                  |        1,799 |  0.00 |
| AZ.SOCIALE MUSSOLINI                     |        1,066 |  0.00 |
| MOVIMENTO P.P.A.                         |          945 |  0.00 |

### camera\_geo\_count

| registered\_voters | registered\_male\_voters | effective\_voters | % (effective) | effective\_male\_voters | tot\_party\_votes | blank\_votes | % (valid votes) |
|-------------------:|-------------------------:|------------------:|--------------:|------------------------:|------------------:|-------------:|----------------:|
|         47,142,437 |               22,595,311 |        37,954,253 |         80.51 |              18,600,300 |        36,527,230 |      487,694 |           96.24 |
