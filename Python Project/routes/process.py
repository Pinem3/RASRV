from flask import Blueprint, request, jsonify
from models import db, Process

process_bp = Blueprint('Process', __name__)


@process_bp.route('/process', methods=['GET'])
def get_process():
    process_list = Process.query.all()
    return jsonify([{
        'processID': eq.process_id,
        'status': eq.status,
        'name': eq.name,
        'duration': eq.duration,
    } for eq in process_list])


@process_bp.route('/process', methods=['POST'])
def add_process():
    data = request.get_json()
    new_process = Process(
        process_id=data['processID'],
        status=data['status'],
        name=data['name'],
        duration=data['duration'],
    )
    db.session.add(new_process)
    db.session.commit()
    return jsonify({'message': 'Process added successfully'}), 201


@process_bp.route('/process/<int:process_id>', methods=['PUT'])
def update_process(process_id):
    process = Process.query.get_or_404(process_id)
    data = request.get_json()

    process.status = data.get('status', process.status)
    process.name = data.get('name', process.name)
    process.process_class = data.get('class', process.process_class )

    db.session.commit()
    return jsonify({'message': 'Process updated successfully'})


@process_bp.route('/process/<int:process_id>', methods=['DELETE'])
def delete_process(process_id):
    process = Process.query.get_or_404(process_id)
    db.session.delete(process)
    db.session.commit()
    return jsonify({'message': 'Process deleted successfully'})