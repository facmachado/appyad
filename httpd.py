#!/usr/bin/python3

#
#  Copyright (c) 2020 Flavio Augusto (@facmachado)
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#

import signal
from http.server import HTTPServer, HTTPStatus, CGIHTTPRequestHandler

HOST = '127.0.0.1'
PORT = 65432

class Handler(CGIHTTPRequestHandler):
    cgi_directories = ['/cgi']

    def do_GET(self):
        if '/public/' in self.path:
            f = self.send_head()
            if f:
                try:
                    self.copyfile(f, self.wfile)
                finally:
                    f.close()
        else:
            self.send_error(HTTPStatus.NOT_IMPLEMENTED,
                            'Can only GET to non-CGI documents')

    def list_directory(self, path):
        pass

    def send_response(self, code, message=None):
        self.log_request(code)
        self.send_response_only(code, message)
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', 'Thu, 01 Jan 1970 00:00:00 GMT')
        self.send_header('Robots', 'noindex, nofollow, noarchive')
        self.send_header('X-UA-Compatible', 'IE=edge, chrome=1')

def stop_serving(signum, frame):
    httpd.server_close()
    print('\r[Service stopped]')
    exit()

httpd = HTTPServer((HOST, PORT), Handler)
signal.signal(signal.SIGINT, stop_serving)
signal.signal(signal.SIGTERM, stop_serving)

print('[Starting service]')
httpd.serve_forever()
