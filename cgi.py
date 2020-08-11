#!/usr/bin/python3

import signal
from http.server import HTTPServer, HTTPStatus, CGIHTTPRequestHandler

HOST = '127.0.0.1'
PORT = 65432

class Handler(CGIHTTPRequestHandler):
    cgi_directories = ['/cgi']

    def end_headers(self):
        self.send_header('Pragma', 'no-cache')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Expires', 'Thu, 01 Jan 1970 00:00:00 GMT')
        self.send_header('Robots', 'noindex, nofollow, noarchive')
        self.send_header('X-UA-Compatible', 'IE=edge, chrome=1')
        self._headers_buffer.append(b'\r\n')
        self.flush_headers()

    def list_directory(self, path):
        self.send_error(HTTPStatus.FORBIDDEN,
            'CGI script is not a plain file (%r)' % self.path)
        return None

def stop_serving(signum, frame):
    httpd.server_close()
    print('\r[Service stopped]')
    exit()

httpd = HTTPServer((HOST, PORT), Handler)
signal.signal(signal.SIGINT, stop_serving)
signal.signal(signal.SIGTERM, stop_serving)

print('[Starting service]')
httpd.serve_forever()
