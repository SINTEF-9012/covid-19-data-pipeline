# Data pipelines for processing of CoVid-19 data

This repository contains pipelines for downloading, processing and conversion of CoVid-19 related datasets to different formats and data models. 

## Prerequisites

In order to run pipelines found in this repository you will need to install Docker.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

Next, you need to install Docker-compose.

* [Installation for all platforms](https://docs.docker.com/compose/install/)

Clone this repository to a folder and follow the instructions that can be found in the folders inside this repository. Currently, the repository contains the following pipelines:

* [Pipeline for transforming data](https://github.com/SINTEF-9012/covid-19-data-pipeline/tree/main/fhi_surveilance_dataset_pipeline_rdf) published by the Norwegian Institute of Public Health [at this address](https://github.com/folkehelseinstituttet/surveillance_data) to the [RDF N-triples standard format](https://www.w3.org/TR/n-triples/). 

## Datasets
All datasets converted by the pipelines in this repository are available and continously updated at [this address](https://covid-19-data.sintef.cloud/data/).

## Questions or issues?

For posting information about bugs, questions and discussions please use the [Github Issues](https://github.com/SINTEF-9012/covid-19-data-pipeline/issues) feature.

## Core Team
- [Nikolay Nikolov](https://github.com/nvnikolov) (author)

## License
> Available under the [Apache Version 2.0 License](/LICENSE) (v1.0).

> Created by [Nikolay Nikolov](https://github.com/nvnikolov), 2020.
