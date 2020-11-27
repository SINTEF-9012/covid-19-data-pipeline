# FHI table data to RDF pipeline
Downloads Norwegian surveillance data files from the previous day provided by the Folkehelseinstituttet (Norwegian Institute of Public Health) from the [public data repository of FHI](https://github.com/folkehelseinstituttet/surveillance_data) and transforms it to the [RDF N-triples standard format](https://www.w3.org/TR/n-triples/).

This repository additionally contains the sources for all of the used container images (in the folders prefixed with _template_). 

## Running the pipeline

1. Download the executable JAR archives for the transformation to RDF from [this address](https://covid-19-data.sintef.cloud/transformations/) and store them in the _executable_jars_ folder. 

2. (Optional) Edit the [.env](https://github.com/SINTEF-9012/covid-19-data-pipeline/blob/main/fhi_surveilance_dataset_pipeline_rdf/.env) file to set the base folder for the pipeline to the one you want to use (default is the folder of the docker-compose file). Note that this pipeline makes use of the executable_jars folder (along with the executable JAR archives from step 1).

3. Run the pipeline by executing the following command:
```
docker-compose up -d
```

When running, the pipeline will create a set of folders that are used by the different steps of the pipeline to process and pass data between each other. 

## Resulting data

The pipeline converts the dataset according to the data model described in the [Wiki](https://github.com/SINTEF-9012/covid-19-data-pipeline/wiki/CoVid-19-measurements-data-model). You can find a description of the specific published data [here](https://github.com/SINTEF-9012/covid-19-data-pipeline/wiki/Published-datasets)