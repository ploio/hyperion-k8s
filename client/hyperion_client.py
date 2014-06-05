#!/usr/bin/env python

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

import argparse
import os
import time

import psutil
import statsd


def io_change(last, current):
    return dict([(f, getattr(current, f) - getattr(last, f))
                 for f in last._fields])


def send_stats(client):
    last_disk_io = psutil.disk_io_counters()
    last_net_io = psutil.net_io_counters()

    while True:
        memory = psutil.phymem_usage()
        disk = psutil.disk_usage("/")
        disk_io = psutil.disk_io_counters()
        disk_io_change = io_change(last_disk_io, disk_io)
        net_io = psutil.net_io_counters()
        net_io_change = io_change(last_net_io, net_io)
        last_disk_io = disk_io
        last_net_io = net_io

        gauges = {
            "memory.used": memory.used,
            "memory.free": memory.free,
            "memory.percent": memory.percent,
            "cpu.percent": psutil.cpu_percent(),
            "load": os.getloadavg()[0],
            "disk.size.used": disk.used,
            "disk.size.free": disk.free,
            "disk.size.percent": disk.percent,
            "disk.read.bytes": disk_io_change["read_bytes"],
            "disk.read.time": disk_io_change["read_time"],
            "disk.write.bytes": disk_io_change["write_bytes"],
            "disk.write.time": disk_io_change["write_time"],
            "net.in.bytes": net_io_change["bytes_recv"],
            "net.in.errors": net_io_change["errin"],
            "net.in.dropped": net_io_change["dropin"],
            "net.out.bytes": net_io_change["bytes_sent"],
            "net.out.errors": net_io_change["errout"],
            "net.out.dropped": net_io_change["dropout"],
        }

        thresholds = {
            "memory.percent": 80,
            "disk.size.percent": 90,
            "queue.pending": 20000,
            "load": 20,
        }

        for name, value in gauges.items():
            print(name, value)
            client.gauge(name, value)
            threshold = thresholds.get(name, None)
            if threshold is not None and value > threshold:
                bits = (threshold, name)
                message = "Threshold of %s reached for %s" % bits
                print(message)

        time.sleep(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Hyperion statsd client.')
    parser.add_argument('-s', '--server',
                        type=str,
                        help=' The statsd host to connect to, defaults to localhost',
                        default='localhost')
    parser.add_argument('-p', '--port',
                        type=int,
                        help='The statsd port to connect to, defaults to 8125',
                        default=8125)
    args = vars(parser.parse_args())
    client = statsd.StatsClient(args['server'], args['port'])
    time.sleep(1)
    send_stats(client)
