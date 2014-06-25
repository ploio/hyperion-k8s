# Copyright (C) 2014  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import logging
#import os
import unittest

import docker
import requests
from requests import exceptions

#from hyperiontests import settings


logger = logging.getLogger(__name__)


class HyperionTestCase(unittest.TestCase):

    tmp_imgs = []
    tmp_containers = []
    host = ''
    port = ''

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        pass

    def setUp(self):
        self.client = docker.Client()
        # host = os.getenv('HYPERION_HOST', settings.HYPERION_HOST)
        # self._host = "http://%s:%s" % (host, self.port)
        #settings.HYPERION_WEB)

    def http_get(self, uri, username=None, password=None):
        """Perform a HTTP GET request.

        :param uri: URL for the new Request object
        """
        try:
            print("GET: %s/%s" % (self._host, uri))
            if username is not None and password is not None:
                return requests.get('%s/%s' % (self._host, uri),
                                    auth=(username, password))
            else:
                return requests.get('%s/%s' % (self._host, uri))
        except exceptions.RequestException as e:
            print ("\033[0;31m%s \033[00m: %s" % ("Error", e))
