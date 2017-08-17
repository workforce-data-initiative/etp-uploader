# ETP Uploader

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/workforce-data-initiative/etp-uploader/tree/wdi)
[![Travis Build Status](https://travis-ci.org/frictionlessdata/goodtables.io.svg?branch=master)](https://travis-ci.org/frictionlessdata/goodtables.io)
[![Coverage Status](https://coveralls.io/repos/frictionlessdata/goodtables.io/badge.svg)](https://coveralls.io/r/frictionlessdata/goodtables.io)

A prototype web service for validating and collecting participant files from eligible training providers

This package uses a suite of table validation tools based upon [Good Tables](https://github.com/okfn/goodtables).

## The JSON Table Schema

The heart of this package is the [JSON Table Schema](https://specs.frictionlessdata.io/table-schema/)
that describes the required fields and their constraints. A draft specification
is described within the [etp-uploader-schema.json](etp-uploader-schema.json).

**TODO**: It would be nice to use the description field when displaying validation
errors in order to give more effective feedback to the users when their data file
isn't valid.

## Goodtables-py

The ETP Uploader package uses [Frictionless Data's Goodtables Python package](https://github.com/frictionlessdata/goodtables-py)
to do its heavy lifting.  That library recently made some breaking API upgrade to
version 1.0, but this package still uses the older 0.7.x API.  In the future it
will be beneficial to migrate to the newer API, but for now we are using a
[custom fork](https://github.com/workforce-data-initiative/goodtables-py) to
provide ongoing support for the 0.7.x API.

## Runtime support

Currently runs on Python 3.6.1.  Some historic support for 2.7, but development is
conducted on Python 3.6+.

## Quickstart

* Clone the repository into a virtual environment
* Install dependencies: `pip install -r requirements.txt`
* Run a server: `python main.py`
* Run the tests:
  * `pip install -r requirements/test.txt && pip install -r requirements/local.txt`
  * `./test.sh`

## What we've got

### `/` (Home)

* A web form for manually adding data for validation

### `/api` (API Index)

* Via XHR, a JSON object with an `endpoints` property that describes the available endpoints
* Via browser, a documentation page for the API

### `api/run` (Task Runner)

* POST to validate data
* GET to validate data

## Supported configuration parameters

The API and UI support a subset of all parameters available in a [Good Tables](https://github.com/okfn/goodtables) pipeline.

All possible arguments to a pipeline and individual processors can be found in the [Good Tables docs](http://goodtables.readthedocs.org/en/latest/).

### API

* `data`: (required) Any file, URL to a file, or string of data
* `schema`: (default. None) This is a convenience for the `options['schema']['schema']` argument that is passed to the schema validator
* `report_limit`: (default. 1000, max. 1000) An integer that sets a limit on the amount of report results a validator can generate. Validation will cease of this amount is reached
* `row_limit`: (default. 20000, max. 30000) An integer that sets a limit on the amount of rows that will be processed. Iteration over the data will stop at this amount.
* `fail_fast`: (default True) A boolean to set whether the run will fail on first error, or not.
* `format`: (default 'csv') 'csv' or 'excel' - the format of the file.
* `ignore_empty_rows`: (default False) A boolean to set whether empty rows should raise errors, or be ignored.
* `ignore_duplicate_rows`: (default False) A boolean to set whether duplicate rows should raise errors, or be ignored.
* `encoding`: (default None) A string that indicates the encoding of the data. Overrides automatic encoding detection.

#### Example

```
# make a request
curl http://goodtables.okfnlabs.org/api/run --data "data=https://raw.githubusercontent.com/okfn/goodtables/master/examples/row_limit_structure.csv&schema=https://raw.githubusercontent.com/okfn/goodtables/master/examples/test_schema.json"

# the response will be like
{
    "report": {
        "summary": {
            "bad_row_count": 1,
            "total_row_count": 10,
            ...
        },
        "results": [
            {
            "result_id": "structure_001", # the ID of this result type
            "result_level": "error", # the severity of this result type (info/warning/error)
            "result_message": "Row 1 is defective: there are more cells than headers", # a message that describes the result
            "result_name": "Defective Row", # a human-readable title for this result
            "result_context": ['38', 'John', '', ''], # the row values from which this result triggered
            "row_index": 1, # the index of the row
            "row_name": "", # If the row has an id field, this is displayed, otherwise empty
            "column_index": 4, # the index of the column
            "column_name": "" # the name of the column (the header), if applicable
            },
            ...
        ]
    }
}
```

### UI

The UI is a simple form to add data, with an option schema, from either URLs or uploaded files.

#### Example

<img src="https://dl.dropboxusercontent.com/u/13029373/okfn/ui.gif" />


### Automating deployment using habitat

[Habitat](https://www.habitat.sh/) helps package an app or service into containers that can be run in any infrastructure, without committing to a specific container format or platform.

#### Installing habitat
To install habitat, simply download the binary.
* Unzip `hab` into `/usr/local/bin`. To do this:
    * Unzip the downloaded folder
    * Navigate to the unzipped folder by running `cd` followed by the file location
        * For example: `cd /Users/Rachel/Downloads/hab-0.28.0-20170729010833-x86_64-darwin`
        (If you're using a Mac, you can insert the location by dragging the unzipped file into the terminal)
    * Run `cp hab /usr/local/bin`
        * If you receive an error saying Permission Denied, run `sudo cp hab /usr/local/bin`
* Run `sudo chmod a+x hab` to make it executable.
* You'll also need docker installed if on Mac. Find docker [here](https://store.docker.com/editions/community/docker-ce-desktop-mac)
* To confirm if habitat is installed, re-open your terminal and type `hab` then press enter. You should see a list menu with all the habitat options available. Moving on swiftly!


#### Setup a habitat origin
* Run `hab setup` and set the origin name to **`brighthive`**.
* Go to Settings on your github account and create a Personal Access Token under Developer Settings. Here's a link to get you [there](https://github.com/settings/tokens/new).

The GitHub personal access token needs information provided from the `user:email` and `read:org` OAuth scopes. Habitat uses the information provided through these scopes for authentication and to determine features based on team membership.

This is how it should look like when running the setup:
<img width="636" alt="screenshot 2017-07-28 18 18 26" src="https://user-images.githubusercontent.com/15085180/28724015-5ac259ca-73c1-11e7-9eda-94e1fe74b3f2.png">


#### Running etp-uploader using habitat
* Cd into the repo's directory
```bash
cd etp-uploader
```

* Enter the habitat studio
```bash
hab studio enter
```
This is an awesome isolated environment for building great things so that when building, it doesn't affect anything on your computer.
Let's go ahead and build the etp-uploader!

* Inside the studio, run the `build` command to execute the etp-uploader plan
```bash
[5][default:/src:0]# build
```
When finished building, you should see this message
`etp-uploader: I love it when a plan.sh comes together.`

The build bundles up the etp-uploader source code, dependencies, runtime and other server configurations into a habitat .hart package. This package can now be exported to docker.

In linux environments, the package can then be run directly using this simple command:
```bash
$ hab start brighthive/etp-uploader
```

#### Exporting to docker
You can export the created .hart package into a docker container using the `hab pkg export docker` command as follows:

```bash
[5][default:/src:0]# hab pkg export docker brighthive/etp-uploader
```

#### Run it!
After exiting the studio by typing `exit`, run the docker container as follows:

```bash
$ docker run -it -p 5000:5000 brighthive/etp-uploader
```
We're cooking with gas! 🔥 🚀
