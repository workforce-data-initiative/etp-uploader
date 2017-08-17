# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import boto3
from flask import request, views, render_template
from goodtables.utilities import helpers
from ..commons import view_mixins
from . import forms


class Main(views.MethodView):

    """Return the front page."""

    template = 'pages/main.html'
    form_class = forms.RunForm

    def get_data(self, **kwargs):
        return {
            'form': self.form_class()
        }

    def get(self, **kwargs):
        return render_template(self.template, **self.get_data(**kwargs))


class Report(views.MethodView, view_mixins.RunPipelineMixin):

    """Return a Report."""

    template = 'pages/report.html'
    form_class = forms.RunForm

    def get_data(self, **kwargs):

        return {
            'form': self.form_class(),
            'report': None,
            'permalinks': {},
            'url_state': '',
        }

    def get(self, **kwargs):
        data = self.get_data(**kwargs)

        if request.args:
            data.update(self.run_pipeline(with_permalinks=True))
            data.update(self._process_report_data(data['report']))

        return render_template(self.template, **data)

    def post(self, **kwargs):
        data = self.get_data(**kwargs)

        if data['form'].validate_on_submit():
            data.update(self.run_pipeline(with_permalinks=True))
            data.update(self._process_report_data(data['report']))
            if data['permalinks']:
                data['url_state'] = data['permalinks']['html'].strip(request.url)

        if data['success']:
            session = boto3.session.Session(
                aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
                aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY']
            )
            stream = data['form'].data_file.data.stream
            stream.seek(0)
            session.resource('s3').Bucket(os.environ['AWS_S3_BUCKET_NAME']).put_object(Key='test.csv', Body=stream)

        return render_template(self.template, **data)

    def _process_report_data(self, report):

        grouped_results = report['results'][:20]

        result_count = len(grouped_results)

        if result_count > 20:
            result_detail_phrase = 'first {0}'.format(result_count)
        else:
            result_detail_phrase = '{0}'.format(result_count)

        bad_cell_count = 0

        processed = {
            'error_title': report.get('error_title'),
            'error_message': report.get('error_message'),
            'meta': report['meta'],
            'columns': report['meta'].get('columns', []),
            'header_index': report['meta'].get('header_index'),
            'row_count': report['meta'].get('row_count'),
            'column_count': len(report['meta'].get('columns', [])),
            'bad_cell_count': bad_cell_count,
            'grouped_results': grouped_results,
            'result_count': result_count,
            'result_detail_phrase': result_detail_phrase
        }

        return processed

class Upload(views.MethodView, view_mixins.RunPipelineMixin):

    """Return upload success."""

    template = 'pages/upload.html'
    form_class = forms.RunForm

    def get_data(self, **kwargs):

        return {
            'form': self.form_class(),
        }

    def post(self, **kwargs):
        return render_template(self.template)


class Help(views.MethodView):

    """Return a Help page."""

    template = 'pages/help.html'

    def get_data(self, **kwargs):

        return {
            'result_types': helpers.get_report_result_types()
        }

    def get(self, **kwargs):
        return render_template(self.template, **self.get_data(**kwargs))


class Pricing(views.MethodView):

    """Return a Pricing page."""

    template = 'pages/pricing.html'

    def get_data(self, **kwargs):

        return {}

    def get(self, **kwargs):
        return render_template(self.template, **self.get_data(**kwargs))
