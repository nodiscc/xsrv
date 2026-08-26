#!/usr/bin/env python3
"""Minimal SMTP server that accepts mail and prints it to stdout."""

import socketserver


class SMTPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        self.send("220 dummy-smtp ready")
        mail_from = None
        rcpt_to = []
        data_lines = []
        expecting_data = False

        while True:
            line = self.request.recv(1024).decode(errors="replace").strip()
            if not line:
                break

            if expecting_data:
                if line == ".":
                    expecting_data = False
                    print(f"=== Mail from {mail_from} to {', '.join(rcpt_to)} ===")
                    print("".join(data_lines))
                    print("===\n")
                    self.send("250 OK")
                else:
                    data_lines.append(line + "\r\n")
            elif line.upper().startswith("EHLO") or line.upper().startswith("HELO"):
                self.send("250 Hello")
            elif line.upper().startswith("MAIL FROM:"):
                mail_from = line.split(":", 1)[1].strip()
                self.send("250 OK")
            elif line.upper().startswith("RCPT TO:"):
                rcpt_to.append(line.split(":", 1)[1].strip())
                self.send("250 OK")
            elif line.upper() == "DATA":
                expecting_data = True
                data_lines = []
                self.send("354 Start mail input")
            elif line.upper() == "QUIT":
                self.send("221 Bye")
                break

    def send(self, line):
        self.request.sendall((line + "\r\n").encode())


if __name__ == "__main__":
    with socketserver.ThreadingTCPServer(("127.0.0.1", 2525), SMTPHandler) as server:
        server.serve_forever()
