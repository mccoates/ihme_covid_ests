# ihme_covid_ests


THIS REPOSITORY HAS NOT BEEN MAINTAINED SINCE MAY 10, 2020
I WAS DOWNLOADING ALL VERSIONS OF IHME COVID ESTIMATES, BUT IHME HAS RELEASED PREVIOUS DATASETS

They can be found straight from the source here: http://www.healthdata.org/covid/data-downloads

I have incorporated the datasets that I did not previously have into the repository.


Estimates folder contains downloaded versions of IHME COVID-19 estimates
https://covid19.healthdata.org/projections

PDF files contain data release information sheets from IHME

Folder names, which primarily consist of dates, are the folder names populated by IHME on download, 
though these dates do not always correspond to the date of release. For instance, the release on April 7, 2020
was named 2020_04_05.08.all. The variable "ihme_estimate_date" now corresponds with the dates IHME has associated with their models and can be used in place of the "model_version" variable that is the name of the folder downloaded.

Note: Sometimes the datasets for download seem to be updated, but there are no differences between the versions. For instance, the version 2020_04_07.04.all, which was downloaded on April 8, 2020, had the exact same estimates as the dataset downloaded April 9, 2020, which was version 2020_04_07.06.all. The only difference was 14 decimal places deep in a single estimate. I have included both of these datasets in the repository but only included one version in the compiled dataset.


