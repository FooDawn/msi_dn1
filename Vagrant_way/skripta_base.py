import base64
f = open("base64_zapis.txt", "w")
with open('config', 'r') as file:
    message = file.read()
    print(message)
    message_bytes = message.encode('utf-8')
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode('ascii')
    print(base64_message)
    f.write(base64_message)


f.close()
