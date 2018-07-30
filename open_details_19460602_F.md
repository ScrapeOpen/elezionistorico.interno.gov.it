Italian institutional referendum 2 June 1946
================
Francesco Bailo
30 July 2018

The details on variables and decriptive statistics on the results of the
1946 institutional referendum at the provincial level. The referendum
was not organised in the provinces of Trieste and Bolzano-Bozen.

# Dataset

  - `open_csv_19460602_F.csv`

## Variable description

### Character variables

  - `type` is `SCRUTINI`.
  - `election` is `Referendum`.
  - `date` in format `%Y-%m-%d`.
  - `geo_lev_1` to `geo_lev_2` the label as set by the original data
    provider for the the electoral boundaries (from larger to smaller)
    of the geographical entity described by the observation.
  - `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.

### Numerical variables

  - `republic_votes` the sum of votes in support of the Republic.
  - `monarchy_votes` the sum of votes in support of the Monarchy.
  - `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
  - `blank_votes`
  - `invalid_votes` the sum of non-assigned votes (it includes
    `blank_votes`) in the geographical entity.

### Variables linking to other resources

  - `istat_nam` is the name used by ISTAT in the geographic file
    `open_shp_20180304_camera`.

## Variable summary

### open\_csv\_19460602\_F

| republic\_votes | monarchy\_votes | registered\_voters | effective\_voters | blank\_votes | invalid\_votes |
| --------------: | --------------: | -----------------: | ----------------: | -----------: | -------------: |
|      12,718,641 |      10,718,502 |         28,005,449 |        24,946,878 |    1,146,729 |      1,509,735 |

| republic\_votes | monarchy\_votes | registered\_voters | effective\_voters | blank\_votes | invalid\_votes |
| --------------: | --------------: | :----------------- | ----------------: | -----------: | -------------: |
|           54.27 |           45.73 | NA                 |             89.08 |          4.6 |           6.05 |
