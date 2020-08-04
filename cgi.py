#!/usr/bin/python3

import signal
from http.server import HTTPServer, HTTPStatus, CGIHTTPRequestHandler

HOST = '127.0.0.1'
PORT = 65432

class Handler(CGIHTTPRequestHandler):
    cgi_directories = ['/cgi']
    def list_directory(self, path):
        self.send_error(HTTPStatus.FORBIDDEN,
            "CGI script is not a plain file (%r)" % self.path)
        return None

def receive_signal(code, frame):
    httpd.server_close()
    print('Service stopped')
    exit()

httpd = HTTPServer((HOST, PORT), Handler)
signal.signal(signal.SIGTERM, receive_signal)
print('Starting service...')
httpd.serve_forever()
