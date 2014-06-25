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


from hyperiontests import hyperion
from hyperiontests import settings


class TestInfluxDB(hyperion.HyperionTestCase):

    def setUp(self):
        super(TestInfluxDB, self).setUp()
        self._host = "http://%s:%s" % (settings.HYPERION_HOST,
                                       settings.HYPERION_INFLUXDB)

    def _influxdb_request(self, uri):
        response = self.http_get(uri, 'root', 'root')
        self.assertEqual(200, response.status_code)
        self.assertEqual("application/json",
                         response.headers.get("Content-Type"))
        content = response.json()
        print(content)
        return content

    def test_can_retrieve_influxdb_db(self):
        content = self._influxdb_request('db')
        self.assertEqual(0, len(content))

    def test_can_retrieve_admin_clusters(self):
        content = self._influxdb_request('cluster_admins')
        self.assertEqual(1, len(content))
        self.assertEqual('root', content[0]['name'])
