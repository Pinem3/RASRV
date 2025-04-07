from flask import Flask, jsonify
from flask_cors import CORS
from models import db
from config import Config
import os
import socket
from routes.equipment import equipment_bp
from routes.production import production_bp
from routes.logs import logs_bp
from routes.user import user_bp
from routes.process import process_bp
from routes.materials import materials_bp

from threading import Thread

def start_socket_server(host='127.0.0.1', port=5000):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((host, port))
        s.listen()
        print(f"Socket server listening on {host}:{port}")

        while True:
            conn, addr = s.accept()
            client_thread = Thread(target=handle_client, args=(conn, addr))
            client_thread.start()

def handle_client(conn, addr):
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = conn.recv(1024)  # Буфер 1024 байта
            if not data:
                break
            
            # Декодируем строку (предполагаем UTF-8)
            received_str = data.decode('utf-8').strip()
            print(f"Received: {received_str}")
            if (received_str == f"Производство запущено"):
                for i in range (1, 5):
                    equipment_bp.update_equipment(i)

            
            # Пример обработки (можно добавить логику для вашей системы)
            if received_str == "get_equipment":
                response = "Equipment list: Mixer, Conveyor"
            else:
                response = f"ECHO: {received_str}"
            
            conn.sendall(response.encode('utf-8'))


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Инициализация расширений
    db.init_app(app)
    CORS(app)

    app.register_blueprint(equipment_bp, url_prefix='/api')
    app.register_blueprint(production_bp, url_prefix='/api')
    app.register_blueprint(logs_bp, url_prefix='/api')
    app.register_blueprint(user_bp, url_prefix='/api')
    app.register_blueprint(process_bp, url_prefix='/api')
    app.register_blueprint(materials_bp, url_prefix='/api')

    # Создание таблиц при первом запуске
    with app.app_context():
        db.create_all()

    # Простой маршрут для проверки работы сервера
    @app.route('/api/endpoint')
    def test_db():
        try:
            db.session.execute("SELECT 1")
            return "Подключение к БД успешно!"
        except Exception as e:
            return f"Ошибка подключения: {str(e)}", 500
    return app


if __name__ == '__main__':
    start_socket_server()
    app = create_app()
    app.run(host='127.0.0.1', port=5000, debug=True)