# get_latest_fhi_data

Downloads Norwegian surveillance data CSV files from the previous day provided by the Folkehelseinstituttet (Norwegian Institute of Public Health) from the [public data repository of FHI](https://github.com/folkehelseinstituttet/surveillance_data), adds a column named "date_published" (with header) that contains the date part of the file name and stores data in an output folder.

To enable all surveilance data to be processed instead of only the data from yesterday, follow the instructions in /bash_scripts/get_input_file_spec.sh

## Getting Started

These instructions will cover usage information and for the Docker container.

### Prerequisities


In order to run this container you'll need to install Docker.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Container Parameters

Parameters of the container (note: this image is based on a generic image template):
* number of retries (value not important) - _'0'_
* code folder - should always be set to _/code_
* storage folder for the GitHub repository inside the conatiner - should always be set to _/gitrepo/surveillance_data/_
* work folder for the container - should be the same as the work volume inside the container - _/work_ (default)
* output storage folder inside the container - should be the same as the output storage volume - _/out_ (default) 

```shell
docker run -i --env LOG_FILE_PATH=/work/log.txt -v ${PWD}/_work00:/work -v ${PWD}/_out00:/out nikolayn/get-fhi-data:latest '0' /code /gitrepo/surveillance_data/ /work /out
```

#### Environment Variables

* `LOG_FILE_PATH` - Path of log file inside the container

#### Volumes

* `/work` - Work folder for the image
* `/out` - Output storage folder


## Built With

* List the software v0.1.3
* And the version numbers v2.0.0
* That are in this container v0.3.2

## Find Us

* [GitHub](https://github.com/your/repository)
* [Quay.io](https://quay.io/repository/your/docker-repository)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the 
[tags on this repository](https://github.com/your/repository/tags). 

## Authors

* [**Nikolay Nikolov**](https://github.com/nvnikolov)

## License

This project is licensed under the Apache2 License - see the [LICENSE.md](LICENSE.md) file for details.
