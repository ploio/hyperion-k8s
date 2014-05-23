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

import redis

from hyperiontests import hyperion


class TestRedis(hyperion.HyperionTestCase):

    def test_can_retrieve_informations(self):
        redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
        content = redis_client.info()
        #print(content)
        self.assertEqual('2.8.4', content['redis_version'])
        self.assertEqual('/src/redis/redis.conf', content['config_file'])
