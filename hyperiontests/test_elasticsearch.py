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


class TestElasticsearch(hyperion.HyperionTestCase):

    def test_can_retrieve_elasticsearch_status(self):
        response = self.http_get("elasticsearch/")
        self.assertEqual(200, response.status_code)
        self.assertEqual("application/json; charset=UTF-8",
                         response.headers.get("Content-Type"))
        content = response.json()
        print(content)
        self.assertEqual(200, content['status'])
        self.assertEqual("1.1.1", content['version']['number'])
