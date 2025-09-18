from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World! Welcome to Google I/O Extended - Cloud Run Demo!'

@app.route('/hello/<name>')
def hello_name(name):
    return f'Hello, {name}! Welcome to the Cloud Run workshop!'

@app.route('/health')
def health_check():
    return {'status': 'healthy', 'service': 'Cloud Run Demo App'}, 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(debug=False, host='0.0.0.0', port=port)