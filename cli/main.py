# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import sys
import click
import requests


@click.group()
def cli():
    """The entry point into the CLI."""


@cli.command()
@click.argument('instance_url')
@click.argument('payload')
def examples(instance_url, payload):
    """Run some example data against a public instance of tvweb."""

    payloads = {
        'one': {
            'data': 'https://raw.githubusercontent.com/okfn/tabular-validator-web/master/examples/valid.csv',
            'schema': ''
        },
        'two': {
            'data': 'https://raw.githubusercontent.com/okfn/tabular-validator/master/examples/contacts/people.csv',
            'schema': 'https://raw.githubusercontent.com/okfn/tabular-validator/master/examples/contacts/schema_valid.json'
        },
        'three': {
            'data': 'https://raw.githubusercontent.com/okfn/tabular-validator/master/examples/contacts/people.csv',
            'schema': 'https://raw.githubusercontent.com/okfn/tabular-validator/master/examples/contacts/schema_invalid.json'
        }
    }

    if payload in payloads.keys():
        payload = payloads[payload]
        job_list = '/api/run'
        endpoint = '{0}{1}'.format(instance_url, job_list)
        click.echo('Running example against {0}'.format(endpoint))
        response = requests.post(endpoint, payload)
        click.echo(response.text)
    else:
        click.echo('Invalid payload')


if __name__ == '__main__':
    cli()
