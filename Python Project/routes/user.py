from flask import Blueprint, request, jsonify
from models import db, User
from datetime import datetime

user_bp = Blueprint('user', __name__)


@user_bp.route('/user', methods=['POST'])
def add_user():
    data = request.get_json()

    new_user = User(
        username=data['username'],
        password=data['password'],  # В реальном приложении нужно хешировать пароль
        position=data['position'],
        system_entry=datetime.now(),
        system_exit=datetime.now()
    )

    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User added successfully'}), 201